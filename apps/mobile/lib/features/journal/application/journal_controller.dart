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

  Future<void> add(String mood, String note) =>
      _run(() => _repo.add(mood, note));
  Future<void> remove(String id) => _run(() => _repo.remove(id));
  Future<void> connect(String email, String password) =>
      _run(() => _repo.connect(email, password));
  Future<void> sync() => _run(_repo.sync);
  Future<void> disconnect() => _run(_repo.disconnect);
  Future<void> erase() => _run(_repo.erase);
}
