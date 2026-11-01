import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/nearby/data/device_location_gateway.dart';
import 'package:yanmata/features/nearby/data/maps_launcher.dart';
import 'package:yanmata/features/nearby/data/nearby_places_repository.dart';
import 'package:yanmata/features/nearby/domain/nearby_place.dart';

enum NearbySearchStatus { idle, loading, success, failure }

class NearbyPlacesState {
  const NearbyPlacesState({
    this.status = NearbySearchStatus.idle,
    this.category = NearbyCategory.all,
    this.places = const [],
    this.message,
    this.locationFailure,
  });

  final NearbySearchStatus status;
  final NearbyCategory category;
  final List<NearbyPlace> places;
  final String? message;
  final LocationAccessFailure? locationFailure;

  NearbyPlacesState copyWith({
    NearbySearchStatus? status,
    NearbyCategory? category,
    List<NearbyPlace>? places,
    String? message,
    LocationAccessFailure? locationFailure,
    bool clearMessage = false,
    bool clearLocationFailure = false,
  }) {
    return NearbyPlacesState(
      status: status ?? this.status,
      category: category ?? this.category,
      places: places ?? this.places,
      message: clearMessage ? null : (message ?? this.message),
      locationFailure: clearLocationFailure
          ? null
          : (locationFailure ?? this.locationFailure),
    );
  }
}

final locationGatewayProvider = Provider<LocationGateway>((ref) {
  return DeviceLocationGateway();
});

final nearbyPlacesRepositoryProvider = Provider<NearbyPlacesGateway>((ref) {
  return NearbyPlacesRepository();
});

final mapsLauncherProvider = Provider<MapsLauncher>((ref) {
  return MapsLauncher();
});

class NearbyPlacesController extends Notifier<NearbyPlacesState> {
  @override
  NearbyPlacesState build() => const NearbyPlacesState();

  void selectCategory(NearbyCategory category) {
    if (state.status == NearbySearchStatus.loading) {
      return;
    }

    state = state.copyWith(category: category);
  }

  Future<void> search([NearbyCategory? selectedCategory]) async {
    final category = selectedCategory ?? state.category;
    state = state.copyWith(
      status: NearbySearchStatus.loading,
      category: category,
      places: const [],
      clearMessage: true,
      clearLocationFailure: true,
    );

    try {
      final coordinates = await ref
          .read(locationGatewayProvider)
          .currentCoordinates();
      final places = await ref
          .read(nearbyPlacesRepositoryProvider)
          .search(coordinates: coordinates, category: category);
      state = state.copyWith(
        status: NearbySearchStatus.success,
        places: places,
        clearMessage: true,
      );
    } on LocationAccessException catch (error) {
      state = state.copyWith(
        status: NearbySearchStatus.failure,
        message: _locationMessage(error.failure),
        locationFailure: error.failure,
      );
    } catch (_) {
      state = state.copyWith(
        status: NearbySearchStatus.failure,
        message: 'We could not load nearby care. Check your connection and try again.',
      );
    }
  }

  Future<bool> openDirections(NearbyPlace place) {
    return ref.read(mapsLauncherProvider).open(place.directionsUri);
  }

  Future<bool> openAppSettings() {
    return ref.read(locationGatewayProvider).openAppSettings();
  }

  Future<bool> openLocationSettings() {
    return ref.read(locationGatewayProvider).openLocationSettings();
  }

  String _locationMessage(LocationAccessFailure failure) {
    return switch (failure) {
      LocationAccessFailure.servicesDisabled =>
        'Turn on location services to find care near you.',
      LocationAccessFailure.denied => 'Location permission was not granted. YanMata only uses it for this search.',
      LocationAccessFailure.deniedForever => 'Location access is blocked in device settings. Enable it to search nearby.',
      LocationAccessFailure.timedOut => 'We could not get your location in time. Move somewhere with a clearer signal and try again.',
    };
  }
}

final nearbyPlacesControllerProvider =
    NotifierProvider<NearbyPlacesController, NearbyPlacesState>(
      NearbyPlacesController.new,
    );
