import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../../core/firebase/firestore_paths.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/campaign.dart';

final campaignRepositoryProvider = Provider<CampaignRepository>((ref) {
  return CampaignRepository(firestore: ref.watch(firestoreProvider));
});

final campaignsProvider = StreamProvider<List<Campaign>>((ref) {
  return ref.watch(campaignRepositoryProvider).watchCampaigns();
});

final campaignProvider = StreamProvider.family<Campaign?, String>((
  ref,
  campaignId,
) {
  return ref.watch(campaignRepositoryProvider).watchCampaign(campaignId);
});

class CampaignRepository {
  const CampaignRepository({required FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  Stream<List<Campaign>> watchCampaigns() {
    final firestore = _firestore;
    if (firestore == null) return Stream.value(const []);
    return firestore
        .collection(FirestorePaths.campaigns)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Campaign.fromFirestore).toList());
  }

  Stream<Campaign?> watchCampaign(String campaignId) {
    final firestore = _firestore;
    if (firestore == null) return Stream.value(null);
    return firestore.doc(FirestorePaths.campaign(campaignId)).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return null;
      return Campaign.fromFirestore(snapshot);
    });
  }

  Future<String> createCampaign({
    required Campaign campaign,
    required String ownerId,
  }) async {
    final firestore = requireFirebase(_firestore);
    final doc = await firestore
        .collection(FirestorePaths.campaigns)
        .add(campaign.toCreateMap(ownerId: ownerId));

    await firestore
        .doc(FirestorePaths.campaignParticipant(doc.id, ownerId))
        .set({
          'userId': ownerId,
          'role': 'owner',
          'status': 'approved',
          'joinedAt': FieldValue.serverTimestamp(),
          'approvedAt': FieldValue.serverTimestamp(),
          'approvedBy': ownerId,
        });
    return doc.id;
  }
}

final campaignActionProvider =
    AsyncNotifierProvider<CampaignActionNotifier, void>(
      CampaignActionNotifier.new,
    );

class CampaignActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createCampaign({
    required String title,
    required String description,
    required String schoolId,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw StateError('Sign in before creating campaigns.');
      await ref
          .read(campaignRepositoryProvider)
          .createCampaign(
            ownerId: user.uid,
            campaign: Campaign(
              id: '',
              title: title,
              description: description,
              schoolId: schoolId,
              ownerId: user.uid,
              status: CampaignStatus.published,
              startAt: startAt,
              endAt: endAt,
              createdAt: null,
              updatedAt: null,
            ),
          );
    });
  }
}
