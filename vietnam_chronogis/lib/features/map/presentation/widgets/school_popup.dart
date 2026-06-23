import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/school_provider.dart';

class SchoolPopup extends ConsumerWidget {
  const SchoolPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final school = ref.watch(selectedSchoolProvider);
    if (school == null) return const SizedBox.shrink();

    final statsAsync = ref.watch(schoolEducationStatsProvider(school.nemotronRegion));

    return Container(
      width: 320,
      constraints: const BoxConstraints(maxHeight: 420),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23).withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.4)),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: Color(0xFF64B5F6)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    school.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      ref.read(selectedSchoolProvider.notifier).clear(),
                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _InfoChip(label: schoolTypeLabel(school.schoolType)),
            if (school.provinceName != null) ...[
              const SizedBox(height: 8),
              Text(
                school.provinceName!,
                style: const TextStyle(color: Color(0xFF9AA0B0)),
              ),
            ],
            if (school.address != null) ...[
              const SizedBox(height: 8),
              Text(school.address!, style: const TextStyle(color: Colors.white70)),
            ],
            if (school.phone != null) ...[
              const SizedBox(height: 6),
              Text('📞 ${school.phone}', style: const TextStyle(color: Colors.white70)),
            ],
            if (school.operator != null) ...[
              const SizedBox(height: 6),
              Text(
                'Chủ quản: ${school.operator}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
            const Divider(color: Colors.white24, height: 24),
            const Text(
              'Thống kê giáo dục (Nemotron-Personas-VN)',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Dữ liệu tổng hợp từ HuggingFace nvidia/Nemotron-Personas-Vietnam',
              style: TextStyle(color: Color(0xFF9AA0B0), fontSize: 11),
            ),
            const SizedBox(height: 8),
            statsAsync.when(
              data: (stats) {
                if (stats == null || stats.sampleSize == 0) {
                  return const Text(
                    'Chưa có thống kê Nemotron cho khu vực này (dataset gồm 6 tỉnh/thành lớn).',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  );
                }
                final thpt = stats.percentFor('THPT');
                final uni = stats.percentFor('Đại học');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khu vực: ${stats.region} (${stats.sampleSize} mẫu)',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    _StatBar(label: 'THPT', percent: thpt, color: Color(0xFF42A5F5)),
                    _StatBar(label: 'Đại học', percent: uni, color: Color(0xFF66BB6A)),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              ),
              error: (_, _) => const Text(
                'Không tải được thống kê Nemotron.',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF90CAF9), fontSize: 12)),
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${percent.toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (percent / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
