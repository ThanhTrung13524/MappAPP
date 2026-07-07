import 'package:cloud_firestore/cloud_firestore.dart';

enum CampaignEventStatus { draft, published, ongoing, completed, cancelled }

class CampaignEvent {
  const CampaignEvent({
    required this.id,
    required this.campaignId,
    required this.schoolId,
    required this.name,
    required this.description,
    required this.startAt,
    required this.endAt,
    required this.checkInOpenAt,
    required this.checkInCloseAt,
    required this.checkInRadiusMeters,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String campaignId;
  final String schoolId;
  final String name;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime checkInOpenAt;
  final DateTime checkInCloseAt;
  final double? checkInRadiusMeters;
  final CampaignEventStatus status;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive =>
      status == CampaignEventStatus.published ||
      status == CampaignEventStatus.ongoing;

  factory CampaignEvent.fromFirestore(
    String campaignId,
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final now = DateTime.now();
    return CampaignEvent(
      id: snapshot.id,
      campaignId: campaignId,
      schoolId: data['schoolId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      startAt: _dateFromFirestore(data['startAt']) ?? now,
      endAt: _dateFromFirestore(data['endAt']) ?? now,
      checkInOpenAt: _dateFromFirestore(data['checkInOpenAt']) ?? now,
      checkInCloseAt: _dateFromFirestore(data['checkInCloseAt']) ?? now,
      checkInRadiusMeters: (data['checkInRadiusMeters'] as num?)?.toDouble(),
      status: _enumFromName(
        CampaignEventStatus.values,
        data['status'] as String?,
        CampaignEventStatus.draft,
      ),
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: _dateFromFirestore(data['createdAt']),
      updatedAt: _dateFromFirestore(data['updatedAt']),
    );
  }

  Map<String, Object?> toCreateMap({required String createdBy}) {
    return {
      'name': name,
      'schoolId': schoolId,
      'description': description,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'checkInOpenAt': Timestamp.fromDate(checkInOpenAt),
      'checkInCloseAt': Timestamp.fromDate(checkInCloseAt),
      if (checkInRadiusMeters != null)
        'checkInRadiusMeters': checkInRadiusMeters,
      'status': status.name,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, Object?> toUpdateMap() {
    return {
      'name': name,
      'schoolId': schoolId,
      'description': description,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'checkInOpenAt': Timestamp.fromDate(checkInOpenAt),
      'checkInCloseAt': Timestamp.fromDate(checkInCloseAt),
      'checkInRadiusMeters': checkInRadiusMeters,
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

T _enumFromName<T extends Enum>(List<T> values, String? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

DateTime? _dateFromFirestore(Object? value) {
  if (value is Timestamp) return value.toDate();
  return null;
}
