import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_chronogis/features/campaign_events/domain/campaign_event.dart';
import 'package:vietnam_chronogis/features/check_in/domain/check_in_models.dart';
import 'package:vietnam_chronogis/features/managed_schools/domain/managed_school.dart';

void main() {
  group('ManagedSchool Firestore contract', () {
    test('writes location as GeoPoint and active flag', () {
      const school = ManagedSchool(
        id: '',
        name: 'Nguyen Hue High School',
        address: 'Ho Chi Minh City',
        latitude: 10.7769,
        longitude: 106.7009,
        checkInRadiusMeters: 120,
        active: true,
        createdBy: 'creator-1',
        createdAt: null,
        updatedAt: null,
      );

      final map = school.toCreateMap(createdBy: 'creator-1');

      expect(map['location'], isA<GeoPoint>());
      final location = map['location']! as GeoPoint;
      expect(location.latitude, 10.7769);
      expect(location.longitude, 106.7009);
      expect(map['active'], isTrue);
      expect(map['createdBy'], 'creator-1');
      expect(map.containsKey('latitude'), isFalse);
      expect(map.containsKey('longitude'), isFalse);
    });

    test('rejects oversized check-in radius', () {
      final error = ManagedSchool.validate(
        name: 'School',
        latitude: 10,
        longitude: 106,
        checkInRadiusMeters: 1001,
      );

      expect(error, 'Radius must be at most 1000m.');
    });
  });

  group('CampaignEvent Firestore contract', () {
    test('writes schoolId for event-scoped check-in validation', () {
      final now = DateTime.utc(2026, 7, 7, 9);
      final event = CampaignEvent(
        id: '',
        campaignId: 'campaign-1',
        schoolId: 'school-1',
        name: 'Opening event',
        description: 'Welcome',
        startAt: now,
        endAt: now.add(const Duration(hours: 2)),
        checkInOpenAt: now.subtract(const Duration(minutes: 15)),
        checkInCloseAt: now.add(const Duration(hours: 2)),
        checkInRadiusMeters: 150,
        status: CampaignEventStatus.published,
        createdBy: 'owner-1',
        createdAt: null,
        updatedAt: null,
      );

      final map = event.toCreateMap(createdBy: 'owner-1');

      expect(map['schoolId'], 'school-1');
      expect(map['status'], 'published');
      expect(map['checkInRadiusMeters'], 150);
    });
  });

  group('CheckInResult callable contract', () {
    test('accepts canonical success response', () {
      final result = CheckInResult.fromCallable({
        'success': true,
        'distanceMeters': 12.5,
        'message': 'Done',
      });

      expect(result.success, isTrue);
      expect(result.distanceMeters, 12.5);
      expect(result.message, 'Done');
    });

    test('accepts legacy ok response', () {
      final result = CheckInResult.fromCallable({
        'ok': true,
        'distanceMeters': 12.5,
      });

      expect(result.success, isTrue);
      expect(result.message, 'Check-in completed.');
    });
  });
}
