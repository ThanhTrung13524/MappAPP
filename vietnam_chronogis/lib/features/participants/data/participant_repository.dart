import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../../core/firebase/firestore_paths.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/campaign_participant.dart';

final participantRepositoryProvider = Provider<ParticipantRepository>((ref) {
  return ParticipantRepository(firestore: ref.watch(firestoreProvider));
});

final participantsProvider =
    StreamProvider.family<List<CampaignParticipant>, String>((ref, campaignId) {
      return ref
          .watch(participantRepositoryProvider)
          .watchParticipants(campaignId);
    });

final currentParticipantProvider =
    StreamProvider.family<CampaignParticipant?, String>((ref, campaignId) {
      final user = ref.watch(authStateProvider).value;
      if (user == null) return Stream.value(null);
      return ref
          .watch(participantRepositoryProvider)
          .watchParticipant(campaignId: campaignId, userId: user.uid);
    });

class ParticipantRepository {
  const ParticipantRepository({required FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  Stream<List<CampaignParticipant>> watchParticipants(String campaignId) {
    final firestore = _firestore;
    if (firestore == null) return Stream.value(const []);
    return firestore
        .collection(FirestorePaths.campaignParticipants(campaignId))
        .orderBy('joinedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(CampaignParticipant.fromFirestore).toList(),
        );
  }

  Stream<CampaignParticipant?> watchParticipant({
    required String campaignId,
    required String userId,
  }) {
    final firestore = _firestore;
    if (firestore == null) return Stream.value(null);
    return firestore
        .doc(FirestorePaths.campaignParticipant(campaignId, userId))
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return CampaignParticipant.fromFirestore(snapshot);
        });
  }

  Future<void> joinCampaign({
    required String campaignId,
    required String userId,
  }) async {
    await requireFirebase(_firestore)
        .doc(FirestorePaths.campaignParticipant(campaignId, userId))
        .set(
          const CampaignParticipant(
            userId: '',
            role: CampaignRole.participant,
            status: ParticipantStatus.pending,
            joinedAt: null,
            approvedAt: null,
            approvedBy: null,
          ).toJoinRequestMap(userId: userId),
          SetOptions(merge: true),
        );
  }

  Future<void> setParticipantStatus({
    required String campaignId,
    required String userId,
    required ParticipantStatus status,
    required CampaignRole role,
    required String approvedBy,
  }) async {
    await requireFirebase(
      _firestore,
    ).doc(FirestorePaths.campaignParticipant(campaignId, userId)).update({
      'status': status.name,
      'role': role.name,
      'approvedAt': status == ParticipantStatus.approved
          ? FieldValue.serverTimestamp()
          : null,
      'approvedBy': approvedBy,
    });
  }
}

final participantActionProvider =
    AsyncNotifierProvider<ParticipantActionNotifier, void>(
      ParticipantActionNotifier.new,
    );

class ParticipantActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> joinCampaign(String campaignId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw StateError('Sign in before joining campaigns.');
      await ref
          .read(participantRepositoryProvider)
          .joinCampaign(campaignId: campaignId, userId: user.uid);
    });
  }

  Future<void> approve({
    required String campaignId,
    required String userId,
    CampaignRole role = CampaignRole.participant,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final approver = ref.read(authStateProvider).value;
      if (approver == null) throw StateError('Sign in before approving.');
      await ref
          .read(participantRepositoryProvider)
          .setParticipantStatus(
            campaignId: campaignId,
            userId: userId,
            status: ParticipantStatus.approved,
            role: role,
            approvedBy: approver.uid,
          );
    });
  }

  Future<void> reject({
    required String campaignId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final approver = ref.read(authStateProvider).value;
      if (approver == null) throw StateError('Sign in before rejecting.');
      await ref
          .read(participantRepositoryProvider)
          .setParticipantStatus(
            campaignId: campaignId,
            userId: userId,
            status: ParticipantStatus.rejected,
            role: CampaignRole.participant,
            approvedBy: approver.uid,
          );
    });
  }
}
