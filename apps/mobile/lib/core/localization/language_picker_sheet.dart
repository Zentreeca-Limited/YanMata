import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../ui_feedback.dart';
import 'app_strings.dart';
import 'locale_provider.dart';

class LanguagePickerSheet extends ConsumerWidget {
  const LanguagePickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LanguagePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Palette.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Palette.darkBorder : const Color(0xFFE2D6E4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Language',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Palette.darkText : Palette.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Zabi Harshe · Yan Èdè · Họrọ Asụsụ · Pick Language',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? Palette.darkMuted : Palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...AppLanguage.values.map((lang) {
              final isSelected = lang == active;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Palette.plum
                        : (isDark ? Palette.darkSurface : Palette.lilac.withValues(alpha: 0.3)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      lang.code.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : Palette.plum,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  lang.nativeName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isDark ? Palette.darkText : Palette.ink,
                  ),
                ),
                subtitle: Text(
                  lang.englishName,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Palette.darkMuted : Palette.muted,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: Palette.plum)
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLanguage(lang);
                  Navigator.of(context).pop();
                  final switchMsg = switch (lang) {
                    AppLanguage.hausa => 'An canza harshe zuwa Harshen Hausa',
                    AppLanguage.yoruba => 'A ti yí èdè padà sí Èdè Yorùbá',
                    AppLanguage.igbo => 'Agbanweela asụsụ gaa n’Asụsụ Igbo',
                    AppLanguage.pidgin => 'Language don change to Pidgin',
                    AppLanguage.english => 'Language changed to English',
                  };
                  YanMataFeedback.showSuccessSnackbar(context, switchMsg);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
