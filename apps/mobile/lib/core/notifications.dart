import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'api.dart';
import 'providers.dart';
import '../features/journal/application/journal_controller.dart';
import '../features/journal/data/private_store.dart';
import '../features/journal/domain/journal_repository.dart';

class NotificationPreferences {
  const NotificationPreferences({
    this.careMessages = true,
    this.editorialUpdates = false,
    this.quietHoursEnabled = true,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
    this.checkInReminderEnabled = true,
    this.checkInReminderTime = '20:00',
  });

  final bool careMessages;
  final bool editorialUpdates;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final bool checkInReminderEnabled;
  final String checkInReminderTime;

  static const String discreetLockScreenTitle = 'A quiet moment';
  static const String discreetLockScreenBody =
      'How has your day felt so far?';

  bool isInQuietHours(TimeOfDay time) {
    if (!quietHoursEnabled) return false;
    final startParts = quietHoursStart.split(':').map(int.parse).toList();
    final endParts = quietHoursEnd.split(':').map(int.parse).toList();
    final currentMinutes = time.hour * 60 + time.minute;
    final startMinutes = startParts[0] * 60 + startParts[1];
    final endMinutes = endParts[0] * 60 + endParts[1];

    if (startMinutes > endMinutes) {
      // Overnight (e.g. 22:00 to 07:00)
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    } else {
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    }
  }

  NotificationPreferences copyWith({
    bool? careMessages,
    bool? editorialUpdates,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? checkInReminderEnabled,
    String? checkInReminderTime,
  }) {
    return NotificationPreferences(
      careMessages: careMessages ?? this.careMessages,
      editorialUpdates: editorialUpdates ?? this.editorialUpdates,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      checkInReminderEnabled:
          checkInReminderEnabled ?? this.checkInReminderEnabled,
      checkInReminderTime: checkInReminderTime ?? this.checkInReminderTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'care_messages': careMessages,
        'editorial_updates': editorialUpdates,
        'quiet_hours_enabled': quietHoursEnabled,
        'quiet_hours_start': quietHoursStart,
        'quiet_hours_end': quietHoursEnd,
        'check_in_reminder_enabled': checkInReminderEnabled,
        'check_in_reminder_time': checkInReminderTime,
      };

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      careMessages: json['care_messages'] as bool? ?? true,
      editorialUpdates: json['editorial_updates'] as bool? ?? false,
      quietHoursEnabled: json['quiet_hours_enabled'] as bool? ?? true,
      quietHoursStart: json['quiet_hours_start'] as String? ?? '22:00',
      quietHoursEnd: json['quiet_hours_end'] as String? ?? '07:00',
      checkInReminderEnabled:
          json['check_in_reminder_enabled'] as bool? ?? true,
      checkInReminderTime:
          json['check_in_reminder_time'] as String? ?? '20:00',
    );
  }
}

class DeviceService {
  DeviceService(this._store, this._api);

  final PrivateStore _store;
  final Api _api;
  static const _deviceIdKey = 'yanmata_device_uuid_v1';
  static const _prefsKey = 'yanmata_notification_prefs_v1';
  static const _uuid = Uuid();

  Future<String> getOrCreateDeviceId() async {
    final raw = await _store.read();
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        if (data[_deviceIdKey] is String) {
          return data[_deviceIdKey] as String;
        }
      } catch (_) {}
    }
    final newId = _uuid.v4();
    return newId;
  }

  Future<NotificationPreferences> loadPreferences(String? token) async {
    // 1. Try local cache
    final raw = await _store.read();
    NotificationPreferences prefs = const NotificationPreferences();
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        if (data[_prefsKey] is Map) {
          prefs = NotificationPreferences.fromJson(
            Map<String, dynamic>.from(data[_prefsKey] as Map),
          );
        }
      } catch (_) {}
    }

    // 2. If signed in, sync from server
    if (token != null) {
      try {
        final res = await _api.request(
          '/notification-preferences',
          token: token,
        );
        if (res['data'] is Map) {
          final serverData = Map<String, dynamic>.from(res['data'] as Map);
          prefs = prefs.copyWith(
            careMessages: serverData['care_messages'] as bool?,
            editorialUpdates: serverData['editorial_updates'] as bool?,
            quietHoursEnabled: serverData['quiet_hours_enabled'] as bool?,
            quietHoursStart: serverData['quiet_hours_start'] as String?,
            quietHoursEnd: serverData['quiet_hours_end'] as String?,
          );
        }
      } catch (_) {}
    }

    return prefs;
  }

  Future<void> savePreferences(
    NotificationPreferences prefs,
    String? token,
  ) async {
    final raw = await _store.read();
    Map<String, dynamic> data = {};
    if (raw != null) {
      try {
        data = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {}
    }
    data[_prefsKey] = prefs.toJson();
    await _store.write(jsonEncode(data));

    if (token != null) {
      try {
        await _api.request(
          '/notification-preferences',
          method: 'PUT',
          token: token,
          body: {
            'care_messages': prefs.careMessages,
            'editorial_updates': prefs.editorialUpdates,
            'quiet_hours_enabled': prefs.quietHoursEnabled,
            'quiet_hours_start': prefs.quietHoursStart,
            'quiet_hours_end': prefs.quietHoursEnd,
          },
        );
      } catch (_) {}
    }
  }

  Future<void> registerDevice({
    required String platform,
    required String? token,
    String? pushToken,
    String? deviceName,
  }) async {
    if (token == null) return;
    final deviceId = await getOrCreateDeviceId();
    try {
      await _api.request(
        '/devices',
        method: 'POST',
        token: token,
        body: {
          'device_id': deviceId,
          'platform': platform,
          'device_name': deviceName ?? 'Mobile Device',
          'push_token': pushToken,
          'push_enabled': true,
        },
      );
    } catch (_) {}
  }
}

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService(
    const DevicePrivateStore(),
    ref.watch(apiProvider),
  );
});

final notificationPreferencesProvider =
    AsyncNotifierProvider<NotificationPreferencesNotifier, NotificationPreferences>(
  NotificationPreferencesNotifier.new,
);

class NotificationPreferencesNotifier
    extends AsyncNotifier<NotificationPreferences> {
  DeviceService get _service => ref.read(deviceServiceProvider);

  @override
  Future<NotificationPreferences> build() async {
    final journal = ref.watch(journalProvider).value;
    return _service.loadPreferences(journal?.token);
  }

  Future<void> savePreferences(NotificationPreferences newPrefs) async {
    final journal = ref.read(journalProvider).value;
    state = AsyncData(newPrefs);
    await _service.savePreferences(newPrefs, journal?.token);
  }

  Future<void> toggleCareMessages(bool enabled) async {
    final current = state.value ?? const NotificationPreferences();
    await savePreferences(current.copyWith(careMessages: enabled));
  }

  Future<void> toggleQuietHours(bool enabled) async {
    final current = state.value ?? const NotificationPreferences();
    await savePreferences(current.copyWith(quietHoursEnabled: enabled));
  }

  Future<void> setQuietHours(String start, String end) async {
    final current = state.value ?? const NotificationPreferences();
    await savePreferences(current.copyWith(
      quietHoursStart: start,
      quietHoursEnd: end,
    ));
  }

  Future<void> toggleCheckInReminder(bool enabled) async {
    final current = state.value ?? const NotificationPreferences();
    await savePreferences(current.copyWith(checkInReminderEnabled: enabled));
  }

  Future<void> setCheckInTime(String time) async {
    final current = state.value ?? const NotificationPreferences();
    await savePreferences(current.copyWith(checkInReminderTime: time));
  }
}
