import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_strings.dart';

class LocaleNotifier extends Notifier<AppLanguage> {
  static const _prefKey = 'selected_language_code';

  @override
  AppLanguage build() {
    _loadFromPrefs();
    return AppLanguage.english;
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      if (code != null) {
        final lang = AppLanguage.values.firstWhere(
          (l) => l.code == code,
          orElse: () => AppLanguage.english,
        );
        state = lang;
      }
    } catch (_) {}
  }

  Future<void> setLanguage(AppLanguage lang) async {
    state = lang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, lang.code);
    } catch (_) {}
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLanguage>(LocaleNotifier.new);

// Extension on WidgetRef for fast, idiomatic access in presentation
extension LocalizationRefX on WidgetRef {
  String tr(String key, {Map<String, String>? params}) {
    final lang = watch(localeProvider);
    return AppStrings.get(key, lang, params: params);
  }
}
