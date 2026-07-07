import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_gate_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/shell/presentation/seeding_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/seed',
  routes: [
    GoRoute(path: '/seed', builder: (context, state) => const SeedingScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthGateScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/map', builder: (context, state) => const AppShell()),
    // FIX: thêm route /explorer để tránh lỗi context.go('/explorer')
    // trong province_info_popup.dart
    GoRoute(path: '/explorer', builder: (context, state) => const AppShell()),
  ],
);
