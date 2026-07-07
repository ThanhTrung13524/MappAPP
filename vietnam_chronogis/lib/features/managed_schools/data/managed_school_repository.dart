import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../../core/firebase/firestore_paths.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/managed_school.dart';

final managedSchoolRepositoryProvider = Provider<ManagedSchoolRepository>((
  ref,
) {
  return ManagedSchoolRepository(firestore: ref.watch(firestoreProvider));
});

final managedSchoolsProvider = StreamProvider<List<ManagedSchool>>((ref) {
  return ref.watch(managedSchoolRepositoryProvider).watchSchools();
});

class ManagedSchoolRepository {
  const ManagedSchoolRepository({required FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  Stream<List<ManagedSchool>> watchSchools() {
    final firestore = _firestore;
    if (firestore == null) return Stream.value(const []);
    return firestore
        .collection(FirestorePaths.managedSchools)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(ManagedSchool.fromFirestore).toList(),
        );
  }

  Future<String> createSchool({
    required ManagedSchool school,
    required String userId,
  }) async {
    final validation = ManagedSchool.validate(
      name: school.name,
      latitude: school.latitude,
      longitude: school.longitude,
      checkInRadiusMeters: school.checkInRadiusMeters,
    );
    if (validation != null) throw ArgumentError(validation);

    final doc = await requireFirebase(_firestore)
        .collection(FirestorePaths.managedSchools)
        .add(school.toCreateMap(createdBy: userId));
    return doc.id;
  }
}

final managedSchoolActionProvider =
    AsyncNotifierProvider<ManagedSchoolActionNotifier, void>(
      ManagedSchoolActionNotifier.new,
    );

class ManagedSchoolActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createSchool({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw StateError('Sign in before creating schools.');
      await ref
          .read(managedSchoolRepositoryProvider)
          .createSchool(
            userId: user.uid,
            school: ManagedSchool(
              id: '',
              name: name,
              address: address,
              latitude: latitude,
              longitude: longitude,
              checkInRadiusMeters: radiusMeters,
              active: true,
              createdBy: user.uid,
              createdAt: null,
              updatedAt: null,
            ),
          );
    });
  }
}
