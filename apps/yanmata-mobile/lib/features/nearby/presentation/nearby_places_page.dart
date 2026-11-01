import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/nearby/application/nearby_places_controller.dart';
import 'package:yanmata/features/nearby/domain/nearby_place.dart';

class NearbyPlacesPage extends ConsumerWidget {
  const NearbyPlacesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nearbyPlacesControllerProvider);
    final controller = ref.read(nearbyPlacesControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageFrame(
      children: [
        const Eyebrow('Location-aware care directory'),
        const SizedBox(height: 8),
        Text(
          'Care near you',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Palette.darkText : Palette.plum,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Find nearby hospitals, clinics and pharmacies, then open directions in Google Maps.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: isDark ? Palette.darkMuted : Palette.slate,
          ),
        ),
        const SizedBox(height: 16),
        SoftCard(
          color: isDark ? Palette.darkCard : Palette.lilac,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: isDark ? Palette.darkAccent : Palette.plum,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location stays temporary',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Palette.darkText : Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'YanMata requests foreground location only when you search. Coordinates and results are not saved by YanMata.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: isDark ? Palette.darkMuted : Palette.slate,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: NearbyCategory.values
                .map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category.label),
                      selected: state.category == category,
                      onSelected: state.status == NearbySearchStatus.loading
                          ? null
                          : (_) {
                              if (state.status == NearbySearchStatus.idle ||
                                  state.status == NearbySearchStatus.failure) {
                                controller.selectCategory(category);
                                return;
                              }

                              controller.search(category);
                            },
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 18),
        _SearchBody(state: state),
        if (state.status == NearbySearchStatus.success) ...[
          const SizedBox(height: 14),
          const _GoogleMapsAttribution(),
        ],
        const SizedBox(height: 18),
        SoftCard(
          color: isDark ? Palette.darkCard : Palette.blush,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: Palette.plum),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Listings and availability can change. Confirm details with the facility. This directory is not an emergency or referral service; in an emergency in Nigeria, call 112.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? Palette.darkMuted : Palette.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBody extends ConsumerWidget {
  const _SearchBody({required this.state});

  final NearbyPlacesState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(nearbyPlacesControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state.status) {
      NearbySearchStatus.idle => SoftCard(
        color: isDark ? Palette.darkCard : Colors.white,
        child: Column(
          children: [
            const Icon(Icons.near_me_outlined, size: 42, color: Palette.plum),
            const SizedBox(height: 10),
            Text(
              'Search within 10 kilometres',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Palette.darkText : Palette.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Nothing is searched until you choose to use your current location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Palette.darkMuted : Palette.slate,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: controller.search,
              icon: const Icon(Icons.my_location),
              label: const Text('Use my current location'),
            ),
          ],
        ),
      ),
      NearbySearchStatus.loading => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 42),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 14),
              Text('Finding nearby care…'),
            ],
          ),
        ),
      ),
      NearbySearchStatus.failure => _FailureCard(state: state),
      NearbySearchStatus.success =>
        state.places.isEmpty
            ? SoftCard(
                color: isDark ? Palette.darkCard : Colors.white,
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      size: 40,
                      color: Palette.slate,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No ${state.category.label.toLowerCase()} were found within 10 kilometres.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => controller.search(NearbyCategory.all),
                      child: const Text('Search all nearby care'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${state.places.length} nearby places · closest first',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Palette.plum,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...state.places.map((place) => _PlaceCard(place: place)),
                ],
              ),
    };
  }
}

class _FailureCard extends ConsumerWidget {
  const _FailureCard({required this.state});

  final NearbyPlacesState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(nearbyPlacesControllerProvider.notifier);
    final requiresAppSettings =
        state.locationFailure == LocationAccessFailure.deniedForever;
    final requiresLocationSettings =
        state.locationFailure == LocationAccessFailure.servicesDisabled;

    return SoftCard(
      color: Palette.blush,
      child: Column(
        children: [
          const Icon(Icons.location_disabled_outlined, color: Palette.plum),
          const SizedBox(height: 8),
          Text(state.message ?? 'Nearby care is unavailable.'),
          const SizedBox(height: 10),
          FilledButton.tonal(
            onPressed: requiresAppSettings
                ? controller.openAppSettings
                : requiresLocationSettings
                ? controller.openLocationSettings
                : controller.search,
            child: Text(
              requiresAppSettings
                  ? 'Open app settings'
                  : requiresLocationSettings
                  ? 'Open location settings'
                  : 'Try again',
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends ConsumerWidget {
  const _PlaceCard({required this.place});

  final NearbyPlace place;

  IconData get icon {
    if (place.category.contains('pharmacy') ||
        place.category.contains('drugstore')) {
      return Icons.local_pharmacy_outlined;
    }
    if (place.category.contains('clinic') ||
        place.category.contains('doctor')) {
      return Icons.medical_services_outlined;
    }
    return Icons.local_hospital_outlined;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? Palette.darkCard : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? Palette.darkBorder : const Color(0xFFE9E2E9),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? Palette.darkSurface : Palette.lilac,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Palette.plum),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Palette.darkText : Palette.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${place.categoryLabel} · ${place.distanceKm.toStringAsFixed(1)} km',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Palette.darkAccent : Palette.plum,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                place.address.isEmpty ? 'Address unavailable' : place.address,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: isDark ? Palette.darkMuted : Palette.slate,
                ),
              ),
              if (!place.isOperational &&
                  place.businessStatus != 'BUSINESS_STATUS_UNSPECIFIED') ...[
                const SizedBox(height: 8),
                const Text(
                  'Google Maps does not currently list this place as operational.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
              if (place.attributions.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Data: ${place.attributions.map((item) => item.provider).join(', ')}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Palette.darkMuted : Palette.slate,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: place.directionsUri.isEmpty
                      ? null
                      : () async {
                          final opened = await ref
                              .read(nearbyPlacesControllerProvider.notifier)
                              .openDirections(place);
                          if (!opened && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Google Maps could not be opened on this device.',
                                ),
                              ),
                            );
                          }
                        },
                  icon: const Icon(Icons.directions_outlined),
                  label: const Text('Get directions'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleMapsAttribution extends StatelessWidget {
  const _GoogleMapsAttribution();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Results provided by Google Maps',
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Google Maps',
          softWrap: false,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: isDark ? Colors.white : const Color(0xFF5E5E5E),
          ),
        ),
      ),
    );
  }
}
