import '../../../core/api.dart';
import '../domain/specialist.dart';

abstract interface class CareRepository {
  Future<List<Specialist>> getSpecialists();
  Future<List<SupportRequestItem>> getMyRequests(String token);
  Future<SupportRequestItem> createRequest(
    String token, {
    required String topic,
    required String stage,
    required String summary,
    required bool shareJournalConsent,
    String? specialistId,
  });
  Future<CareConversationItem> getConversation(String token, String conversationId);
  Future<CareMessageItem> sendMessage(String token, String conversationId, String body);
}

class RemoteCareRepository implements CareRepository {
  const RemoteCareRepository(this.api);
  final Api api;

  @override
  Future<List<Specialist>> getSpecialists() async {
    final response = await api.request('/specialists');
    final data = (response['data'] as List?) ?? [];
    return data.map((json) => Specialist.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  @override
  Future<List<SupportRequestItem>> getMyRequests(String token) async {
    final response = await api.request('/care/requests', token: token);
    final data = (response['data'] as List?) ?? [];
    return data.map((json) => SupportRequestItem.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  @override
  Future<SupportRequestItem> createRequest(
    String token, {
    required String topic,
    required String stage,
    required String summary,
    required bool shareJournalConsent,
    String? specialistId,
  }) async {
    final response = await api.request(
      '/care/requests',
      method: 'POST',
      token: token,
      body: {
        'topic': topic,
        'stage': stage,
        'summary': summary,
        'share_journal_consent': shareJournalConsent,
        'specialist_id': ?specialistId,
      },
    );
    return SupportRequestItem.fromJson(Map<String, dynamic>.from(response['data']));
  }

  @override
  Future<CareConversationItem> getConversation(String token, String conversationId) async {
    final response = await api.request('/care/conversations/$conversationId', token: token);
    return CareConversationItem.fromJson(Map<String, dynamic>.from(response['data']));
  }

  @override
  Future<CareMessageItem> sendMessage(String token, String conversationId, String body) async {
    final response = await api.request(
      '/care/conversations/$conversationId/messages',
      method: 'POST',
      token: token,
      body: {'body': body},
    );
    return CareMessageItem.fromJson(Map<String, dynamic>.from(response['data']));
  }
}
