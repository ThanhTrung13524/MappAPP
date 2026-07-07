import 'package:cloud_firestore/cloud_firestore.dart';

enum CampaignStatus { draft, published, ongoing, completed, cancelled }

class Campaign {
  const Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.schoolId,
    required this.ownerId,
    required this.status,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final String schoolId;
  final String ownerId;
  final CampaignStatus status;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive =>
      status == CampaignStatus.published || status == CampaignStatus.ongoing;

  factory Campaign.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final now = DateTime.now();
    return Campaign(
      id: snapshot.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      schoolId: data['schoolId'] as String? ?? '',
      ownerId: data['ownerId'] as String? ?? '',
      status: _enumFromName(
        CampaignStatus.values,
        data['status'] as String?,
        CampaignStatus.draft,
      ),
      startAt: _dateFromFirestore(data['startAt']) ?? now,
      endAt: _dateFromFirestore(data['endAt']) ?? now,
      createdAt: _dateFromFirestore(data['createdAt']),
      updatedAt: _dateFromFirestore(data['updatedAt']),
    );
  }

  Map<String, Object?> toCreateMap({required String ownerId}) {
    return {
      'title': title,
      'description': description,
      'schoolId': schoolId,
      'ownerId': ownerId,
      'status': status.name,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, Object?> toUpdateMap() {
    return {
      'title': title,
      'description': description,
      'schoolId': schoolId,
      'status': status.name,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
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
