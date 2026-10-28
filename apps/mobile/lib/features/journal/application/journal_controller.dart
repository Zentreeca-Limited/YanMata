import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  JournalRepository get _repo => ref.read(journalRepositoryProvider);
  @override
  Future<JournalState> build() => _repo.read();
  Future<void> _run(Future<void> Function() action) async {
    await action();
    state = AsyncData(await _repo.read());
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
  Future<void> connect(String email, String password) =>
      _run(() => _repo.connect(email, password));
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
  );
  Future<void> sync() => _run(_repo.sync);
  Future<void> disconnect() => _run(_repo.disconnect);
  Future<void> logout() => _run(_repo.logout);
  Future<void> deleteAccount(String password) =>
      _run(() => _repo.deleteAccount(password));
  Future<void> erase() => _run(_repo.erase);
}
