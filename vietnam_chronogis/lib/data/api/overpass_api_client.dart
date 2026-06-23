// lib/data/api/overpass_api_client.dart
// Production-grade Overpass client with:
// - throttling / rate-limiter
// - exponential backoff + jitter
// - respect Retry-After
// - chunking strategy (no full-country single query)
// - in-memory + file cache (TTL)
// - dedupe concurrent identical queries
// - cancellation support

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final overpassApiClientProvider = Provider<OverpassApiClient>((ref) {
  return OverpassApiClient();
});

// Immutable minimal model for Overpass results (keeps small and serializable)
class OverpassPlace {
  final int id;
  final double lat;
  final double lon;
  final String name;
  final Map<String, String> tags;

  const OverpassPlace({
    required this.id,
    required this.lat,
    required this.lon,
    required this.name,
    required this.tags,
  });

  factory OverpassPlace.fromElement(Map<String, dynamic> e) {
    final tags = Map<String, String>.from(
      (e['tags'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, v.toString()),
      ),
    );

    final lat =
        (e['lat'] as num?)?.toDouble() ??
        (e['center']?['lat'] as num?)?.toDouble() ??
        0.0;
    final lon =
        (e['lon'] as num?)?.toDouble() ??
        (e['center']?['lon'] as num?)?.toDouble() ??
        0.0;
    final name = tags['name'] ?? tags['name:en'] ?? tags['name:vi'] ?? '';

    return OverpassPlace(
      id: e['id'] as int,
      lat: lat,
      lon: lon,
      name: name,
      tags: tags,
    );
  }
}

/// Simple cancellation token
class CancelToken {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}

/// Rate limiter using sliding window (requests per minute)
class RateLimiter {
  final int maxRequestsPerMinute;
  final List<DateTime> _timestamps = [];

  RateLimiter({this.maxRequestsPerMinute = 60});

  Future<void> acquire() async {
    while (true) {
      final now = DateTime.now();
      _timestamps.removeWhere((t) => now.difference(t).inSeconds >= 60);
      if (_timestamps.length < maxRequestsPerMinute) {
        _timestamps.add(now);
        return;
      }
      // Sleep until the oldest timestamp exits the window
      final waitFor = 60 - now.difference(_timestamps.first).inSeconds;
      final delay = Duration(seconds: waitFor.clamp(1, 10));
      await Future.delayed(delay);
    }
  }
}

class OverpassApiClient {
  // Public endpoints prioritized
  static const List<String> endpoints = [
    'https://lz4.overpass-api.de/api/interpreter',
    'https://z.overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
  ];

  final HttpClient _httpClient;
  final RateLimiter _rateLimiter;
  final Map<String, _CachedEntry> _memoryCache = {};
  final Map<String, Future<List<OverpassPlace>>> _inflight = {};

  OverpassApiClient({HttpClient? httpClient, RateLimiter? rateLimiter})
    : _httpClient = httpClient ?? HttpClient(),
      _rateLimiter = rateLimiter ?? RateLimiter(maxRequestsPerMinute: 30);

  /// Public: fetch POI in a bbox using optimized Overpass query (nodes + ways only)
  /// bbox params: lonMin, latMin, lonMax, latMax
  Future<List<OverpassPlace>> fetchByBbox({
    required double lonMin,
    required double latMin,
    required double lonMax,
    required double latMax,
    CancelToken? cancelToken,
    Duration cacheTtl = const Duration(hours: 24),
  }) async {
    final key = 'bbox:$lonMin,$latMin,$lonMax,$latMax';

    // Dedupe concurrent identical requests
    if (_inflight.containsKey(key)) {
      return _inflight[key]!;
    }

    final completer = Completer<List<OverpassPlace>>();
    _inflight[key] = completer.future;

    try {
      // Try memory/file cache first
      final cached = await _readCacheIfFresh(key, cacheTtl);
      if (cached != null) {
        completer.complete(cached);
        return completer.future;
      }

      // Build a conservative query (no relations, out tags center → lower cost)
      final query = _buildBboxQuery(lonMin, latMin, lonMax, latMax);
      final places = await _executeWithRetries(query, cancelToken: cancelToken);

      // Save to memory + file cache
      await _writeCache(key, places);

      completer.complete(places);
      return completer.future;
    } catch (e) {
      if (!completer.isCompleted) completer.completeError(e);
      rethrow;
    } finally {
      _inflight.remove(key);
    }
  }

