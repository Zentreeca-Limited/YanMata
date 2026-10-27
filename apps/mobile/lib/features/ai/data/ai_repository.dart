import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/ai_companion_model.dart';

class AiRepository {
  final String baseUrl;
  final http.Client _client;

  AiRepository({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<AiMessage> sendMessage({
    required String prompt,
    required String language,
    int? cycleDay,
    String? phase,
  }) async {
    final uri = Uri.parse('$baseUrl/ai/companion/chat');
    final payload = <String, dynamic>{
      'prompt': prompt,
      'language': language,
    };
    if (cycleDay != null) payload['cycle_day'] = cycleDay;
    if (phase != null) payload['phase'] = phase;

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;

      final helplinesRaw = data['helplines'] as List<dynamic>? ?? [];
      final helplines = helplinesRaw.map((e) => Map<String, String>.from(e as Map)).toList();

      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: data['reply'] as String? ?? '',
        isUser: false,
        timestamp: DateTime.now(),
        isEmergency: data['is_emergency'] as bool? ?? false,
        citations: (data['citations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        helplines: helplines,
        suggestedActions: (data['suggested_actions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        followUps: (data['follow_up_questions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
    } else {
      throw Exception('Failed to send message: HTTP ${response.statusCode}');
    }
  }

  Future<CycleInsightsModel> getCycleInsights({
    int cycleLength = 28,
    int periodDuration = 5,
    int currentDay = 12,
    String language = 'en',
  }) async {
    final uri = Uri.parse('$baseUrl/ai/cycle/insights');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'cycle_length': cycleLength,
        'period_duration': periodDuration,
        'current_day': currentDay,
        'language': language,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return CycleInsightsModel.fromJson(json['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch cycle insights: HTTP ${response.statusCode}');
    }
  }
}
