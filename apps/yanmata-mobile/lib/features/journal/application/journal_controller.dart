import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yanmata/core/notifications.dart';
import 'package:yanmata/core/providers.dart';

import '../data/private_store.dart';
import '../data/local_journal_repository.dart';
import '../domain/journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => LocalJournalRepository(
    const DevicePrivateStore(),
    ref.watch(apiProvider),
  ),
);
final journalProvider = AsyncNotifierProvider<JournalController, JournalState>(
  JournalController.new,
);

class JournalController extends AsyncNotifier<JournalState> {
  static const _autoConnectEmail = String.fromEnvironment('AUTO_CONNECT_EMAIL');
  static const _autoConnectPassword = String.fromEnvironment(
    'AUTO_CONNECT_PASSWORD',
  );

  JournalRepository get _repo => ref.read(journalRepositoryProvider);
  @override
  Future<JournalState> build() async {
    var initial = await _repo.read();
    if (_autoConnectEmail.isNotEmpty &&
        _autoConnectPassword.isNotEmpty &&
        (!initial.signedIn ||
            initial.userEmail?.toLowerCase() !=
                _autoConnectEmail.toLowerCase())) {
      try {
        if (initial.signedIn) {
          try {
            await _repo.disconnect();
          } catch (_) {}
          try {
            await _repo.erase();
          } catch (_) {}
        }
        await _repo.connect(_autoConnectEmail, _autoConnectPassword);
        initial = await _repo.read();
      } on StateError {
        try {
          await _repo.erase();
          await _repo.connect(_autoConnectEmail, _autoConnectPassword);
          initial = await _repo.read();
        } catch (_) {}
      } catch (_) {}
    }
    if (initial.token != null) {
      Future.microtask(() => _registerCurrentDevice(initial.token));
    }
    return initial;
  }

  Future<void> _registerCurrentDevice(
    String? token, {
    bool requestPermission = false,
  }) async {
    if (token == null) return;
    final platform = DeviceService.currentPlatformName();
    final deviceService = ref.read(deviceServiceProvider);
    if (requestPermission) {
      await deviceService.requestNotificationPermission();
    }
    final deviceId = await deviceService.getOrCreateDeviceId();
    await deviceService.registerDevice(
      platform: platform,
      token: token,
      deviceName: 'YanMata ${platform.toUpperCase()}',
      pushToken: 'fcm-$platform-$deviceId',
    );
  }

  Future<void> _run(
    Future<void> Function() action, {
    bool requestPushPermission = false,
  }) async {
    await action();
    final updated = await _repo.read();
    state = AsyncData(updated);
    if (updated.token != null) {
      await _registerCurrentDevice(
        updated.token,
        requestPermission: requestPushPermission,
      );
    }
  }

  Future<void> add(
    String mood,
    String note, {
    String? date,
    String flow = 'none',
    List<String> symptoms = const [],
    String energy = 'moderate',
    String? stage,
  }) => _run(
    () => _repo.add(
      mood,
      note,
      date: date,
      flow: flow,
      symptoms: symptoms,
      energy: energy,
      stage: stage,
    ),
  );

  Future<void> resolveConflict(String entryId, {required bool keepLocal}) =>
      _run(() => _repo.resolveConflict(entryId, keepLocal: keepLocal));
  Future<void> remove(String id) => _run(() => _repo.remove(id));
  Future<void> connect(String email, String password) => _run(
    () => _repo.connect(email, password),
    requestPushPermission: true,
  );
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String dateOfBirth,
  }) => _run(
    () => _repo.register(
      name: name,
      email: email,
      password: password,
      dateOfBirth: dateOfBirth,
    ),
    requestPushPermission: true,
  );
  Future<void> requestPasswordReset(String email) =>
      _repo.requestPasswordReset(email);
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _repo.resetPassword(
    email: email,
    code: code,
    newPassword: newPassword,
  );
  Future<void> sendEmailVerification() => _run(_repo.sendEmailVerification);
  Future<void> verifyEmail(String code) => _run(() => _repo.verifyEmail(code));
  Future<void> sync() => _run(_repo.sync);
  Future<void> disconnect() => _run(_repo.disconnect);
  Future<void> logout() => _run(_repo.logout);
  Future<void> deleteAccount(String password) =>
      _run(() => _repo.deleteAccount(password));
  Future<void> erase() => _run(_repo.erase);
}
