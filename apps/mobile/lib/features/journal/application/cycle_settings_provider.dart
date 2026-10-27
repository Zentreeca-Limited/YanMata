import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CycleSettings {
  final DateTime lastPeriodDate;
  final int cycleLength;
  final int periodDuration;

  const CycleSettings({
    required this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodDuration = 5,
  });

  int get currentDayOfCycle {
    final now = DateTime.now();
    final cleanNow = DateTime(now.year, now.month, now.day);
    final cleanStart = DateTime(
      lastPeriodDate.year,
      lastPeriodDate.month,
      lastPeriodDate.day,
    );
    final diffDays = cleanNow.difference(cleanStart).inDays;
    if (diffDays < 0) return 1;
    return (diffDays % cycleLength) + 1;
  }

  String get currentPhase {
    final day = currentDayOfCycle;
    if (day <= periodDuration) {
      return 'Menstrual Phase';
    } else if (day <= (cycleLength / 2) - 2) {
      return 'Follicular Phase';
    } else if (day <= (cycleLength / 2) + 2) {
      return 'Ovulation Window';
    } else {
      return 'Luteal Phase';
    }
  }

  int get nextPeriodInDays {
    final day = currentDayOfCycle;
    final remaining = cycleLength - day;
    return remaining <= 0 ? cycleLength : remaining;
  }

  bool get isPeriodPredictedToday => currentDayOfCycle <= periodDuration;

  CycleSettings copyWith({
    DateTime? lastPeriodDate,
    int? cycleLength,
    int? periodDuration,
  }) {
    return CycleSettings(
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodDuration: periodDuration ?? this.periodDuration,
    );
  }
}

class CycleSettingsNotifier extends Notifier<CycleSettings> {
  static const _keyStart = 'cycle_start_date';
  static const _keyLength = 'cycle_length_days';
  static const _keyDuration = 'period_duration_days';

  @override
  CycleSettings build() {
    _loadFromPrefs();
    // Default: Day 12 of 28 (Follicular phase)
    return CycleSettings(
      lastPeriodDate: DateTime.now().subtract(const Duration(days: 11)),
      cycleLength: 28,
      periodDuration: 5,
    );
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final startStr = prefs.getString(_keyStart);
      final length = prefs.getInt(_keyLength);
      final duration = prefs.getInt(_keyDuration);

      DateTime start = DateTime.now().subtract(const Duration(days: 11));
      if (startStr != null) {
        start = DateTime.tryParse(startStr) ?? start;
      }

      state = CycleSettings(
        lastPeriodDate: start,
        cycleLength: length ?? 28,
        periodDuration: duration ?? 5,
      );
    } catch (_) {}
  }

  Future<void> updateSettings({
    required DateTime lastPeriodDate,
    required int cycleLength,
    required int periodDuration,
  }) async {
    state = CycleSettings(
      lastPeriodDate: lastPeriodDate,
      cycleLength: cycleLength,
      periodDuration: periodDuration,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyStart, lastPeriodDate.toIso8601String());
      await prefs.setInt(_keyLength, cycleLength);
      await prefs.setInt(_keyDuration, periodDuration);
    } catch (_) {}
  }
}

final cycleSettingsProvider =
    NotifierProvider<CycleSettingsNotifier, CycleSettings>(CycleSettingsNotifier.new);
