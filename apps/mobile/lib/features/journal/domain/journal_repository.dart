class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
    this.version = 0,
    this.deleted = false,
  });
  final String id, date, mood, note;
  final int version;
  final bool deleted;
  Map<String, dynamic> toJson() => {
    'id': id,
    'payload': {'date': date, 'mood': mood, 'note': note},
    'version': version,
    'deleted': deleted,
  };
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    final p = (json['payload'] as Map?) ?? {};
    return JournalEntry(
      id: json['id'],
      date: p['date'] ?? '',
      mood: p['mood'] ?? 'Okay',
      note: p['note'] ?? '',
      version: json['version'] ?? 0,
      deleted: json['deleted'] ?? false,
    );
  }
}

class JournalState {
  const JournalState({
    this.entries = const [],
    this.pending = 0,
    this.conflicts = 0,
    this.signedIn = false,
    this.ownerId,
  });
  final List<JournalEntry> entries;
  final int pending, conflicts;
  final bool signedIn;
  final int? ownerId;
}

abstract interface class JournalRepository {
  Future<JournalState> read();
  Future<void> add(String mood, String note);
  Future<void> remove(String id);
  Future<void> connect(String email, String password);
  Future<void> sync();
  Future<void> disconnect();
  Future<void> erase();
}

abstract interface class PrivateStore {
  Future<String?> read();
  Future<void> write(String value);
  Future<void> delete();
}
