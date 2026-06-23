import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnam_chronogis/data/geojson/vietnam_geo_validator.dart';
import 'package:vietnam_chronogis/shared/models/population_heatmap_value.dart';

void main() {
  group('VietnamGeoValidator', () {
    test('bbox rejects POIs outside Vietnam envelope', () {
      const validator = VietnamGeoValidator();

      expect(validator.isInsideVietnamBBox(16.0, 106.0), isTrue);
      expect(validator.isInsideVietnamBBox(13.7563, 100.5018), isFalse);
      expect(validator.isInsideVietnamBBox(21.0, 101.0), isFalse);
      expect(validator.isInsideVietnamBBox(24.0, 106.0), isFalse);
    });

    test(
      'boundary check accepts inside polygon and rejects outside polygon',
      () {
        const validator = VietnamGeoValidator(
          provincePolygons: [
            [
              [
                LatLng(10, 104),
                LatLng(10, 106),
                LatLng(12, 106),
                LatLng(12, 104),
                LatLng(10, 104),
              ],
            ],
          ],
        );

        expect(validator.isInsideVietnamBoundary(11, 105), isTrue);
        expect(validator.isInsideVietnamBoundary(13, 105), isFalse);
        expect(validator.isValidVietnamPoi(lat: 11, lng: 105), isTrue);
      },
    );

    test('boundary holes reject points inside excluded rings', () {
      const validator = VietnamGeoValidator(
        provincePolygons: [
          [
            [
              LatLng(10, 104),
              LatLng(10, 108),
              LatLng(14, 108),
              LatLng(14, 104),
              LatLng(10, 104),
            ],
            [
              LatLng(11, 105),
              LatLng(11, 106),
              LatLng(12, 106),
              LatLng(12, 105),
              LatLng(11, 105),
            ],
          ],
        ],
      );

      expect(validator.isInsideVietnamBoundary(10.5, 104.5), isTrue);
      expect(validator.isInsideVietnamBoundary(11.5, 105.5), isFalse);
    });
  });

  group('PopulationHeatmapValue', () {
    test('normalizes density defensively', () {
      expect(
        normalizeDensity(value: 150, min: 100, max: 200),
        closeTo(0.5, 0.001),
      );
      expect(normalizeDensity(value: 50, min: 100, max: 200), 0);
      expect(normalizeDensity(value: 250, min: 100, max: 200), 1);
      expect(normalizeDensity(value: 100, min: 100, max: 100), 0);
    });

    test('calculates density from population and area', () {
      const value = PopulationHeatmapValue(
        provinceCode: 'VN-HN',
        population: 1000,
        areaKm2: 10,
      );

      expect(value.density, 100);
    });
  });
}
