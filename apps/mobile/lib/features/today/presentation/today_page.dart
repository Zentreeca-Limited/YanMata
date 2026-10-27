import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/localization/language_picker_sheet.dart';
import 'package:yanmata/core/localization/locale_provider.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/theme_provider.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/ai/presentation/ai_companion_page.dart';
import 'package:yanmata/features/journal/application/cycle_settings_provider.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/mental_health/presentation/mental_health_page.dart';
import 'package:yanmata/features/risk/presentation/early_detection_page.dart';
import 'package:yanmata/features/risk/presentation/risk_overview_page.dart';
import 'package:yanmata/features/services/application/location_provider.dart';
import 'package:yanmata/features/services/presentation/location_picker_sheet.dart';

class Today extends ConsumerWidget {
  const Today({
    super.key,
    required this.onTrack,
    required this.onServices,
    required this.onProducts,
    required this.onProfile,
    required this.onLearn,
  });

  final VoidCallback onTrack;
  final VoidCallback onServices;
  final VoidCallback onProducts;
  final VoidCallback onProfile;
  final VoidCallback onLearn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider).value;
    final cycle = ref.watch(cycleSettingsProvider);
    final location = ref.watch(selectedLocationProvider);
    final lang = ref.watch(localeProvider);
    ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageFrame(
      children: [
        // Brand & Status Bar with Language, Location and Theme Controls
        // Brand & Status Bar with Language, Location and Theme Controls (Adaptive wrap)
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.spa_outlined, color: Palette.plum, size: 28),
                const SizedBox(width: 8),
                Text(
                  ref.tr('app_name'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Palette.darkText : Palette.plum,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Location Badge
                InkWell(
                  onTap: () => LocationPickerSheet.show(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Palette.darkSurface : Palette.lilac,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Palette.plum),
                        const SizedBox(width: 4),
                        Text(
                          location.city == 'All Locations' ? 'All' : location.city,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Palette.darkText : Palette.plum,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Language Badge
                InkWell(
                  onTap: () => LanguagePickerSheet.show(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Palette.darkSurface : Palette.blush,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.translate, size: 13, color: Palette.plum),
                        const SizedBox(width: 4),
                        Text(
                          lang.code.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Palette.darkText : Palette.plum,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Theme Toggle
                IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                    color: isDark ? Palette.darkAccent : Palette.plum,
                  ),
                  onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(isDark),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Personalized Greeting Header (Wireframe Screen 2)
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ref.tr('greeting_prefix')} Aisha ☀️',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Palette.darkText : Palette.plum,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    ref.tr('greeting_subtitle'),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Palette.darkMuted : Palette.slate,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onProfile,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? Palette.darkSurface : Palette.lilac,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Palette.darkBorder : Palette.plum,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: isDark ? Palette.darkText : Palette.plum,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Eyebrow(ref.tr('care_quote_eyebrow')),
        const SizedBox(height: 8),
        Text(
          ref.tr('care_quote_title'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(ref.tr('care_quote_body')),
        const SizedBox(height: 20),

        // Next Cycle Summary Card (Wireframe Screen 2 & 7)
        SoftCard(
          color: isDark ? Palette.darkCard : Colors.white,
          child: InkWell(
            onTap: onTrack,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: Color(0xFFE11D48),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${ref.tr('cycle_card_prefix')} ${ref.tr('day_of_cycle', params: {'day': '${cycle.currentDayOfCycle}', 'total': '${cycle.cycleLength}'})}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Palette.darkText : Palette.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${cycle.currentPhase} · ${ref.tr('cycle_card_action')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Palette.darkAccent : Palette.plum,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // AI Health Companion Shortcut Card
        _FeatureCard(
          icon: Icons.auto_awesome,
          title: ref.tr('shortcut_ai'),
          subtitle: ref.tr('shortcut_ai_sub'),
          accentColor: Palette.plum,
          badgeText: 'AI 24/7',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const AiCompanionPage(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Health Risk Prediction Shortcut Card
        _FeatureCard(
          icon: Icons.shield_outlined,
          title: ref.tr('shortcut_risk'),
          subtitle: ref.tr('shortcut_risk_sub'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const RiskOverviewPage(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Mental Health Support Shortcut Card
        _FeatureCard(
          icon: Icons.psychology_outlined,
          title: ref.tr('shortcut_mental'),
          subtitle: ref.tr('shortcut_mental_sub'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const MentalHealthPage(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Find Health Services Shortcut Card
        _FeatureCard(
          icon: Icons.local_hospital_outlined,
          title: ref.tr('shortcut_services'),
          subtitle: ref.tr('shortcut_services_sub'),
          onTap: onServices,
        ),
        const SizedBox(height: 12),

        // Shop Health Products Shortcut Card
        _FeatureCard(
          icon: Icons.shopping_bag_outlined,
          title: ref.tr('shortcut_products'),
          subtitle: ref.tr('shortcut_products_sub'),
          onTap: onProducts,
        ),
        const SizedBox(height: 12),

        // Early Detection & Screening Shortcut Card
        _FeatureCard(
          icon: Icons.biotech_outlined,
          title: ref.tr('shortcut_early'),
          subtitle: ref.tr('shortcut_early_sub'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const EarlyDetectionPage(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Daily Check-in CTA
        SoftCard(
          color: isDark ? Palette.darkCard : Palette.blush,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, color: Palette.plum),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ref.tr('mood_label'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Palette.darkText : Palette.plum,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                journal != null && journal.entries.isNotEmpty
                    ? 'Latest log: ${journal.entries.first.mood} · Stored securely on device.'
                    : 'A private moment to reflect on your energy, mood and cycle symptoms.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Palette.darkMuted : Palette.ink,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: onTrack,
                child: Text(ref.tr('save_checkin')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accentColor,
    this.badgeText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? accentColor;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = accentColor ?? Palette.plum;

    return Material(
      color: isDark ? Palette.darkCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Palette.darkBorder : const Color(0xFFF0E6F2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? Palette.darkSurface : Palette.lilac,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: baseColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Palette.darkText : Palette.ink,
                          ),
                        ),
                        if (badgeText != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Palette.blush,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText!,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Palette.plum,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Palette.darkMuted : Palette.muted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Palette.darkMuted : Palette.slate,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