  /// A safe way to seed the whole country: split into a small grid and fetch each cell.
  /// Caller should persist results in DB (avoid storing everything in memory here).
  Future<List<OverpassPlace>> fetchVietnamGrid({
    int cols = 4,
    int rows = 4,
    CancelToken? cancelToken,
  }) async {
    // Vietnam bounding box conservative
    const lonMin = 102.14, latMin = 8.18, lonMax = 109.46, latMax = 23.39;
    final lonStep = (lonMax - lonMin) / cols;
    final latStep = (latMax - latMin) / rows;

    final results = <OverpassPlace>{};
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (cancelToken?.isCancelled == true) return results.toList();
        final lMin = lonMin + c * lonStep;
        final lMax = lonMin + (c + 1) * lonStep;
        final bMin = latMin + r * latStep;
        final bMax = latMin + (r + 1) * latStep;

        try {
          final cell = await fetchByBbox(
            lonMin: lMin,
            latMin: bMin,
            lonMax: lMax,
            latMax: bMax,
            cancelToken: cancelToken,
            cacheTtl: const Duration(days: 7),
          );
          for (final p in cell) {
            results.add(p);
          }
        } catch (e) {
          debugPrint('OverpassApi: cell fetch failed ($c,$r): $e');
          // Continue with other cells — resilient seeding
        }
        // brief delay between cells to reduce burstiness
        await Future.delayed(const Duration(milliseconds: 600));
      }
    }
    return results.toList();
  }

  /// Fetch secondary/high schools (THPT) inside bbox from OpenStreetMap.
  Future<List<OverpassPlace>> fetchSchoolsByBbox({
    required double lonMin,
    required double latMin,
    required double lonMax,
    required double latMax,
    CancelToken? cancelToken,
    Duration cacheTtl = const Duration(hours: 24),
  }) async {
    final key = 'schools:$lonMin,$latMin,$lonMax,$latMax';

    if (_inflight.containsKey(key)) {
      return _inflight[key]!;
    }

    final completer = Completer<List<OverpassPlace>>();
    _inflight[key] = completer.future;

    try {
      final cached = await _readCacheIfFresh(key, cacheTtl);
      if (cached != null) {
        completer.complete(cached);
        return completer.future;
      }

      final query = _buildSchoolBboxQuery(lonMin, latMin, lonMax, latMax);
      final places = await _executeWithRetries(query, cancelToken: cancelToken);
      final thptOnly = places.where(_isThptSchool).toList();

      await _writeCache(key, thptOnly);
      completer.complete(thptOnly);
      return completer.future;
    } catch (e) {
      if (!completer.isCompleted) completer.completeError(e);
      rethrow;
    } finally {
      _inflight.remove(key);
    }
  }

  static bool _isThptSchool(OverpassPlace place) {
    final tags = place.tags;
    final name = place.name.toLowerCase();
    final level = (tags['school:level'] ?? tags['isced:level'] ?? '').toLowerCase();

    if (level == 'secondary' || level == '3') return true;
    if (name.contains('thpt') ||
        name.contains('trung học phổ thông') ||
        name.contains('trung hoc pho thong')) {
      return true;
    }
    if (tags['amenity'] == 'school' &&
        (tags['school:FR'] == 'secondary' || tags['school:type'] == 'secondary')) {
      return true;
    }
    return false;
  }

  String _buildSchoolBboxQuery(
    double lonMin,
    double latMin,
    double lonMax,
    double latMax, {
    int timeout = 60,
  }) {
    final bbox = '$latMin,$lonMin,$latMax,$lonMax';
    return '''[out:json][timeout:$timeout];(
      node["amenity"="school"]($bbox);
      way["amenity"="school"]($bbox);
    );out tags center;''';
  }

  String _buildBboxQuery(
    double lonMin,
    double latMin,
    double lonMax,
    double latMax, {
    int timeout = 60,
  }) {
    final bbox = '$latMin,$lonMin,$latMax,$lonMax';
    // Use nodes and ways only, request tags + center for ways (cheaper than relations)
    return '''[out:json][timeout:$timeout];(
      node["tourism"~"attraction|museum|viewpoint|zoo|theme_park|tourist_site"]($bbox);
      node["historic"~"ruins|archaeological_site"]($bbox);
      way["tourism"~"attraction|museum|viewpoint"]($bbox);
      way["historic"~"ruins|archaeological_site"]($bbox);
    );out tags center;''';
  }

  Future<List<OverpassPlace>> _executeWithRetries(
    String query, {
    CancelToken? cancelToken,
    int maxRetries = 5,
  }) async {
    // Choose endpoints in round-robin order
    for (
      int endpointIndex = 0;
      endpointIndex < endpoints.length;
      endpointIndex++
    ) {
      final endpoint = endpoints[endpointIndex % endpoints.length];
      int attempt = 0;
      while (attempt <= maxRetries) {
        if (cancelToken?.isCancelled == true) throw Exception('Cancelled');
        try {
          // Throttle requests
          await _rateLimiter.acquire();

          final resp = await _sendOverpassRequest(
            endpoint,
            query,
          ).timeout(const Duration(seconds: 90));

          if (cancelToken?.isCancelled == true) throw Exception('Cancelled');

          final status = resp.statusCode;
          final body = await utf8.decoder.bind(resp).join();

          if (status == 200) {
            final data = jsonDecode(body) as Map<String, dynamic>?;
            if (data == null || data['elements'] is! List) return [];
            final elements = (data['elements'] as List<dynamic>);
            final places = <OverpassPlace>[];
            for (final el in elements) {
              try {
                final p = OverpassPlace.fromElement(el as Map<String, dynamic>);
                if (p.name.isNotEmpty && p.lat != 0 && p.lon != 0) {
                  places.add(p);
                }
              } catch (e) {
                debugPrint('OverpassApi: parse element error: $e');
              }
            }
            debugPrint(
              'OverpassApi: fetched ${places.length} places from $endpoint',
            );
            return places;
          }

          // Handle rate limiting & Retry-After
          if (status == 429 || status == 503) {
            final retryAfter = _parseRetryAfter(resp.headers);
            final backoff = _jitteredBackoff(attempt, extraSeconds: retryAfter);
            debugPrint(
              'OverpassApi: $status from $endpoint — backoff ${backoff.inSeconds}s (retryAfter: ${retryAfter}s)',
            );
            await Future.delayed(backoff);
            attempt++;
            continue;
          }

          // Other non-200 statuses — treat as transient and retry with backoff until exhausted
          final backoff = _jitteredBackoff(attempt);
          debugPrint(
            'OverpassApi: unexpected status $status — backoff ${backoff.inSeconds}s',
          );
          await Future.delayed(backoff);
          attempt++;
        } on SocketException catch (e) {
          final backoff = _jitteredBackoff(attempt);
          debugPrint(
            'OverpassApi: network error: $e — backoff ${backoff.inSeconds}s',
          );
          await Future.delayed(backoff);
          attempt++;
        } on TimeoutException catch (e) {
          final backoff = _jitteredBackoff(attempt);
          debugPrint(
            'OverpassApi: timeout: $e — backoff ${backoff.inSeconds}s',
          );
          await Future.delayed(backoff);
          attempt++;
        } catch (e) {
          debugPrint('OverpassApi: unexpected error: $e');
          rethrow;
        }
      }
      // move to next endpoint after exhausting retries
    }
    return [];
  }

  int _parseRetryAfter(HttpHeaders headers) {
    try {
      final v = headers.value('retry-after');
      if (v == null) return 0;
      final asInt = int.tryParse(v);
      if (asInt != null) return asInt;
      final parsed = HttpDate.parse(v);
      return DateTime.now().difference(parsed).inSeconds.abs();
    } catch (_) {
      return 0;
    }
  }

  Duration _jitteredBackoff(int attempt, {int extraSeconds = 0}) {
    final base = Duration(seconds: 2);
    final pow = (1 << attempt);
    final jitter = Duration(milliseconds: (Random().nextInt(400) + 100));
    final back =
        Duration(seconds: (base.inSeconds * pow) + extraSeconds) + jitter;
    // cap
    final cap = const Duration(minutes: 5);
    return back < cap ? back : cap;
  }

  Future<HttpClientResponse> _sendOverpassRequest(
    String endpoint,
    String query,
  ) async {
    final uri = Uri.parse(endpoint);

    // POST form-encoded first (best practice for large queries)
    final request = await _httpClient.postUrl(uri);
    request.headers
      ..contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
        charset: 'utf-8',
      )
      ..set('Accept', '*/*')
      ..set('User-Agent', 'VietnamChronoGIS/1.0');
    request.write('data=${Uri.encodeQueryComponent(query)}');
    var response = await request.close();

    if (response.statusCode == 200) return response;

    // Try GET fallback (some mirrors prefer GET)
    final getUri = uri.replace(queryParameters: {'data': query});
    final getReq = await _httpClient.getUrl(getUri);
    getReq.headers
      ..set('Accept', '*/*')
      ..set('User-Agent', 'VietnamChronoGIS/1.0');
    response = await getReq.close();
    return response;
  }

  // --- Simple caching (memory + file) helpers ---
  Future<List<OverpassPlace>?> _readCacheIfFresh(
    String key,
    Duration ttl,
  ) async {
    final mem = _memoryCache[key];
    if (mem != null && DateTime.now().difference(mem.ts) <= ttl) {
      return mem.places;
    }
    try {
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/overpass_cache_${Uri.encodeComponent(key)}.json',
      );
      if (!await file.exists()) return null;
      final data =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final ts = DateTime.parse(data['ts'] as String);
      if (DateTime.now().difference(ts) > ttl) return null;
      final list = (data['places'] as List<dynamic>)
          .map((e) => OverpassPlace.fromElement(e as Map<String, dynamic>))
          .toList();
      _memoryCache[key] = _CachedEntry(list, ts);
      return list;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(String key, List<OverpassPlace> places) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/overpass_cache_${Uri.encodeComponent(key)}.json',
      );
      final payload = {
        'ts': DateTime.now().toIso8601String(),
        'places': places
            .map(
              (p) => {
                'id': p.id,
                'lat': p.lat,
                'lon': p.lon,
                'name': p.name,
                'tags': p.tags,
              },
            )
            .toList(),
      };
      await file.writeAsString(jsonEncode(payload));
      _memoryCache[key] = _CachedEntry(places, DateTime.now());
    } catch (e) {
      debugPrint('OverpassApi: cache write failed: $e');
    }
  }
}

class _CachedEntry {
  final List<OverpassPlace> places;
  final DateTime ts;
  _CachedEntry(this.places, this.ts);
}
