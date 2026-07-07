import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_chronogis/features/auth/data/auth_repository.dart';
import 'package:vietnam_chronogis/features/auth/domain/app_auth_user.dart';
import 'package:vietnam_chronogis/features/auth/domain/app_user_profile.dart';
import 'package:vietnam_chronogis/features/auth/presentation/auth_gate_screen.dart';

void main() {
  group('auth state provider', () {
    test('emits unauthenticated state', () async {
      final container = _containerWith(_FakeAuthRepository());
      addTearDown(container.dispose);
      final subscription = container.listen(authStateProvider, (_, _) {});
      addTearDown(subscription.close);

      await container.pump();

      expect(container.read(authStateProvider).value, isNull);
    });

    test('emits authenticated state', () async {
      const user = AppAuthUser(uid: 'uid-1', email: 'user@example.com');
      final container = _containerWith(_FakeAuthRepository(user: user));
      addTearDown(container.dispose);
      final subscription = container.listen(authStateProvider, (_, _) {});
      addTearDown(subscription.close);

      await container.pump();

      expect(container.read(authStateProvider).value, user);
    });
  });

  group('auth action notifier', () {
    test('reports loading while login is pending', () async {
      final completer = Completer<AppAuthUser>();
      final container = _containerWith(
        _FakeAuthRepository(signInCompleter: completer),
      );
      addTearDown(container.dispose);

      final login = container
          .read(authActionProvider.notifier)
          .signInWithGoogle();

      expect(container.read(authActionProvider).isLoading, isTrue);

      completer.complete(const AppAuthUser(uid: 'uid-1'));
      await login;

      expect(container.read(authActionProvider).isLoading, isFalse);
      expect(container.read(authActionProvider).error, isNull);
    });

    test('captures login errors', () async {
      final container = _containerWith(
        _FakeAuthRepository(signInError: StateError('login failed')),
      );
      addTearDown(container.dispose);

      await container.read(authActionProvider.notifier).signInWithGoogle();

      expect(container.read(authActionProvider).isLoading, isFalse);
      expect(
        container.read(authActionProvider).error,
        contains('login failed'),
      );
    });

    test('calls repository logout', () async {
      final repository = _FakeAuthRepository();
      final container = _containerWith(repository);
      addTearDown(container.dispose);

      await container.read(authActionProvider.notifier).signOut();

      expect(repository.signOutCalled, isTrue);
      expect(container.read(authActionProvider).error, isNull);
    });
  });

  group('route protection', () {
    test('sends unconfigured Firebase users to login', () {
      expect(
        resolveAuthGateDestination(
          isConfigured: false,
          isLoading: false,
          user: null,
        ),
        AuthGateDestination.login,
      );
    });

    test('stays on gate while auth is loading', () {
      expect(
        resolveAuthGateDestination(
          isConfigured: true,
          isLoading: true,
          user: null,
        ),
        AuthGateDestination.stay,
      );
    });

    test('routes signed-in users to the map', () {
      expect(
        resolveAuthGateDestination(
          isConfigured: true,
          isLoading: false,
          user: const AppAuthUser(uid: 'uid-1'),
        ),
        AuthGateDestination.map,
      );
    });
  });

  group('user profile mapping', () {
    test('parses profile fields from map', () {
      final profile = AppUserProfile.fromMap('fallback-uid', {
        'uid': 'uid-1',
        'displayName': 'Chrono User',
        'email': 'user@example.com',
        'photoUrl': 'https://example.com/avatar.png',
        'globalRole': 'admin',
        'status': 'disabled',
      });

      expect(profile.uid, 'uid-1');
      expect(profile.displayName, 'Chrono User');
      expect(profile.globalRole, GlobalRole.admin);
      expect(profile.status, UserStatus.disabled);
    });

    test('create map always defaults to non-admin active user', () {
      final createMap = const AppUserProfile(
        uid: 'uid-1',
        displayName: 'Chrono User',
        email: 'user@example.com',
        photoUrl: null,
        globalRole: GlobalRole.admin,
        status: UserStatus.disabled,
        createdAt: null,
        updatedAt: null,
      ).toCreateMap();

      expect(createMap['globalRole'], GlobalRole.user.name);
      expect(createMap['status'], UserStatus.active.name);
    });
  });

  group('missing Firebase configuration', () {
    test('auth stream falls back to signed-out instead of crashing', () async {
      final repository = FirebaseAuthRepository(auth: null, firestore: null);

      expect(await repository.authStateChanges().first, isNull);
    });

    test('login reports a clear not-configured error', () async {
      final repository = FirebaseAuthRepository(auth: null, firestore: null);

      expect(
        repository.signInWithGoogle,
        throwsA(isA<FirebaseNotConfiguredException>()),
      );
    });
  });
}

ProviderContainer _containerWith(AuthRepository repository) {
  return ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.user, this.signInCompleter, this.signInError});

  final AppAuthUser? user;
  final Completer<AppAuthUser>? signInCompleter;
  final Object? signInError;
  bool signOutCalled = false;

  @override
  Stream<AppAuthUser?> authStateChanges() => Stream.value(user);

  @override
  Future<void> ensureUserProfile(AppAuthUser? user) async {}

  @override
  Future<AppAuthUser> signInWithGoogle() async {
    final error = signInError;
    if (error != null) throw error;
    final completer = signInCompleter;
    if (completer != null) return completer.future;
    return user ?? const AppAuthUser(uid: 'signed-in-user');
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Stream<AppUserProfile?> watchUserProfile(String uid) => Stream.value(null);
}
