import '../../../core/api.dart';

class StaffContentItem {
  const StaffContentItem({
    required this.id,
    required this.title,
    required this.topic,
    required this.stage,
    required this.summary,
    required this.body,
    required this.sourceUrl,
    required this.status,
    required this.isDemo,
    this.authorName,
    this.reviewerName,
    this.publishedAt,
    this.reviewDueAt,
  });

  final String id;
  final String title;
  final String topic;
  final String stage;
  final String summary;
  final String body;
  final String sourceUrl;
  final String status;
  final bool isDemo;
  final String? authorName;
  final String? reviewerName;
  final String? publishedAt;
  final String? reviewDueAt;

  factory StaffContentItem.fromJson(Map<String, dynamic> json) {
    return StaffContentItem(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      topic: json['topic'] as String? ?? 'General',
      stage: json['stage'] as String? ?? 'All',
      summary: json['summary'] as String? ?? '',
      body: json['body'] as String? ?? '',
      sourceUrl: json['source_url'] as String? ?? '',
      status: json['status'] as String? ?? 'draft',
      isDemo: json['is_demo'] as bool? ?? false,
      authorName: json['author']?['name'] as String?,
      reviewerName: json['reviewer']?['name'] as String?,
      publishedAt: json['published_at'] as String?,
      reviewDueAt: json['review_due_at'] as String?,
    );
  }
}

class StaffCareRequestItem {
  const StaffCareRequestItem({
    required this.id,
    required this.topic,
    required this.stage,
    required this.summary,
    required this.status,
    required this.shareJournalConsent,
    this.specialistId,
    this.specialistName,
    this.userName,
    this.createdAt,
  });

  final String id;
  final String topic;
  final String stage;
  final String summary;
  final String status;
  final bool shareJournalConsent;
  final String? specialistId;
  final String? specialistName;
  final String? userName;
  final String? createdAt;

  factory StaffCareRequestItem.fromJson(Map<String, dynamic> json) {
    return StaffCareRequestItem(
      id: json['id'] as String,
      topic: json['topic'] as String? ?? 'General',
      stage: json['stage'] as String? ?? 'General',
      summary: json['summary'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      shareJournalConsent: json['share_journal_consent'] as bool? ?? false,
      specialistId: json['specialist_id'] as String?,
      specialistName: json['specialist']?['name'] as String?,
      userName: json['user']?['name'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}

class StaffRepository {
  StaffRepository(this._api);

  final Api _api;

  Future<List<StaffContentItem>> fetchStudioContent(String token) async {
    final res = await _api.request('/studio/content', token: token);
    final list = res['data'] as List? ?? [];
    return list
        .map((e) => StaffContentItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<StaffContentItem> createContent({
    required String token,
    required String title,
    required String topic,
    required String stage,
    required String summary,
    required String body,
    required String sourceUrl,
  }) async {
    final res = await _api.request(
      '/studio/content',
      method: 'POST',
      token: token,
      body: {
        'title': title,
        'topic': topic,
        'stage': stage,
        'summary': summary,
        'body': body,
        'source_url': sourceUrl,
      },
    );
    return StaffContentItem.fromJson(
      Map<String, dynamic>.from(res['data'] as Map),
    );
  }

  Future<StaffContentItem> transitionContent({
    required String token,
    required String id,
    required String action,
    String? notes,
  }) async {
    final res = await _api.request(
      '/studio/content/$id/transition',
      method: 'POST',
      token: token,
      body: {
        'action': action,
        'notes': ?notes,
        if (action == 'approve')
          'review_due_at':
              DateTime.now().add(const Duration(days: 90)).toIso8601String(),
      },
    );
    return StaffContentItem.fromJson(
      Map<String, dynamic>.from(res['data'] as Map),
    );
  }

  Future<List<StaffCareRequestItem>> fetchStudioCareRequests(String token) async {
    final res = await _api.request('/studio/care/requests', token: token);
    final list = res['data'] as List? ?? [];
    return list
        .map((e) =>
            StaffCareRequestItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> assignSpecialist({
    required String token,
    required String requestId,
    required String specialistId,
  }) async {
    await _api.request(
      '/studio/care/requests/$requestId/assign',
      method: 'POST',
      token: token,
      body: {'specialist_id': specialistId},
    );
  }
}
