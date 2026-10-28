class Specialist {
  const Specialist({
    required this.id,
    required this.name,
    required this.title,
    required this.credentials,
    required this.specialty,
    required this.bio,
    required this.city,
    required this.verificationSource,
    required this.isVerified,
    required this.isAvailable,
  });

  final String id,
      name,
      title,
      credentials,
      specialty,
      bio,
      city,
      verificationSource;
  final bool isVerified, isAvailable;

  factory Specialist.fromJson(Map<String, dynamic> json) => Specialist(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    title: json['title'] ?? '',
    credentials: json['credentials'] ?? '',
    specialty: json['specialty'] ?? '',
    bio: json['bio'] ?? '',
    city: json['city'] ?? 'Jos, Plateau State',
    verificationSource: json['verification_source'] ?? '',
    isVerified: json['is_verified'] ?? false,
    isAvailable: json['is_available'] ?? false,
  );
}

class CareMessageItem {
  const CareMessageItem({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderRole,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  final String id, conversationId, senderRole, body;
  final int senderId;
  final bool isRead;
  final String createdAt;

  factory CareMessageItem.fromJson(Map<String, dynamic> json) =>
      CareMessageItem(
        id: json['id'] ?? '',
        conversationId: json['conversation_id'] ?? '',
        senderId: (json['sender_id'] as num?)?.toInt() ?? 0,
        senderRole: json['sender_role'] ?? 'member',
        body: json['body'] ?? '',
        isRead: json['is_read'] ?? false,
        createdAt: json['created_at'] ?? '',
      );
}

class CareConversationItem {
  const CareConversationItem({
    required this.id,
    required this.supportRequestId,
    required this.userId,
    required this.specialistId,
    required this.status,
    this.specialist,
    this.messages = const [],
    this.lastMessageAt,
  });

  final String id, supportRequestId, specialistId, status;
  final int userId;
  final Specialist? specialist;
  final List<CareMessageItem> messages;
  final String? lastMessageAt;

  factory CareConversationItem.fromJson(Map<String, dynamic> json) =>
      CareConversationItem(
        id: json['id'] ?? '',
        supportRequestId: json['support_request_id'] ?? '',
        userId: (json['user_id'] as num?)?.toInt() ?? 0,
        specialistId: json['specialist_id'] ?? '',
        status: json['status'] ?? 'open',
        lastMessageAt: json['last_message_at'],
        specialist: json['specialist'] != null
            ? Specialist.fromJson(Map<String, dynamic>.from(json['specialist']))
            : null,
        messages: ((json['messages'] as List?) ?? [])
            .map((m) => CareMessageItem.fromJson(Map<String, dynamic>.from(m)))
            .toList(),
      );
}

class SupportRequestItem {
  const SupportRequestItem({
    required this.id,
    required this.topic,
    required this.stage,
    required this.summary,
    required this.status,
    required this.shareJournalConsent,
    this.specialistId,
    this.conversationId,
    this.specialist,
    this.createdAt,
  });

  final String id, topic, stage, summary, status;
  final String? specialistId, conversationId, createdAt;
  final bool shareJournalConsent;
  final Specialist? specialist;

  factory SupportRequestItem.fromJson(Map<String, dynamic> json) =>
      SupportRequestItem(
        id: json['id'] ?? '',
        topic: json['topic'] ?? '',
        stage: json['stage'] ?? '',
        summary: json['summary'] ?? '',
        status: json['status'] ?? 'pending',
        specialistId: json['specialist_id'],
        conversationId: json['conversation_id'],
        shareJournalConsent: json['share_journal_consent'] ?? false,
        createdAt: json['created_at'],
        specialist: json['specialist'] != null
            ? Specialist.fromJson(Map<String, dynamic>.from(json['specialist']))
            : null,
      );
}
