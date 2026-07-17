import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConfigured = ref.watch(firebaseConfiguredProvider);
    final bootstrap = ref.watch(firebaseBootstrapResultProvider);
    final authState = ref.watch(authStateProvider);
    final action = ref.watch(authActionProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next.value != null && context.mounted) {
        context.go('/map');
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF12151C),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 72,
                  color: Color(0xFF2D5A8E),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Vietnam ChronoGIS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đăng nhập để đồng bộ dữ liệu và lưu cài đặt của bạn',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9AA0B0),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                if (!isConfigured)
                  _StatusPanel(
                    icon: Icons.warning_amber_outlined,
                    color: const Color(0xFFFFB74D),
                    text:
                        '${bootstrap.message}\nThêm google-services.json + firebase_options.dart, rồi khởi động lại app.',
                  ),
                if (bootstrap.status == FirebaseBootstrapStatus.failed)
                  _StatusPanel(
                    icon: Icons.error_outline,
                    color: const Color(0xFFE24B4A),
                    text: bootstrap.message,
                  ),
                if (action.error != null)
                  _StatusPanel(
                    icon: Icons.error_outline,
                    color: const Color(0xFFE24B4A),
                    text: action.error!,
                  ),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: isConfigured && !action.isLoading
                        ? () => ref
                            .read(authActionProvider.notifier)
                            .signInWithGoogle()
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1A1D23),
                      disabledBackgroundColor: Colors.white24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: action.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.g_mobiledata, size: 28),
                    label: Text(
                      action.isLoading
                          ? 'Đang đăng nhập...'
                          : 'Đăng nhập với Google',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => context.go('/map'),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Tiếp tục vào bản đồ (không đăng nhập)'),
                ),
                if (authState.value != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: action.isLoading
                        ? null
                        : () =>
                            ref.read(authActionProvider.notifier).signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Bằng việc đăng nhập, bạn đồng ý với điều khoản sử dụng của ứng dụng.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
