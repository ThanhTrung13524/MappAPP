import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../../core/firebase/firestore_paths.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/campaign_event.dart';

final campaignEventRepositoryProvider = Provider<CampaignEventRepository>((
  ref,
) {
  return CampaignEventRepository(firestore: ref.watch(firestoreProvider));
});

final campaignEventsProvider =
    StreamProvider.family<List<CampaignEvent>, String>((ref, campaignId) {
      return ref.watch(campaignEventRepositoryProvider).watchEvents(campaignId);
    });

class CampaignEventRepository {
  const CampaignEventRepository({required FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  Stream<List<CampaignEvent>> watchEvents(String campaignId) {
    final firestore = _firestore;
    if (firestore == null) return Stream.value(const []);
    return firestore
        .collection(FirestorePaths.campaignEvents(campaignId))
        .orderBy('startAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CampaignEvent.fromFirestore(campaignId, doc))
              .toList(),
        );
  }

  Future<String> createEvent({
    required CampaignEvent event,
    required String createdBy,
  }) async {
    final doc = await requireFirebase(_firestore)
        .collection(FirestorePaths.campaignEvents(event.campaignId))
        .add(event.toCreateMap(createdBy: createdBy));
    return doc.id;
  }
}

final campaignEventActionProvider =
    AsyncNotifierProvider<CampaignEventActionNotifier, void>(
      CampaignEventActionNotifier.new,
    );

class CampaignEventActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createEvent({
    required String campaignId,
    required String name,
    required String description,
    required DateTime startAt,
    required DateTime endAt,
    required DateTime checkInOpenAt,
    required DateTime checkInCloseAt,
    double? radiusMeters,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw StateError('Sign in before creating events.');
      await ref
          .read(campaignEventRepositoryProvider)
          .createEvent(
            createdBy: user.uid,
            event: CampaignEvent(
              id: '',
              campaignId: campaignId,
              name: name,
              description: description,
              startAt: startAt,
              endAt: endAt,
              checkInOpenAt: checkInOpenAt,
              checkInCloseAt: checkInCloseAt,
              checkInRadiusMeters: radiusMeters,
              status: CampaignEventStatus.published,
              createdBy: user.uid,
              createdAt: null,
              updatedAt: null,
            ),
          );
    });
  }
}
