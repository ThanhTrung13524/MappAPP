import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_chronogis/features/check_in/domain/check_in_validator.dart';

void main() {
  group('haversineDistanceMeters', () {
    test('returns zero for the same coordinate', () {
      final distance = haversineDistanceMeters(
        lat1: 10.7769,
        lon1: 106.7009,
        lat2: 10.7769,
        lon2: 106.7009,
      );

      expect(distance, closeTo(0, 0.01));
    });

    test('returns expected short distance in meters', () {
      final distance = haversineDistanceMeters(
        lat1: 10.7769,
        lon1: 106.7009,
        lat2: 10.7770,
        lon2: 106.7010,
      );

      expect(distance, greaterThan(10));
      expect(distance, lessThan(25));
    });
  });

  group('isInsideRadius', () {
    test('accepts location inside radius', () {
      expect(
        isInsideRadius(
          distanceMeters: haversineDistanceMeters(
            lat1: 10.7769,
            lon1: 106.7009,
            lat2: 10.7770,
            lon2: 106.7010,
          ),
          radiusMeters: 30,
        ),
        isTrue,
      );
    });

    test('rejects location outside radius', () {
      expect(
        isInsideRadius(
          distanceMeters: haversineDistanceMeters(
            lat1: 10.7769,
            lon1: 106.7009,
            lat2: 10.7800,
            lon2: 106.7050,
          ),
          radiusMeters: 30,
        ),
        isFalse,
      );
    });
  });

  group('isInsideTimeWindow', () {
    test('accepts inclusive time window', () {
      final now = DateTime.utc(2026, 6, 24, 12);

      expect(
        isInsideTimeWindow(
          now: now,
          opensAt: now.subtract(const Duration(minutes: 1)),
          closesAt: now.add(const Duration(minutes: 1)),
        ),
        isTrue,
      );
    });

    test('rejects closed time window', () {
      final now = DateTime.utc(2026, 6, 24, 12);

      expect(
        isInsideTimeWindow(
          now: now,
          opensAt: now.subtract(const Duration(hours: 2)),
          closesAt: now.subtract(const Duration(hours: 1)),
        ),
        isFalse,
      );
    });
  });
}
