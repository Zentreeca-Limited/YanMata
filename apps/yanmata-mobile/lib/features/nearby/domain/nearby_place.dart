enum NearbyCategory {
  all('all', 'All'),
  hospital('hospital', 'Hospitals'),
  clinic('clinic', 'Clinics'),
  pharmacy('pharmacy', 'Pharmacies');

  const NearbyCategory(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

class NearbyCoordinates {
  const NearbyCoordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class NearbyAttribution {
  const NearbyAttribution({required this.provider, this.providerUri});

  final String provider;
  final String? providerUri;

  factory NearbyAttribution.fromJson(Map<String, dynamic> json) {
    return NearbyAttribution(
      provider: json['provider'] as String? ?? '',
      providerUri: json['provider_uri'] as String?,
    );
  }
}

class NearbyPlace {
  const NearbyPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.address,
    required this.distanceKm,
    required this.businessStatus,
    required this.directionsUri,
    required this.placeUri,
    required this.attributions,
  });

  final String id;
  final String name;
  final String category;
  final String categoryLabel;
  final String address;
  final double distanceKm;
  final String businessStatus;
  final String directionsUri;
  final String placeUri;
  final List<NearbyAttribution> attributions;

  bool get isOperational => businessStatus == 'OPERATIONAL';

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    final rawAttributions = json['attributions'] as List<dynamic>? ?? [];

    return NearbyPlace(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'health_service',
      categoryLabel: json['category_label'] as String? ?? 'Health service',
      address: json['address'] as String? ?? '',
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
      businessStatus:
          json['business_status'] as String? ?? 'BUSINESS_STATUS_UNSPECIFIED',
      directionsUri: json['directions_uri'] as String? ?? '',
      placeUri: json['place_uri'] as String? ?? '',
      attributions: rawAttributions
          .whereType<Map<String, dynamic>>()
          .map(NearbyAttribution.fromJson)
          .where((attribution) => attribution.provider.isNotEmpty)
          .toList(growable: false),
    );
  }
}

enum LocationAccessFailure { servicesDisabled, denied, deniedForever, timedOut }

class LocationAccessException implements Exception {
  const LocationAccessException(this.failure);

  final LocationAccessFailure failure;
}

abstract interface class LocationGateway {
  Future<NearbyCoordinates> currentCoordinates();
  Future<bool> openAppSettings();
  Future<bool> openLocationSettings();
}

abstract interface class NearbyPlacesGateway {
  Future<List<NearbyPlace>> search({
    required NearbyCoordinates coordinates,
    required NearbyCategory category,
    int radiusMeters = 10000,
  });
}
