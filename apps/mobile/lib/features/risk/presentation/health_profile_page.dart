import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/risk/application/risk_provider.dart';

class HealthProfilePage extends ConsumerWidget {
  const HealthProfilePage({super.key});

  IconData _iconForSection(String section) {
    if (section.contains('Age')) return Icons.person_outline;
    if (section.contains('Menstrual')) return Icons.water_drop_outlined;
    if (section.contains('Reproductive')) return Icons.pregnant_woman_outlined;
    if (section.contains('Medical')) return Icons.medical_information_outlined;
    if (section.contains('Lifestyle')) return Icons.directions_run_outlined;
    return Icons.family_restroom_outlined;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riskAsync = ref.watch(riskAssessmentProvider);

    return Scaffold(
      backgroundColor: Palette.cream,
      appBar: AppBar(
        title: const Text('Your Health Profile'),
        backgroundColor: Palette.cream,
        elevation: 0,
      ),
      body: riskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) => PageFrame(
          children: [
            const Text(
              'Update your information to get a more accurate risk prediction.',
              style: TextStyle(fontSize: 14, color: Palette.slate),
            ),
            const SizedBox(height: 20),

            ...data.completedSections.entries.map((entry) {
              final isCompleted = entry.value.toLowerCase() == 'completed';
              final isInProgress = entry.value.toLowerCase().contains('progress');

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE9E2E9)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      final newStatus = isCompleted ? 'In progress' : 'Completed';
                      ref
                          .read(riskAssessmentProvider.notifier)
                          .updateSection(entry.key, newStatus);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Palette.lilac,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _iconForSection(entry.key),
                              color: Palette.plum,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCompleted
                                        ? const Color(0xFF2E7D32)
                                        : (isInProgress
                                            ? Colors.amber.shade800
                                            : Palette.slate),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isCompleted
                                ? Icons.check_circle
                                : (isInProgress
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked),
                            color: isCompleted
                                ? const Color(0xFF2E7D32)
                                : (isInProgress
                                    ? Colors.amber.shade800
                                    : Palette.slate),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Health profile updated. Risk prediction refreshed.'),
                    backgroundColor: Palette.plum,
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
