import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/localization/language_picker_sheet.dart';
import 'package:yanmata/core/localization/locale_provider.dart';
import 'package:yanmata/core/theme.dart';

/// First-run onboarding screen from the designer handoff.
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key, required this.onGetStarted});
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    final text = isDark ? Palette.darkText : Palette.ink;
    final muted = isDark ? Palette.darkMuted : Palette.slate;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight - 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ActionChip(
                          avatar: Icon(
                            Icons.translate,
                            size: 16,
                            color: accent,
                          ),
                          label: Text(
                            ref.watch(localeProvider).code.toUpperCase(),
                          ),
                          onPressed: () => LanguagePickerSheet.show(context),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 128,
                        height: 128,
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: isDark ? Palette.darkCard : Palette.blush,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/logo.png'),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'YanMata',
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ref.tr('ob_tagline'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: text,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        ref.tr('ob_body'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.55,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onGetStarted,
                          child: Text(ref.tr('ob_start')),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        ref.tr('ob_footer'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
