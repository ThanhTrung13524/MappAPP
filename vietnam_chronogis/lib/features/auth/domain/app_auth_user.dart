import 'package:firebase_auth/firebase_auth.dart';

class AppAuthUser {
  const AppAuthUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  factory AppAuthUser.fromFirebase(User user) {
    return AppAuthUser(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }
}
