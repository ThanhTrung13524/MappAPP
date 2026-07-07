import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_bootstrap.dart';

const firebaseFunctionsRegion = String.fromEnvironment(
  'FIREBASE_FUNCTIONS_REGION',
  defaultValue: 'asia-southeast1',
);
const _useFirebaseEmulator = bool.fromEnvironment('USE_FIREBASE_EMULATOR');
const _firebaseEmulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: 'localhost',
);
const _firebaseAuthEmulatorPort = int.fromEnvironment(
  'FIREBASE_AUTH_EMULATOR_PORT',
  defaultValue: 9099,
);
const _firestoreEmulatorPort = int.fromEnvironment(
  'FIRESTORE_EMULATOR_PORT',
  defaultValue: 18080,
);
const _functionsEmulatorPort = int.fromEnvironment(
  'FIREBASE_FUNCTIONS_EMULATOR_PORT',
  defaultValue: 5001,
);

bool _authEmulatorConfigured = false;
bool _firestoreEmulatorConfigured = false;
bool _functionsEmulatorConfigured = false;

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  if (!ref.watch(firebaseConfiguredProvider)) return null;
  final auth = FirebaseAuth.instance;
  if (_useFirebaseEmulator && !_authEmulatorConfigured) {
    auth.useAuthEmulator(_firebaseEmulatorHost, _firebaseAuthEmulatorPort);
    _authEmulatorConfigured = true;
  }
  return auth;
});

final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  if (!ref.watch(firebaseConfiguredProvider)) return null;
  final firestore = FirebaseFirestore.instance;
  if (_useFirebaseEmulator && !_firestoreEmulatorConfigured) {
    firestore.useFirestoreEmulator(
      _firebaseEmulatorHost,
      _firestoreEmulatorPort,
    );
    _firestoreEmulatorConfigured = true;
  }
  return firestore;
});

final cloudFunctionsProvider = Provider<FirebaseFunctions?>((ref) {
  if (!ref.watch(firebaseConfiguredProvider)) return null;
  final functions = FirebaseFunctions.instanceFor(
    region: firebaseFunctionsRegion,
  );
  if (_useFirebaseEmulator && !_functionsEmulatorConfigured) {
    functions.useFunctionsEmulator(
      _firebaseEmulatorHost,
      _functionsEmulatorPort,
    );
    _functionsEmulatorConfigured = true;
  }
  return functions;
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
