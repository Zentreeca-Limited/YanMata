import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/features/nearby/application/nearby_places_controller.dart';
import 'package:yanmata/features/nearby/domain/nearby_place.dart';
import 'package:yanmata/features/nearby/presentation/nearby_places_page.dart';

class FakeLocationGateway implements LocationGateway {
  FakeLocationGateway({this.failure});

  final LocationAccessFailure? failure;
  int requests = 0;

  @override
  Future<NearbyCoordinates> currentCoordinates() async {
    requests += 1;
    if (failure != null) {
      throw LocationAccessException(failure!);
    }

    return const NearbyCoordinates(latitude: 9.9, longitude: 8.9);
  }

  @override
  Future<bool> openAppSettings() async => true;

  @override
  Future<bool> openLocationSettings() async => true;
}

class FakeNearbyPlacesGateway implements NearbyPlacesGateway {
  NearbyCategory? requestedCategory;

  @override
  Future<List<NearbyPlace>> search({
    required NearbyCoordinates coordinates,
    required NearbyCategory category,
    int radiusMeters = 10000,
  }) async {
    requestedCategory = category;

    return const [
      NearbyPlace(
        id: 'place-1',
        name: 'Nearby Community Clinic',
        category: 'medical_clinic',
        categoryLabel: 'Medical clinic',
        address: 'Jos, Plateau State',
        distanceKm: 1.2,
        businessStatus: 'OPERATIONAL',
        directionsUri:
            'https://www.google.com/maps/dir/?api=1&destination=clinic',
        placeUri: 'https://maps.google.com/?cid=clinic',
        attributions: [],
      ),
    ];
  }
}

void main() {
  setUpAll(() async {
    final loader = FontLoader('Manrope')
      ..addFont(rootBundle.load('assets/fonts/Manrope.ttf'));
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  test('search uses foreground location and exposes nearby results', () async {
    final location = FakeLocationGateway();
    final places = FakeNearbyPlacesGateway();
    final container = ProviderContainer(
      overrides: [
        locationGatewayProvider.overrideWithValue(location),
        nearbyPlacesRepositoryProvider.overrideWithValue(places),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(nearbyPlacesControllerProvider.notifier)
        .search(NearbyCategory.clinic);
    final state = container.read(nearbyPlacesControllerProvider);

    expect(location.requests, 1);
    expect(places.requestedCategory, NearbyCategory.clinic);
    expect(state.status, NearbySearchStatus.success);
    expect(state.places.single.name, 'Nearby Community Clinic');
  });

  test('permanently denied location returns the settings state', () async {
    final container = ProviderContainer(
      overrides: [
        locationGatewayProvider.overrideWithValue(
          FakeLocationGateway(failure: LocationAccessFailure.deniedForever),
        ),
        nearbyPlacesRepositoryProvider.overrideWithValue(
          FakeNearbyPlacesGateway(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(nearbyPlacesControllerProvider.notifier).search();
    final state = container.read(nearbyPlacesControllerProvider);

    expect(state.status, NearbySearchStatus.failure);
    expect(state.locationFailure, LocationAccessFailure.deniedForever);
    expect(state.message, contains('device settings'));
  });

  testWidgets('nearby page does not request location before member action', (
    tester,
  ) async {
    final location = FakeLocationGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationGatewayProvider.overrideWithValue(location),
          nearbyPlacesRepositoryProvider.overrideWithValue(
            FakeNearbyPlacesGateway(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: NearbyPlacesPage())),
      ),
    );

    expect(find.text('Location stays temporary'), findsOneWidget);
    expect(find.text('Use my current location'), findsOneWidget);
    expect(location.requests, 0);
  });

  testWidgets('category selection alone does not request location', (
    tester,
  ) async {
    final location = FakeLocationGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationGatewayProvider.overrideWithValue(location),
          nearbyPlacesRepositoryProvider.overrideWithValue(
            FakeNearbyPlacesGateway(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: NearbyPlacesPage())),
      ),
    );

    await tester.tap(find.text('Clinics'));
    await tester.pump();

    expect(location.requests, 0);
    expect(find.text('Use my current location'), findsOneWidget);
  });

  testWidgets('nearby page supports compact width and 200 percent text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationGatewayProvider.overrideWithValue(FakeLocationGateway()),
          nearbyPlacesRepositoryProvider.overrideWithValue(
            FakeNearbyPlacesGateway(),
          ),
        ],
        child: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(body: NearbyPlacesPage()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Care near you'), findsOneWidget);
    expect(find.text('Use my current location'), findsOneWidget);
  });

  testWidgets('nearby opt-in screen has a stable phone layout', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationGatewayProvider.overrideWithValue(FakeLocationGateway()),
          nearbyPlacesRepositoryProvider.overrideWithValue(
            FakeNearbyPlacesGateway(),
          ),
        ],
        child: MaterialApp(
          theme: Palette.lightTheme,
          home: const Scaffold(body: NearbyPlacesPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    if (Platform.isMacOS) {
      await expectLater(
        find.byType(NearbyPlacesPage),
        matchesGoldenFile('goldens/nearby-phone.png'),
      );
    }
    expect(tester.takeException(), isNull);
  });
}
