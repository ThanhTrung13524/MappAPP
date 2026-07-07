import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_bootstrap.dart';

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  if (!ref.watch(firebaseConfiguredProvider)) return null;
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  if (!ref.watch(firebaseConfiguredProvider)) return null;
  return FirebaseFirestore.instance;
});

final cloudFunctionsProvider = Provider<FirebaseFunctions?>((ref) {
  if (!ref.watch(firebaseConfiguredProvider)) return null;
  return FirebaseFunctions.instance;
});

class FirebaseNotConfiguredException implements Exception {
  const FirebaseNotConfiguredException();

  @override
  String toString() {
    return 'Firebase is not configured. Add google-services.json / GoogleService-Info.plist and generated Firebase options before using this feature.';
  }
}

T requireFirebase<T>(T? value) {
  if (value == null) throw const FirebaseNotConfiguredException();
  return value;
}
