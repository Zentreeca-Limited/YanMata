import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/account/domain/health_profile.dart';

class AccountRepository {
  AccountRepository({Api? api}) : _api = api ?? Api();
  final Api _api;

  Future<HealthProfile> fetchProfile({String? token}) async {
    try {
      final res = await _api.request('/profile', token: token);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        return HealthProfile.fromJson(data);
      }
      return const HealthProfile();
    } catch (_) {
      return const HealthProfile();
    }
  }

  Future<HealthProfile> updateProfile(
    Map<String, dynamic> answers, {
    String? token,
  }) async {
    final res = await _api.request(
      '/profile',
      method: 'PUT',
      body: {'answers': answers},
      token: token,
    );
    final data = res['data'];
    if (data is Map<String, dynamic>) {
      return HealthProfile.fromJson(data);
    }
    return HealthProfile(answers: answers);
  }

  Future<List<PersonalizedInsight>> fetchInsights({String? token}) async {
    try {
      final res = await _api.request('/insights', token: token);
      final data = res['data'];
      if (data is List) {
        return data
            .map(
              (item) => PersonalizedInsight.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
