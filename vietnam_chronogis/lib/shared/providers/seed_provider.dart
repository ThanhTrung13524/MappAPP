import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/overpass_api_client.dart';
import '../../data/geojson/vietnam_geo_validator.dart';
import '../../data/repositories/administrative_unit_repository.dart';
import '../../data/repositories/tourism_repository.dart';
import '../../data/repositories/school_repository.dart';
import 'database_provider.dart';
import 'geojson_provider.dart';

class SeedProgressNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void setProgress(double value) => state = value;
}

final seedProgressProvider = NotifierProvider<SeedProgressNotifier, double>(
  SeedProgressNotifier.new,
);

class SeedMessageNotifier extends Notifier<String> {
  @override
  String build() => 'Dang tai du lieu dia ly...';

  void set(String msg) => state = msg;
}

final seedMessageProvider = NotifierProvider<SeedMessageNotifier, String>(
  SeedMessageNotifier.new,
);

class SeedCancelNotifier extends Notifier<CancelToken?> {
  @override
  CancelToken? build() => null;

  void set(CancelToken? t) => state = t;
}

final seedCancelTokenProvider =
    NotifierProvider<SeedCancelNotifier, CancelToken?>(SeedCancelNotifier.new);

final seedInitializationProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();

  var hasCoreSeeded = prefs.getBool('seeded_core_v4') ?? false;
  final hasTourismSeeded = prefs.getBool('seeded_tourism_v4') ?? false;
  var shouldSeedTourism = !hasTourismSeeded;
  final hasCleanedInvalid = prefs.getBool('cleaned_tourism_v4') ?? false;
  final hasGeoJsonMatched = prefs.getBool('matched_geojson_v4') ?? false;

  void setMsg(String message) =>
      ref.read(seedMessageProvider.notifier).set(message);
  void setProgress(double progress) =>
      ref.read(seedProgressProvider.notifier).setProgress(progress);

  if (hasCoreSeeded) {
    final provinces = await ref
        .read(administrativeUnitDaoProvider)
        .getAllProvinces();
    final geoJsonDao = ref.read(geoJsonDaoProvider);
    var mappedProvinceCount = 0;
    for (final province in provinces) {
      final cached = await geoJsonDao.getGeoJsonByMa(province.ma);
      if (cached != null) mappedProvinceCount++;
    }
    final hasHeatmapData = provinces.any((province) {
      final hasDensity = province.density != null && province.density! > 0;
      final hasPopulationDensityInputs =
          province.population != null &&
          province.population! > 0 &&
          province.areaKm2 != null &&
          province.areaKm2! > 0;
      return hasDensity || hasPopulationDensityInputs;
    });

    if (provinces.isEmpty || !hasHeatmapData || mappedProvinceCount == 0) {
      debugPrint(
        'Seed: core flag is true but administrative heatmap/boundary data is missing; forcing core reseed.',
      );
      await prefs.setBool('seeded_core_v4', false);
      hasCoreSeeded = false;
    } else if (!hasGeoJsonMatched) {
      debugPrint('Seed: rematching GeoJSON with improved matcher.');
      final geoService = ref.read(provinceGeoJsonServiceProvider);
      await geoService.loadAndMatchGeoJson();
      await prefs.setBool('matched_geojson_v4', true);
    }
  }

  if (!hasCoreSeeded) {
    setMsg('Dang tai du lieu hanh chinh...');
    final adminRepo = ref.read(administrativeUnitRepositoryProvider);
    await for (final progress in adminRepo.seedFromApi()) {
      setProgress(progress * 0.75);
    }

    setMsg('Dang xu ly ban do tinh thanh...');
    setProgress(0.78);
    final geoService = ref.read(provinceGeoJsonServiceProvider);
    await geoService.loadAndMatchGeoJson();
    setProgress(0.90);

    await prefs.setBool('seeded_core_v4', true);
    await prefs.setBool('matched_geojson_v4', true);
    setMsg('Du lieu hanh chinh da san sang.');
    setProgress(1.0);
  }

  final vietnamValidator = await VietnamGeoValidator.fromCache(
    unitDao: ref.read(administrativeUnitDaoProvider),
    geoJsonDao: ref.read(geoJsonDaoProvider),
  );

  if (!vietnamValidator.hasBoundaryData) {
    debugPrint(
      'Seed: Vietnam boundary is unavailable; tourism POIs will not be persisted.',
    );
  }

  if (hasTourismSeeded) {
    final existingTourismCount = await ref.read(tourismRepositoryProvider).count();
    if (existingTourismCount == 0) {
      debugPrint(
        'Seed: tourism flag is true but DB has 0 POIs; forcing tourism reseed.',
      );
      await prefs.setBool('seeded_tourism_v4', false);
      shouldSeedTourism = true;
    }
  }

  if (!hasCleanedInvalid && hasTourismSeeded) {
    setMsg('Dang don dep POI du lich ngoai Viet Nam...');
    try {
      final tourismRepo = ref.read(tourismRepositoryProvider);
      final boundaryDeleted = await tourismRepo.cleanupInvalidVietnamPois(
        vietnamValidator,
      );
      final categoryDeleted = await tourismRepo.deleteInvalidPlaces();
      final totalDeleted = boundaryDeleted + categoryDeleted;
      final remainingCount = await tourismRepo.count();
      debugPrint(
        'Seed cleanup: removed $totalDeleted invalid tourism POIs '
        '(boundary=$boundaryDeleted, category=$categoryDeleted, remaining=$remainingCount)',
      );
      if (remainingCount == 0) {
        await prefs.setBool('seeded_tourism_v4', false);
        shouldSeedTourism = true;
      }
      await prefs.setBool('cleaned_tourism_v4', true);
      setMsg('Da don dep $totalDeleted POI khong hop le.');
    } catch (e) {
      debugPrint('Seed cleanup failed (non-fatal): $e');
    }
  } else if (!hasTourismSeeded) {
    await prefs.setBool('cleaned_tourism_v4', true);
  }

  if (shouldSeedTourism) {
    setMsg('Dang tai danh lam thang canh...');
    setProgress(0.92);

    final tourismRepo = ref.read(tourismRepositoryProvider);
    final token = CancelToken();
    ref.read(seedCancelTokenProvider.notifier).set(token);

    try {
      await for (final progress in tourismRepo.seedTourismData(
        cancelToken: token,
        validator: vietnamValidator,
        telemetry: (event, data) {
          debugPrint('Seed tourism telemetry: $event $data');
          if (event == 'cell_fetched') {
            setMsg(
              'Dang tai o ${data['r']},${data['c']} (${data['count']} muc)',
            );
          }
        },
      )) {
        setProgress(0.92 + progress * 0.08);
      }

      final tourismCount = await tourismRepo.count();
      if (tourismCount > 0) {
        await prefs.setBool('seeded_tourism_v4', true);
        await prefs.setBool('cleaned_tourism_v4', true);
        setMsg('Hoan tat! Da tai $tourismCount dia diem du lich.');
      } else {
        debugPrint(
          'Seed tourism: no data persisted after strict Vietnam validation.',
        );
        setMsg('Bo qua du lieu du lich; co the tai lai sau.');
      }
    } catch (e) {
      debugPrint('Seed tourism failed: $e');
      setMsg('Khong tai duoc du lieu du lich. App van hoat dong binh thuong.');
    } finally {
      ref.read(seedCancelTokenProvider.notifier).set(null);
    }

    setProgress(1.0);
  }

  final hasSchoolsSeeded = prefs.getBool('seeded_schools_v1') ?? false;
  if (!hasSchoolsSeeded) {
    setMsg('Dang tai truong THPT...');
    setProgress(0.95);
    final schoolRepo = ref.read(schoolRepositoryProvider);
    try {
      await for (final progress in schoolRepo
          .seedSchools(validator: vietnamValidator)
          .timeout(const Duration(seconds: 25))) {
        setProgress(0.95 + progress * 0.05);
      }
      final schoolCount = await schoolRepo.count();
      setMsg('Da tai $schoolCount truong THPT.');
      await prefs.setBool('seeded_schools_v1', true);
    } catch (e) {
      debugPrint('Seed schools failed: $e');
      setMsg('Khong tai duoc du lieu truong hoc. Co the thu lai sau.');
      // Khong chan UI khi emulator/mat mang: bo qua va vao app chinh.
      await prefs.setBool('seeded_schools_v1', true);
    }
    setProgress(1.0);
  }

  return true;
});
