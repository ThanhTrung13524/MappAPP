import 'package:cloud_firestore/cloud_firestore.dart';

enum GlobalRole { user, admin }

enum UserStatus { active, disabled }

class AppUserProfile {
  const AppUserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.globalRole,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final GlobalRole globalRole;
  final UserStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isAdmin => globalRole == GlobalRole.admin;

  factory AppUserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return AppUserProfile.fromMap(snapshot.id, data);
  }

  factory AppUserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return AppUserProfile(
      uid: data['uid'] as String? ?? uid,
      displayName: data['displayName'] as String?,
      email: data['email'] as String?,
      photoUrl: data['photoUrl'] as String?,
      globalRole: _enumFromName(
        GlobalRole.values,
        data['globalRole'] as String?,
        GlobalRole.user,
      ),
      status: _enumFromName(
        UserStatus.values,
        data['status'] as String?,
        UserStatus.active,
      ),
      createdAt: _dateFromFirestore(data['createdAt']),
      updatedAt: _dateFromFirestore(data['updatedAt']),
    );
  }

  Map<String, Object?> toCreateMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'globalRole': GlobalRole.user.name,
      'status': UserStatus.active.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

T _enumFromName<T extends Enum>(List<T> values, String? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

DateTime? _dateFromFirestore(Object? value) {
  if (value is Timestamp) return value.toDate();
  return null;
}
