import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../domain/app_auth_user.dart';
import '../data/auth_repository.dart';

enum AuthGateDestination { stay, login, map }

AuthGateDestination resolveAuthGateDestination({
  required bool isConfigured,
  required bool isLoading,
  required AppAuthUser? user,
}) {
  if (!isConfigured) return AuthGateDestination.login;
  if (isLoading) return AuthGateDestination.stay;
  return user == null ? AuthGateDestination.login : AuthGateDestination.map;
}

class AuthGateScreen extends ConsumerWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConfigured = ref.watch(firebaseConfiguredProvider);
    final bootstrap = ref.watch(firebaseBootstrapResultProvider);
    final authState = ref.watch(authStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final destination = resolveAuthGateDestination(
        isConfigured: isConfigured,
        isLoading: authState.isLoading,
        user: authState.value,
      );
      switch (destination) {
        case AuthGateDestination.login:
          context.go('/login');
        case AuthGateDestination.map:
          context.go('/map');
        case AuthGateDestination.stay:
          break;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF12151C),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF4A90E2)),
              const SizedBox(height: 16),
              Text(
                bootstrap.status == FirebaseBootstrapStatus.ready
                    ? 'Checking authentication...'
                    : bootstrap.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
