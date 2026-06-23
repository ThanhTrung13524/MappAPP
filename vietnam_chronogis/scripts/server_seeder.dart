// Simple server-side seeder script
// Usage: dart run scripts/server_seeder.dart [cols] [rows] [out.json]

import 'dart:convert';
import 'dart:io';

import '../lib/data/api/overpass_api_client.dart';

Future<void> main(List<String> args) async {
  final cols = args.isNotEmpty ? int.tryParse(args[0]) ?? 4 : 4;
  final rows = args.length > 1 ? int.tryParse(args[1]) ?? 4 : 4;
  final outPath = args.length > 2 ? args[2] : 'server_seed_overpass.json';

  final client = OverpassApiClient();
  final token = CancelToken();

  print('Starting server-side seeder: ${cols}x$rows, output=$outPath');
  final places = <Map<String, dynamic>>[];

  // Use fetchVietnamGrid which de-duplicates in client
  try {
    final list = await client.fetchVietnamGrid(
      cols: cols,
      rows: rows,
      cancelToken: token,
    );
    for (final p in list) {
      places.add({
        'id': p.id,
        'lat': p.lat,
        'lon': p.lon,
        'name': p.name,
        'tags': p.tags,
      });
    }

    final outFile = File(outPath);
    await outFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'generated_at': DateTime.now().toIso8601String(),
        'count': places.length,
        'places': places,
      }),
    );
    print('Wrote ${places.length} places to $outPath');
  } catch (e) {
    print('Seeder failed: $e');
    exitCode = 2;
  }
}
