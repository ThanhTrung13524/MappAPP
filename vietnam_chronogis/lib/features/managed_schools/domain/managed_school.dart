import 'package:cloud_firestore/cloud_firestore.dart';

class ManagedSchool {
  const ManagedSchool({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.checkInRadiusMeters,
    required this.active,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double checkInRadiusMeters;
  final bool active;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ManagedSchool.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return ManagedSchool(
      id: snapshot.id,
      name: data['name'] as String? ?? '',
      address: data['address'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
      checkInRadiusMeters:
          (data['checkInRadiusMeters'] as num?)?.toDouble() ?? 100,
      active: data['active'] as bool? ?? true,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: _dateFromFirestore(data['createdAt']),
      updatedAt: _dateFromFirestore(data['updatedAt']),
    );
  }

  Map<String, Object?> toCreateMap({required String createdBy}) {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'checkInRadiusMeters': checkInRadiusMeters,
      'active': active,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, Object?> toUpdateMap() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'checkInRadiusMeters': checkInRadiusMeters,
      'active': active,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static String? validate({
    required String name,
    required double latitude,
    required double longitude,
    required double checkInRadiusMeters,
  }) {
    if (name.trim().isEmpty) return 'School name is required.';
    if (latitude < -90 || latitude > 90) return 'Latitude must be -90..90.';
    if (longitude < -180 || longitude > 180) {
      return 'Longitude must be -180..180.';
    }
    if (checkInRadiusMeters <= 0) return 'Radius must be greater than 0.';
    return null;
  }
}

DateTime? _dateFromFirestore(Object? value) {
  if (value is Timestamp) return value.toDate();
  return null;
}
