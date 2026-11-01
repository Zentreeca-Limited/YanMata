import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:yanmata/features/nearby/domain/nearby_place.dart';

class DeviceLocationGateway implements LocationGateway {
  @override
  Future<NearbyCoordinates> currentCoordinates() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationAccessException(
        LocationAccessFailure.servicesDisabled,
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationAccessException(LocationAccessFailure.deniedForever);
    }
    if (permission == LocationPermission.denied) {
      throw const LocationAccessException(LocationAccessFailure.denied);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return NearbyCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on TimeoutException {
      throw const LocationAccessException(LocationAccessFailure.timedOut);
    }
  }

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
