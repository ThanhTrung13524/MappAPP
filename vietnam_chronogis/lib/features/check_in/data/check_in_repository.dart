import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/check_in_models.dart';

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(functions: ref.watch(cloudFunctionsProvider));
});

class CheckInRepository {
  const CheckInRepository({required FirebaseFunctions? functions})
    : _functions = functions;

  final FirebaseFunctions? _functions;

  Future<CheckInResult> checkIn({
    required String campaignId,
    required String eventId,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw StateError('Location service is disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Location permission is required for check-in.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );

    final request = CheckInRequest(
      campaignId: campaignId,
      eventId: eventId,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );

    final callable = requireFirebase(
      _functions,
    ).httpsCallable('validateEventCheckIn');
    final response = await callable.call(request.toCallableData());
    return CheckInResult.fromCallable(response.data);
  }
}

final checkInActionProvider =
    AsyncNotifierProvider<CheckInActionNotifier, CheckInResult?>(
      CheckInActionNotifier.new,
    );

class CheckInActionNotifier extends AsyncNotifier<CheckInResult?> {
  @override
  Future<CheckInResult?> build() async => null;

  Future<void> checkIn({
    required String campaignId,
    required String eventId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw StateError('Sign in before check-in.');
      return ref
          .read(checkInRepositoryProvider)
          .checkIn(campaignId: campaignId, eventId: eventId);
    });
  }
}
