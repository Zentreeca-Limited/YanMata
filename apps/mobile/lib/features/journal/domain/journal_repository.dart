class ConflictItem {
  const ConflictItem({
    required this.entryId,
    required this.localPayload,
    required this.serverPayload,
    required this.serverVersion,
  });
  final String entryId;
  final Map<String, dynamic> localPayload;
  final Map<String, dynamic>? serverPayload;
  final int serverVersion;
}

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
    this.flow = 'none',
    this.symptoms = const [],
    this.energy = 'moderate',
    this.stage,
    this.version = 0,
    this.deleted = false,
  });

  final String id, date, mood, note;
  final String flow;
  final List<String> symptoms;
  final String energy;
  final String? stage;
  final int version;
  final bool deleted;

  Map<String, dynamic> toJson() => {
    'id': id,
    'payload': {
      'date': date,
      'mood': mood,
      'note': note,
      'flow': flow,
      'symptoms': symptoms,
      'energy': energy,
      if (stage != null) 'stage': stage,
    },
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
      flow: p['flow'] ?? 'none',
      symptoms:
          (p['symptoms'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      energy: p['energy'] ?? 'moderate',
      stage: p['stage'],
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
    this.conflictList = const [],
    this.signedIn = false,
    this.ownerId,
    this.token,
    this.userName,
    this.userRole,
  });

  final List<JournalEntry> entries;
  final int pending, conflicts;
  final List<ConflictItem> conflictList;
  final bool signedIn;
  final int? ownerId;
  final String? token;
  final String? userName;
  final String? userRole;

  bool get isStaff =>
      userRole == 'author' ||
      userRole == 'reviewer' ||
      userRole == 'publisher' ||
      userRole == 'specialist' ||
      userRole == 'admin';
}

abstract interface class JournalRepository {
  Future<JournalState> read();
  Future<void> add(
    String mood,
    String note, {
    String? date,
    String flow = 'none',
    List<String> symptoms = const [],
    String energy = 'moderate',
    String? stage,
  });
  Future<void> resolveConflict(String entryId, {required bool keepLocal});
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
