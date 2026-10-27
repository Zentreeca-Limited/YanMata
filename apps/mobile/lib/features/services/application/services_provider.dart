import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/services/application/location_provider.dart';
import 'package:yanmata/features/services/data/services_repository.dart';
import 'package:yanmata/features/services/domain/health_service.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return ServicesRepository();
});

class ServicesFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setFilter(String val) => state = val;
}

final servicesFilterProvider =
    NotifierProvider<ServicesFilterNotifier, String>(ServicesFilterNotifier.new);

class ServicesSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final servicesSearchQueryProvider =
    NotifierProvider<ServicesSearchQueryNotifier, String>(
  ServicesSearchQueryNotifier.new,
);

final healthServicesProvider =
    FutureProvider.autoDispose<List<HealthService>>((ref) async {
  final repo = ref.watch(servicesRepositoryProvider);
  final filter = ref.watch(servicesFilterProvider);
  final query = ref.watch(servicesSearchQueryProvider);
  final selectedLocation = ref.watch(selectedLocationProvider);

  String? providerType;
  if (filter != 'All') {
    if (filter == 'Hospitals') {
      providerType = 'hospital';
    } else if (filter == 'Clinics') {
      providerType = 'clinic';
    } else if (filter == 'Specialists') {
      providerType = 'specialist';
    }
  }

  return repo.fetchServices(
    providerType: providerType,
    query: query.isEmpty ? null : query,
    city: selectedLocation.city.toLowerCase().contains('all') ? null : selectedLocation.city,
  );
});
