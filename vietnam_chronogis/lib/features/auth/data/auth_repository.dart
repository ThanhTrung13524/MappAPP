import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../firebase_options.dart';
import '../domain/app_auth_user.dart';
import '../domain/app_user_profile.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final isConfigured = ref.watch(firebaseConfiguredProvider);
  return FirebaseAuthRepository(
    auth: isConfigured ? FirebaseAuth.instance : null,
    firestore: isConfigured ? FirebaseFirestore.instance : null,
  );
});

final authStateProvider = StreamProvider<AppAuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final currentUserProfileProvider = StreamProvider<AppUserProfile?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(authRepositoryProvider).watchUserProfile(user.uid);
});

abstract class AuthRepository {
  Stream<AppAuthUser?> authStateChanges();
  Stream<AppUserProfile?> watchUserProfile(String uid);
  Future<AppAuthUser> signInWithGoogle();
  Future<void> signOut();
  Future<void> ensureUserProfile(AppAuthUser? user);
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth? auth,
    required FirebaseFirestore? firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;
  Future<void>? _googleInit;

  @override
  Stream<AppAuthUser?> authStateChanges() {
    final auth = _auth;
    if (auth == null) return Stream.value(null);
    return auth.authStateChanges().map((user) {
      return user == null ? null : AppAuthUser.fromFirebase(user);
    });
  }

  @override
  Stream<AppUserProfile?> watchUserProfile(String uid) {
    final firestore = _firestore;
    if (firestore == null) return Stream.value(null);
    return firestore.doc(_userPath(uid)).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return AppUserProfile.fromFirestore(snapshot);
    });
  }

  @override
  Future<AppAuthUser> signInWithGoogle() async {
    final auth = _requireFirebase(_auth);
    await _ensureGoogleInitialized();
    final googleSignIn = GoogleSignIn.instance;
    if (!googleSignIn.supportsAuthenticate()) {
      throw UnsupportedError(
        'Google Sign-In interactive flow is not supported on this platform.',
      );
    }

    final account = await googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Google Sign-In did not return an ID token.');
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw StateError('Firebase Auth did not return a signed-in user.');
    }
    final appUser = AppAuthUser.fromFirebase(user);
    await ensureUserProfile(appUser);
    return appUser;
  }

  @override
  Future<void> signOut() async {
    await _auth?.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Ignore Google SDK sign-out errors when Firebase is already signed out.
    }
  }

  @override
  Future<void> ensureUserProfile(AppAuthUser? user) async {
    if (user == null) return;
    final firestore = _requireFirebase(_firestore);
    final ref = firestore.doc(_userPath(user.uid));
    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.update({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    await ref.set(
      AppUserProfile(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoUrl,
        globalRole: GlobalRole.user,
        status: UserStatus.active,
        createdAt: null,
        updatedAt: null,
      ).toCreateMap(),
    );
  }

  Future<void> _ensureGoogleInitialized() {
    return _googleInit ??= GoogleSignIn.instance.initialize(
      serverClientId: DefaultFirebaseOptions.googleWebClientId,
    );
  }
}

String _userPath(String uid) => 'users/$uid';

class FirebaseNotConfiguredException implements Exception {
  const FirebaseNotConfiguredException();

  @override
  String toString() {
    return 'Firebase is not configured. Add google-services.json / GoogleService-Info.plist and generated Firebase options before using this feature.';
  }
}

T _requireFirebase<T>(T? value) {
  if (value == null) throw const FirebaseNotConfiguredException();
  return value;
}

class AuthActionState {
  const AuthActionState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;
}

final authActionProvider =
    NotifierProvider<AuthActionNotifier, AuthActionState>(
      AuthActionNotifier.new,
    );

class AuthActionNotifier extends Notifier<AuthActionState> {
  @override
  AuthActionState build() => const AuthActionState();

  Future<void> signInWithGoogle() async {
    state = const AuthActionState(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      state = const AuthActionState();
    } catch (error) {
      state = AuthActionState(error: mapAuthError(error));
    }
  }

  Future<void> signOut() async {
    state = const AuthActionState(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AuthActionState();
    } catch (error) {
      state = AuthActionState(error: mapAuthError(error));
    }
  }
}

String mapAuthError(Object error) {
  final text = error.toString();
  if (text.contains('ApiException: 10') || text.contains('DEVELOPER_ERROR')) {
    return 'Cấu hình Google Sign-In sai (ApiException 10). '
        'Kiểm tra SHA-1 trên Firebase Console khớp máy đang build, '
        'và tải lại google-services.json.';
  }
  if (text.contains('ApiException: 7') || text.contains('NETWORK')) {
    return 'Lỗi mạng. Kiểm tra kết nối Internet rồi thử lại.';
  }
  if (text.contains('Firebase is not configured') ||
      text.contains('FirebaseNotConfiguredException')) {
    return 'Firebase chưa cấu hình. Thêm google-services.json và firebase_options.dart.';
  }
  if (text.contains('ID token')) {
    return 'Google không trả về ID token. Kiểm tra Web Client ID (GOOGLE_WEB_CLIENT_ID).';
  }
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'operation-not-allowed' =>
        'Google Sign-In chưa được bật trong Firebase Console.',
      'invalid-credential' =>
        'Thông tin đăng nhập không hợp lệ. Kiểm tra cấu hình Firebase.',
      'user-disabled' => 'Tài khoản đã bị vô hiệu hóa.',
      'network-request-failed' => 'Lỗi mạng. Vui lòng thử lại.',
      _ => error.message ?? 'Đăng nhập thất bại (${error.code}).',
    };
  }
  return text;
}
