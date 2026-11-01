import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yanmata/core/providers.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';

class CycleSettings {
  final DateTime lastPeriodDate;
  final int cycleLength;
  final int periodDuration;

  /// False until the member has answered the setup questions; UI must not
  /// present predictions in that state.
  final bool configured;
  final DateTime? editedAt;

  const CycleSettings({
    required this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodDuration = 5,
    this.configured = true,
    this.editedAt,
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
      configured: configured,
      editedAt: editedAt,
    );
  }
}

class CycleSettingsNotifier extends Notifier<CycleSettings> {
  static const _keyStart = 'cycle_start_date';
  static const _keyLength = 'cycle_length_days';
  static const _keyDuration = 'period_duration_days';
  static const _keyEdited = 'cycle_edited_at';

  static CycleSettings get _unset =>
      CycleSettings(lastPeriodDate: DateTime.now(), configured: false);

  @override
  CycleSettings build() {
    _loadFromPrefs();
    // Re-converge with the backend whenever an account is connected.
    ref.listen<String?>(journalProvider.select((j) => j.value?.token), (
      _,
      token,
    ) {
      if (token != null) sync();
    });
    return _unset;
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final start = DateTime.tryParse(prefs.getString(_keyStart) ?? '');
      if (start == null) return;
      state = CycleSettings(
        lastPeriodDate: start,
        cycleLength: prefs.getInt(_keyLength) ?? 28,
        periodDuration: prefs.getInt(_keyDuration) ?? 5,
        editedAt: DateTime.tryParse(prefs.getString(_keyEdited) ?? ''),
      );
      await sync();
    } catch (_) {}
  }

  Future<void> updateSettings({
    required DateTime lastPeriodDate,
    required int cycleLength,
    required int periodDuration,
  }) async {
    final now = DateTime.now().toUtc();
    state = CycleSettings(
      lastPeriodDate: lastPeriodDate,
      cycleLength: cycleLength,
      periodDuration: periodDuration,
      editedAt: now,
    );
    await _persist(state);
    await sync();
  }

  Future<void> _persist(CycleSettings c) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyStart, c.lastPeriodDate.toIso8601String());
      await prefs.setInt(_keyLength, c.cycleLength);
      await prefs.setInt(_keyDuration, c.periodDuration);
      if (c.editedAt != null) {
        await prefs.setString(_keyEdited, c.editedAt!.toIso8601String());
      }
    } catch (_) {}
  }

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Last-write-wins sync with the account. Silent when offline or signed out;
  /// the next connect/start/edit retries.
  Future<void> sync() async {
    final token = ref.read(journalProvider).value?.token;
    if (token == null) return;
    final api = ref.read(apiProvider);
    try {
      final remote = (await api.request(
        '/cycle-settings',
        token: token,
      ))['data'];
      final local = state;
      final remoteAt = remote is Map
          ? DateTime.tryParse('${remote['updated_at']}')
          : null;
      final localNewer =
          local.configured &&
          (remote == null ||
              local.editedAt == null ||
              (remoteAt != null && local.editedAt!.isAfter(remoteAt)));
      if (localNewer) {
        final res = await api.request(
          '/cycle-settings',
          method: 'PUT',
          token: token,
          body: {
            'last_period_date': _ymd(local.lastPeriodDate),
            'cycle_length': local.cycleLength,
            'period_duration': local.periodDuration,
            if (local.editedAt != null)
              'client_updated_at': local.editedAt!.toIso8601String(),
          },
        );
        if (res['applied'] == true || res['data'] == null) return;
        _adopt(res['data'] as Map);
      } else if (remote is Map) {
        _adopt(remote);
      }
    } catch (_) {}
  }

  void _adopt(Map r) {
    final start = DateTime.tryParse('${r['last_period_date']}');
    if (start == null) return;
    state = CycleSettings(
      lastPeriodDate: start,
      cycleLength: (r['cycle_length'] as num?)?.toInt() ?? 28,
      periodDuration: (r['period_duration'] as num?)?.toInt() ?? 5,
      editedAt: DateTime.tryParse('${r['updated_at']}'),
    );
    _persist(state);
  }
}

final cycleSettingsProvider =
    NotifierProvider<CycleSettingsNotifier, CycleSettings>(
      CycleSettingsNotifier.new,
    );
