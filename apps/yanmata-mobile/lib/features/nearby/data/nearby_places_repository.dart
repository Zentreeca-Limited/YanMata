import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/nearby/domain/nearby_place.dart';

class NearbyPlacesRepository implements NearbyPlacesGateway {
  NearbyPlacesRepository({Api? api}) : _api = api ?? Api();

  final Api _api;

  @override
  Future<List<NearbyPlace>> search({
    required NearbyCoordinates coordinates,
    required NearbyCategory category,
    int radiusMeters = 10000,
  }) async {
    final response = await _api.request(
      '/nearby-places/search',
      method: 'POST',
      body: {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
        'category': category.apiValue,
        'radius_meters': radiusMeters,
      },
    );
    final data = response['data'] as List<dynamic>? ?? [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(NearbyPlace.fromJson)
        .where((place) => place.id.isNotEmpty && place.name.isNotEmpty)
        .toList(growable: false);
  }
}
