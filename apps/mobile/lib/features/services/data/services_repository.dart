import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/services/domain/health_service.dart';

class ServicesRepository {
  ServicesRepository({Api? api}) : _api = api ?? Api();
  final Api _api;

  static const List<HealthService> fallbackServices = [
    HealthService(
      id: 'srv-01',
      name: 'Cervical Cancer Screening',
      category: 'screening',
      providerName: 'Synthetic Jos Hospital One',
      providerType: 'hospital',
      address: 'Lamingo Road, Jos, Plateau State',
      city: 'Jos',
      distanceKm: 2.3,
      priceRange: 'Demo estimate only',
      isVerified: false,
      isAvailable: false,
      description: 'Comprehensive cervical screening (Pap smear, HPV DNA testing, and visual inspection) with clinical follow-up by consultant gynaecologists.',
      openingHours: 'Mon - Fri, 8:00 AM - 4:00 PM',
      verificationSource: 'Synthetic fixture; no provider verification claim',
    ),
    HealthService(
      id: 'srv-02',
      name: 'Maternal Care',
      category: 'maternal',
      providerName: 'Synthetic Jos Hospital Two',
      providerType: 'hospital',
      address: 'Bank Road, Jos, Plateau State',
      city: 'Jos',
      distanceKm: 3.1,
      priceRange: 'Demo estimate only',
      isVerified: false,
      isAvailable: false,
      description: 'Comprehensive antenatal, obstetric assessment and maternal health services staffed by licensed midwives and specialists.',
      openingHours:
          '24/7 Maternity Emergency; Clinics: Mon - Thu 9:00 AM - 3:00 PM',
      verificationSource: 'Synthetic fixture; no provider verification claim',
    ),
    HealthService(
      id: 'srv-03',
      name: 'Mental Health Support',
      category: 'mental_health',
      providerName: 'Synthetic Jos Clinic Three',
      providerType: 'clinic',
      address: 'Rayfield, Jos, Plateau State',
      city: 'Jos',
      distanceKm: 4.8,
      priceRange: 'Demo estimate only',
      isVerified: false,
      isAvailable: false,
      description: 'Compassionate psychological counseling, anxiety & stress management, and postpartum emotional support in a peaceful setting.',
      openingHours: 'Mon - Sat, 9:00 AM - 6:00 PM',
      verificationSource: 'Synthetic fixture; no provider verification claim',
    ),
    HealthService(
      id: 'srv-04',
      name: 'Family Planning',
      category: 'family_planning',
      providerName: 'Synthetic Jos Clinic Four',
      providerType: 'clinic',
      address: 'Tudun Wada, Jos North, Plateau State',
      city: 'Jos',
      distanceKm: 5.2,
      priceRange: 'Demo estimate only',
      isVerified: false,
      isAvailable: false,
      description: 'Confidential reproductive health education, family planning consultations, and maternal wellness guidance.',
      openingHours: 'Mon - Fri, 8:30 AM - 3:30 PM',
      verificationSource: 'Synthetic fixture; no provider verification claim',
    ),
    HealthService(
      id: 'srv-05',
      name: 'Specialist Clinical Consultation',
      category: 'specialist',
      providerName: 'Synthetic In-App Support Service',
      providerType: 'specialist',
      address: 'In-Platform Telehealth / Jos Clinical Centre',
      city: 'Jos',
      distanceKm: 0.0,
      priceRange: 'Demo estimate only',
      isVerified: false,
      isAvailable: false,
      description: 'Direct, confidential inquiry and structured follow-up with accredited Nigerian gynaecologists and adolescent health nurses inside YanMata.',
      openingHours: 'Mon - Sat, 8:00 AM - 8:00 PM',
      verificationSource: 'Synthetic fixture; no provider verification claim',
    ),
  ];

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
      if (list.isEmpty) {
        return _filterLocal(
          fallbackServices,
          category,
          providerType,
          query,
          city,
        );
      }
      return list
          .map((e) => HealthService.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _filterLocal(
        fallbackServices,
        category,
        providerType,
        query,
        city,
      );
    }
  }

  List<HealthService> _filterLocal(
    List<HealthService> services,
    String? category,
    String? providerType,
    String? query, [
    String? city,
  ]) {
    return services.where((s) {
      if (city != null &&
          city.isNotEmpty &&
          !city.toLowerCase().contains('all') &&
          !s.city.toLowerCase().contains(city.toLowerCase()) &&
          !s.city.toLowerCase().contains('nationwide')) {
        return false;
      }
      if (category != null &&
          category != 'All' &&
          !s.category.toLowerCase().contains(category.toLowerCase())) {
        return false;
      }
      if (providerType != null &&
          providerType != 'All' &&
          !s.providerType.toLowerCase().contains(providerType.toLowerCase())) {
        return false;
      }
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        return s.name.toLowerCase().contains(q) ||
            s.providerName.toLowerCase().contains(q) ||
            s.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }
}
