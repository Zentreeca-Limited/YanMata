import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/api.dart';
import '../domain/journal_repository.dart';

class LocalJournalRepository implements JournalRepository {
  LocalJournalRepository(this.store, this.api);
  final PrivateStore store;
  final Api api;
  final _lock = Lock();
  final _uuid = const Uuid();
  Future<Map<String, dynamic>> _load() async {
    final raw = await store.read();
    if (raw == null) {
      return {
        'schema_version': 2,
        'entries': <dynamic>[],
        'outbox': <dynamic>[],
        'conflicts': <dynamic>[],
        'cursor': null,
        'token': null,
        'owner_id': null,
        'user_name': null,
        'user_role': null,
      };
    }
    final parsed = jsonDecode(raw) as Map<String, dynamic>;
    parsed.putIfAbsent('schema_version', () => 2);
    parsed.putIfAbsent('entries', () => <dynamic>[]);
    parsed.putIfAbsent('outbox', () => <dynamic>[]);
    parsed.putIfAbsent('conflicts', () => <dynamic>[]);
    return parsed;
  }

  Future<void> _save(Map<String, dynamic> data) =>
      store.write(jsonEncode(data));
  @override
  Future<JournalState> read() => _lock.synchronized(() async {
    final d = await _load();
    final conflictList = (d['conflicts'] as List).map((c) {
      final local = (c['local'] as Map)['payload'] as Map<String, dynamic>;
      final server = c['server'] as Map<String, dynamic>?;
      return ConflictItem(
        entryId: (c['local'] as Map)['entry_id'] as String,
        localPayload: local,
        serverPayload: server?['payload'] as Map<String, dynamic>?,
        serverVersion: (server?['version'] as int?) ?? 0,
      );
    }).toList();

    return JournalState(
      entries: (d['entries'] as List)
          .map((e) => JournalEntry.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => !e.deleted)
          .toList()
          .reversed
          .toList(),
      pending: (d['outbox'] as List).length,
      conflicts: (d['conflicts'] as List).length,
      conflictList: conflictList,
      signedIn: d['token'] != null,
      ownerId: d['owner_id'],
      token: d['token'] as String?,
      userName: d['user_name'] as String?,
      userRole: d['user_role'] as String?,
    );
  });

  @override
  Future<void> add(
    String mood,
    String note, {
    String? date,
    String flow = 'none',
    List<String> symptoms = const [],
    String energy = 'moderate',
    String? stage,
  }) => _lock.synchronized(() async {
    if (!['Great', 'Good', 'Okay', 'Low', 'Difficult'].contains(mood) ||
        note.length > 2000) {
      throw ArgumentError('Invalid journal entry.');
    }
    final d = await _load();
    if ((d['entries'] as List).length >= 10000) {
      throw StateError('Journal storage reached capacity (10,000 entries).');
    }
    final e = JournalEntry(
      id: _uuid.v4(),
      date: date ?? DateTime.now().toIso8601String().substring(0, 10),
      mood: mood,
      note: note,
      flow: flow,
      symptoms: symptoms,
      energy: energy,
      stage: stage,
    );
    (d['entries'] as List).add(e.toJson());
    (d['outbox'] as List).add({
      'mutation_id': _uuid.v4(),
      'entry_id': e.id,
      'expected_version': 0,
      'deleted': false,
      'payload': e.toJson()['payload'],
    });
    await _save(d);
  });

