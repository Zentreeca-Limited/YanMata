import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/services/domain/health_service.dart';

class ServicesRepository {
  ServicesRepository({Api? api}) : _api = api ?? Api();
  final Api _api;

  Future<List<HealthService>> fetchServices({
    String? category,
    String? query,
    String? providerType,
    String? city,
  }) async {
    try {
      final queryParams = <String>[];
      if (category != null && category.isNotEmpty && category != 'All') {
        queryParams.add(
          'category=${Uri.encodeComponent(category.toLowerCase())}',
        );
      }
      if (providerType != null &&
          providerType.isNotEmpty &&
          providerType != 'All') {
        queryParams.add(
          'type=${Uri.encodeComponent(providerType.toLowerCase())}',
        );
      }
      if (query != null && query.isNotEmpty) {
        queryParams.add('query=${Uri.encodeComponent(query)}');
      }
      if (city != null &&
          city.isNotEmpty &&
          !city.toLowerCase().contains('all')) {
        queryParams.add('city=${Uri.encodeComponent(city)}');
      }

      final qs = queryParams.isEmpty ? '' : '?${queryParams.join('&')}';
      final res = await _api.request('/services$qs');
      final list = (res['data'] as List<dynamic>?) ?? [];
      return list
          .map((e) => HealthService.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw StateError('Unable to load health services: $error');
    }
  }
}
