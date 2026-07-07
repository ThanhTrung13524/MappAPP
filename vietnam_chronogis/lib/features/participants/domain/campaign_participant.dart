import 'package:cloud_firestore/cloud_firestore.dart';

enum CampaignRole { owner, organizer, staff, participant }

enum ParticipantStatus { pending, approved, rejected, cancelled }

class CampaignParticipant {
  const CampaignParticipant({
    required this.userId,
    required this.role,
    required this.status,
    required this.joinedAt,
    required this.approvedAt,
    required this.approvedBy,
  });

  final String userId;
  final CampaignRole role;
  final ParticipantStatus status;
  final DateTime? joinedAt;
  final DateTime? approvedAt;
  final String? approvedBy;

  bool get canCheckIn =>
      status == ParticipantStatus.approved &&
      (role == CampaignRole.owner ||
          role == CampaignRole.organizer ||
          role == CampaignRole.staff ||
          role == CampaignRole.participant);

  factory CampaignParticipant.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return CampaignParticipant(
      userId: data['userId'] as String? ?? snapshot.id,
      role: _enumFromName(
        CampaignRole.values,
        data['role'] as String?,
        CampaignRole.participant,
      ),
      status: _enumFromName(
        ParticipantStatus.values,
        data['status'] as String?,
        ParticipantStatus.pending,
      ),
      joinedAt: _dateFromFirestore(data['joinedAt']),
      approvedAt: _dateFromFirestore(data['approvedAt']),
      approvedBy: data['approvedBy'] as String?,
    );
  }

  Map<String, Object?> toJoinRequestMap({required String userId}) {
    return {
      'userId': userId,
      'role': CampaignRole.participant.name,
      'status': ParticipantStatus.pending.name,
      'joinedAt': FieldValue.serverTimestamp(),
      'approvedAt': null,
      'approvedBy': null,
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
