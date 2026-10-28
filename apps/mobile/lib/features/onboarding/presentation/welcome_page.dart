import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/localization/language_picker_sheet.dart';
import 'package:yanmata/core/localization/locale_provider.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/features/account/presentation/auth_page.dart';

/// Screen 1 of Account Flow: Welcome / Getting Started (Shows for the first time)
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
                      const SizedBox(height: 36),
                      Container(
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: isDark ? Palette.darkCard : Palette.blush,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/logo.png'),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'YanMata',
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 12),
                      Text(
                        ref.tr('ob_body'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.55,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Button 1: Get Started -> Sign Up
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => AuthPage(
                                  isSignUp: true,
                                  onComplete: onGetStarted,
                                ),
                              ),
                            );
                          },
                          child: Text(ref.tr('ob_start')),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Button 2: I already have an account -> Sign In
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => AuthPage(
                                  isSignUp: false,
                                  onComplete: onGetStarted,
                                ),
                              ),
                            );
                          },
                          child: Text(ref.tr('auth_has_account')),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        ref.tr('ob_footer'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11.5, color: muted),
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
