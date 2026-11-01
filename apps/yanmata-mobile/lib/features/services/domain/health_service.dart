class HealthService {
  const HealthService({
    required this.id,
    required this.name,
    required this.category,
    required this.providerName,
    required this.providerType,
    required this.address,
    required this.city,
    required this.distanceKm,
    required this.priceRange,
    required this.isVerified,
    required this.isAvailable,
    required this.description,
    required this.openingHours,
    required this.verificationSource,
    this.phone,
  });

  final String id;
  final String name;
  final String category;
  final String providerName;
  final String providerType;
  final String address;
  final String city;
  final double distanceKm;
  final String priceRange;
  final bool isVerified;
  final bool isAvailable;
  final String description;
  final String openingHours;
  final String verificationSource;
  final String? phone;

  factory HealthService.fromJson(Map<String, dynamic> json) {
    return HealthService(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      providerName: json['provider_name'] as String? ?? '',
      providerType: json['provider_type'] as String? ?? 'hospital',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? 'Jos',
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      priceRange: json['price_range'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? true,
      isAvailable: json['is_available'] as bool? ?? true,
      description: json['description'] as String? ?? '',
      openingHours: json['opening_hours'] as String? ?? '',
      verificationSource: json['verification_source'] as String? ?? '',
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'provider_name': providerName,
    'provider_type': providerType,
    'address': address,
    'city': city,
    'distance_km': distanceKm,
    'price_range': priceRange,
    'is_verified': isVerified,
    'is_available': isAvailable,
    'description': description,
    'opening_hours': openingHours,
    'verification_source': verificationSource,
    'phone': phone,
  };
}