  @override
  Future<void> resolveConflict(String entryId, {required bool keepLocal}) =>
      _lock.synchronized(() async {
        final d = await _load();
        final conflicts = d['conflicts'] as List;
        final index = conflicts.indexWhere(
          (c) =>
              c['local']['entry_id'] == entryId ||
              (c['server'] != null && c['server']['id'] == entryId),
        );
        if (index == -1) return;
        final conflict = conflicts[index];

        final entries = d['entries'] as List;
        entries.removeWhere((e) => e['id'] == entryId);

        if (keepLocal) {
          final localMutation = conflict['local'] as Map;
          final serverVersion = (conflict['server']?['version'] as int?) ?? 1;
          final localEntry = {
            'id': entryId,
            'payload': localMutation['payload'],
            'version': serverVersion + 1,
            'deleted': false,
          };
          entries.add(localEntry);

          (d['outbox'] as List).add({
            'mutation_id': _uuid.v4(),
            'entry_id': entryId,
            'expected_version': serverVersion,
            'deleted': false,
            'payload': localMutation['payload'],
          });
        } else {
          if (conflict['server'] != null) {
            entries.add(conflict['server']);
          }
        }

        conflicts.removeAt(index);
        await _save(d);
      });
  @override
  Future<void> remove(String id) => _lock.synchronized(() async {
    final d = await _load();
    final entries = d['entries'] as List;
    final entry = entries.cast<Map>().firstWhere((e) => e['id'] == id);
    final pending = (d['outbox'] as List).any((m) => m['entry_id'] == id);
    if (pending) {
      throw StateError(
        'Sync pending entries before deleting, or erase the local journal from privacy settings.',
      );
    }
    entry['deleted'] = true;
    (d['outbox'] as List).add({
      'mutation_id': _uuid.v4(),
      'entry_id': id,
      'expected_version': entry['version'],
      'deleted': true,
      'payload': entry['payload'],
    });
    await _save(d);
  });
  @override
  Future<void> connect(String email, String password) =>
      _lock.synchronized(() async {
        final d = await _load();
        final result = await api.request(
          '/mobile/login',
          method: 'POST',
          body: {
            'email': email,
            'password': password,
            'device_name': 'YanMata mobile',
          },
        );
        await _establish(d, result, ensureConsent: true);
      });

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String dateOfBirth,
  }) => _lock.synchronized(() async {
    final d = await _load();
    final result = await api.request(
      '/mobile/register',
      method: 'POST',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'date_of_birth': dateOfBirth,
        'accept_terms': true,
        'device_name': 'YanMata mobile',
      },
    );
    await _establish(d, result, ensureConsent: false);
  });

  Future<void> _establish(
    Map<String, dynamic> d,
    Map<String, dynamic> result, {
    required bool ensureConsent,
  }) async {
    final token = result['token'] as String;
    final user = result['user'] as Map;
    if (d['owner_id'] != null && d['owner_id'] != user['id']) {
      await api.request('/logout', method: 'POST', token: token);
      throw StateError(
        'This journal belongs to another account. Erase this device journal before switching accounts.',
      );
    }
    if (ensureConsent && user['sync_consent'] != true) {
      try {
        await api.request(
          '/consent/sync',
          method: 'PUT',
          token: token,
          body: {'enabled': true},
        );
      } catch (_) {
        await api.request('/logout', method: 'POST', token: token);
        rethrow;
      }
    }
    d['token'] = token;
    d['owner_id'] = user['id'];
    d['user_name'] = user['name'];
    d['user_role'] = user['role'];
    await _save(d);
  }

  @override
  Future<void> sync() => _lock.synchronized(() async {
    final d = await _load();
    final token = d['token'] as String?;
    if (token == null) {
      throw StateError('Connect an account with sync consent first.');
    }
    final outbox = d['outbox'] as List;
    while (outbox.isNotEmpty) {
      final batch = outbox.take(50).toList();
      final response = await api.request(
        '/sync/push',
        method: 'POST',
        token: token,
        body: {'mutations': batch},
      );
      for (final r in response['results'] as List) {
        final matches = outbox
            .where((m) => m['mutation_id'] == r['mutation_id'])
            .toList();
        if (matches.isEmpty) continue;
        final mutation = matches.first;
        if (r['status'] == 'conflict') {
          (d['conflicts'] as List).add({
            'local': mutation,
            'server': r['server'],
          });
        } else {
          final entries = d['entries'] as List;
          entries.removeWhere((e) => e['id'] == mutation['entry_id']);
          entries.add(r['server']);
        }
        outbox.removeWhere((m) => m['mutation_id'] == r['mutation_id']);
      }
      await _save(d);
    }
    bool more = true;
    while (more) {
      final query = d['cursor'] == null
          ? ''
          : '?cursor=${Uri.encodeQueryComponent(d['cursor'])}';
      final result = await api.request('/sync/pull$query', token: token);
      for (final remote in result['entries'] as List) {
        final conflict = (d['conflicts'] as List).any(
          (c) => c['local']['entry_id'] == remote['id'],
        );
        if (conflict) continue;
        final entries = d['entries'] as List;
        entries.removeWhere((e) => e['id'] == remote['id']);
        entries.add(remote);
      }
      d['cursor'] = result['cursor'];
      more = result['has_more'] == true;
      await _save(d);
    }
  });
  @override
  Future<void> disconnect() => _lock.synchronized(() async {
    final d = await _load();
    if (d['token'] != null) {
      await api.request('/logout', method: 'POST', token: d['token']);
    }
    d['token'] = null;
    d['user_name'] = null;
    d['user_role'] = null;
    await _save(d);
  });
  @override
  Future<void> erase() => _lock.synchronized(() async {
    final d = await _load();
    if (d['token'] != null) {
      throw StateError('Disconnect your account before erasing local data.');
    }
    await store.delete();
  });
}
