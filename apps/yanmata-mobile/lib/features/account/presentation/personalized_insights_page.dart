import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yanmata/core/localization/locale_provider.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/account/application/account_provider.dart';
import 'package:yanmata/features/shell.dart';
import 'package:yanmata/features/specialists/presentation/care_page.dart';

/// Screen 3 of Account Flow: Personalized Insights & Recommendations (Screen 5 from Wireframe)
class PersonalizedInsightsPage extends ConsumerStatefulWidget {
  const PersonalizedInsightsPage({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  ConsumerState<PersonalizedInsightsPage> createState() =>
      _PersonalizedInsightsPageState();
}

class _PersonalizedInsightsPageState
    extends ConsumerState<PersonalizedInsightsPage> {
  String _selectedCategory = 'all';

  Color _getPriorityColor(String priority, bool isDark) {
    switch (priority) {
      case 'soon':
        return const Color(0xFFE65100); // Amber / High attention
      case 'discuss':
        return isDark ? Palette.darkAccent : Palette.plum;
      case 'routine':
      default:
        return const Color(0xFF2E7D32); // Green
    }
  }

  String _getPriorityLabel(String priority, WidgetRef ref) {
    switch (priority) {
      case 'soon':
        return ref.tr('insights_priority_soon');
      case 'discuss':
        return ref.tr('insights_priority_discuss');
      case 'routine':
      default:
        return ref.tr('insights_priority_routine');
    }
  }

  Future<void> _finishFlow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
    } catch (_) {}

    if (!mounted) return;
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const YanMataShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    final text = isDark ? Palette.darkText : Palette.ink;
    final muted = isDark ? Palette.darkMuted : Palette.slate;
    final cardBg = isDark ? Palette.darkCard : Colors.white;

    final insightsAsync = ref.watch(personalizedInsightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.tr('insights_screen_title'),
          style: const TextStyle(
            fontFamily: 'Fraunces',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: insightsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  'Error loading insights: $err',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.refresh(personalizedInsightsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (insights) {
          final filtered = _selectedCategory == 'all'
              ? insights
              : insights.where((i) => i.category == _selectedCategory).toList();

          return PageFrame(
            children: [
              Text(
                ref.tr('insights_screen_sub'),
                style: TextStyle(fontSize: 14, color: muted, height: 1.5),
              ),
              const SizedBox(height: 16),

              // Clinical Disclaimer Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Palette.darkSurface
                      : Palette.blush.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Palette.darkBorder
                        : const Color(0xFFE2D6E4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_user_outlined, size: 18, color: accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ref.tr('insights_clinical_disclaimer'),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: text,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Category Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      [
                        ('all', 'All Insights'),
                        ('cervical', 'Cervical Health'),
                        ('cycle', 'Cycle Care'),
                        ('breast', 'Breast Awareness'),
                        ('lifestyle', 'Lifestyle'),
                        ('family', 'Family History'),
                      ].map((cat) {
                        final isSelected = _selectedCategory == cat.$1;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat.$2),
                            selected: isSelected,
                            onSelected: (_) =>
                                setState(() => _selectedCategory = cat.$1),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Insights List
              if (filtered.isEmpty) ...[
                SoftCard(
                  color: cardBg,
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 44, color: accent),
                      const SizedBox(height: 12),
                      Text(
                        'All caught up for this category',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your health profile indicates healthy routine indicators.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: muted),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ...filtered.map((item) {
                  final priorityColor = _getPriorityColor(
                    item.priority,
                    isDark,
                  );
                  final priorityLabel = _getPriorityLabel(item.priority, ref);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Material(
                      color: cardBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: isDark
                              ? Palette.darkBorder
                              : const Color(0xFFE9E2E9),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    priorityLabel,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: priorityColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Palette.darkSurface
                                        : Palette.blush,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.category.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.body,
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.55,
                                color: isDark ? Palette.darkMuted : Palette.ink,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Traceable Source Citation
                            Row(
                              children: [
                                Icon(
                                  Icons.menu_book_outlined,
                                  size: 14,
                                  color: muted,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.source,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: muted,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Action CTA
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => const Care(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 15,
                                  ),
                                  label: Text(
                                    ref.tr('insights_action_specialist'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 20),

              // Final Step 4 CTA: Take Action -> Dashboard
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _finishFlow,
                  child: Text(ref.tr('insights_action_home')),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
