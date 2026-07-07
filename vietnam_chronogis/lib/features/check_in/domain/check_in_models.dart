class CheckInRequest {
  const CheckInRequest({
    required this.campaignId,
    required this.eventId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  final String campaignId;
  final String eventId;
  final double latitude;
  final double longitude;
  final double accuracy;

  Map<String, Object?> toCallableData() {
    return {
      'campaignId': campaignId,
      'eventId': eventId,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
    };
  }
}

class CheckInResult {
  const CheckInResult({
    required this.success,
    required this.distanceMeters,
    required this.message,
  });

  final bool success;
  final double? distanceMeters;
  final String message;

  factory CheckInResult.fromCallable(Object? data) {
    final map = data is Map ? data : const <Object?, Object?>{};
    return CheckInResult(
      success: map['success'] == true,
      distanceMeters: (map['distanceMeters'] as num?)?.toDouble(),
      message: map['message'] as String? ?? 'Check-in completed.',
    );
  }
}
