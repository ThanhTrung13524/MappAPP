import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FirebaseBootstrapStatus { ready, notConfigured, failed }

class FirebaseBootstrapResult {
  const FirebaseBootstrapResult({
    required this.status,
    this.error,
    this.stackTrace,
  });

  const FirebaseBootstrapResult.ready()
    : status = FirebaseBootstrapStatus.ready,
      error = null,
      stackTrace = null;

  const FirebaseBootstrapResult.notConfigured(Object error)
    : status = FirebaseBootstrapStatus.notConfigured,
      error = error,
      stackTrace = null;

  const FirebaseBootstrapResult.failed(Object error, StackTrace stackTrace)
    : status = FirebaseBootstrapStatus.failed,
      error = error,
      stackTrace = stackTrace;

  final FirebaseBootstrapStatus status;
  final Object? error;
  final StackTrace? stackTrace;

  bool get isReady => status == FirebaseBootstrapStatus.ready;

  String get message {
    return switch (status) {
      FirebaseBootstrapStatus.ready => 'Firebase is ready.',
      FirebaseBootstrapStatus.notConfigured =>
        'Firebase is not configured. Add platform Firebase config files before using online features.',
      FirebaseBootstrapStatus.failed => 'Firebase failed to initialize: $error',
    };
  }
}

final firebaseBootstrapResultProvider = Provider<FirebaseBootstrapResult>((
  ref,
) {
  return const FirebaseBootstrapResult.notConfigured(
    'Firebase bootstrap was not provided.',
  );
});

final firebaseConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(firebaseBootstrapResultProvider).isReady;
});

Future<FirebaseBootstrapResult> bootstrapFirebase() async {
  try {
    await Firebase.initializeApp();
    return const FirebaseBootstrapResult.ready();
  } on FirebaseException catch (error, stackTrace) {
    debugPrint('Firebase bootstrap skipped: ${error.code} ${error.message}');
    if (_looksLikeMissingConfiguration(error)) {
      return FirebaseBootstrapResult.notConfigured(error);
    }
    return FirebaseBootstrapResult.failed(error, stackTrace);
  } catch (error, stackTrace) {
    debugPrint('Firebase bootstrap failed: $error');
    return FirebaseBootstrapResult.failed(error, stackTrace);
  }
}

bool _looksLikeMissingConfiguration(FirebaseException error) {
  final text = '${error.code} ${error.message}'.toLowerCase();
  return text.contains('not initialized') ||
      text.contains('no app') ||
      text.contains('options') ||
      text.contains('configuration') ||
      text.contains('google-services') ||
      text.contains('google-service-info');
}
