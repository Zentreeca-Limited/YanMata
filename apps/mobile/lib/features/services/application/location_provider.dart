import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers.dart';

class LocationHub {
  final String id;
  final String city;
  final String state;
  final String country;
  final String label;
  final bool isPilotHub;

  const LocationHub({
    required this.id,
    required this.city,
    required this.state,
    required this.country,
    required this.label,
    this.isPilotHub = false,
  });

  factory LocationHub.fromJson(Map<String, dynamic> json) {
    return LocationHub(
      id: json['id'] as String? ?? 'all',
      city: json['city'] as String? ?? 'All Locations',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? 'Nigeria',
      label: json['label'] as String? ?? 'All Locations',
      isPilotHub: json['is_pilot_hub'] as bool? ?? false,
    );
  }
}

final availableLocationsProvider = FutureProvider<List<LocationHub>>((
  ref,
) async {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/locations'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final list = json['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => LocationHub.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  } catch (_) {}

  // Safe fallback default hubs
  return const [
    LocationHub(
      id: 'all',
      city: 'All Locations',
      state: 'Nationwide & Global',
      country: 'Nigeria',
      label: 'All Locations (Nationwide & Telehealth)',
    ),
    LocationHub(
      id: 'jos',
      city: 'Jos',
      state: 'Plateau State',
      country: 'Nigeria',
      label: 'Jos, Plateau State (Pilot Launch Hub)',
      isPilotHub: true,
    ),
    LocationHub(
      id: 'abuja',
      city: 'Abuja',
      state: 'FCT',
      country: 'Nigeria',
      label: 'Abuja, FCT',
    ),
    LocationHub(
      id: 'lagos',
      city: 'Lagos',
      state: 'Lagos State',
      country: 'Nigeria',
      label: 'Lagos, Lagos State',
    ),
    LocationHub(
      id: 'kano',
      city: 'Kano',
      state: 'Kano State',
      country: 'Nigeria',
      label: 'Kano, Kano State',
    ),
  ];
});

class SelectedLocationNotifier extends Notifier<LocationHub> {
  static const _prefKey = 'selected_location_city';

  @override
  LocationHub build() {
    _loadFromPrefs();
    return const LocationHub(
      id: 'jos',
      city: 'Jos',
      state: 'Plateau State',
      country: 'Nigeria',
      label: 'Jos, Plateau State (Pilot Launch Hub)',
      isPilotHub: true,
    );
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final city = prefs.getString(_prefKey);
      if (city != null) {
        state = LocationHub(
          id: city.toLowerCase(),
          city: city,
          state: '',
          country: 'Nigeria',
          label: city == 'All Locations' ? 'All Locations (Nationwide)' : city,
          isPilotHub: city.toLowerCase() == 'jos',
        );
      }
    } catch (_) {}
  }

  Future<void> setLocation(LocationHub hub) async {
    state = hub;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, hub.city);
    } catch (_) {}
  }
}

final selectedLocationProvider =
    NotifierProvider<SelectedLocationNotifier, LocationHub>(
      SelectedLocationNotifier.new,
    );
