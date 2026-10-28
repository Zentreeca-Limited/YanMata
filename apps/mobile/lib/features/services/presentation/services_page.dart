import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/services/application/location_provider.dart';
import 'package:yanmata/features/services/application/services_provider.dart';
import 'package:yanmata/features/services/domain/health_service.dart';
import 'package:yanmata/features/services/presentation/service_detail_sheet.dart';

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});

  @override
  ConsumerState<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(healthServicesProvider);
    final activeFilter = ref.watch(servicesFilterProvider);
    final location = ref.watch(selectedLocationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationLabel = location.city == 'All Locations'
        ? 'Nationwide & Global'
        : (location.city == 'Jos'
              ? 'Jos, Plateau State'
              : '${location.city}${location.state.isNotEmpty ? ', ${location.state}' : ''}');

    return PageFrame(
      children: [
        Eyebrow('Health services · $locationLabel'),
        const SizedBox(height: 8),
        Text(
          'Find Health Services',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Palette.darkText : Palette.plum,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Browse available health-service information, location details and verification status.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Palette.darkMuted : Palette.slate,
          ),
        ),
        const SizedBox(height: 18),

        // Search Bar
        TextField(
          controller: _searchController,
          onChanged: (val) =>
              ref.read(servicesSearchQueryProvider.notifier).setQuery(val),
          decoration: InputDecoration(
            hintText: 'Search for a service (e.g. cervical screening)',
            prefixIcon: const Icon(Icons.search, color: Palette.plum),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      ref
                          .read(servicesSearchQueryProvider.notifier)
                          .setQuery('');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE9E2E9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE9E2E9)),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Hospitals', 'Clinics', 'Specialists'].map((
              filter,
            ) {
              final isSelected = activeFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) {
                    ref.read(servicesFilterProvider.notifier).setFilter(filter);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Services',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Palette.plum,
              ),
            ),
            servicesAsync.maybeWhen(
              data: (list) => Text(
                '${list.length} available',
                style: const TextStyle(fontSize: 12, color: Palette.slate),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: 12),

        servicesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, _) => SoftCard(
            color: Palette.blush,
            child: Column(
              children: [
                const Text(
                  'We could not load health services. Check your connection and try again.',
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(healthServicesProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
          data: (services) {
            if (services.isEmpty) {
              return SoftCard(
                color: Colors.white,
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 40,
                      color: Palette.slate,
                    ),
                    const SizedBox(height: 8),
                    Text('No matching services found in ${location.city}.'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        ref
                            .read(servicesSearchQueryProvider.notifier)
                            .setQuery('');
                        ref
                            .read(servicesFilterProvider.notifier)
                            .setFilter('All');
                      },
                      child: const Text('Reset filters'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: services.map((s) => _ServiceCard(service: s)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});
  final HealthService service;

  IconData _iconForCategory(String cat) {
    switch (cat) {
      case 'screening':
        return Icons.medical_services_outlined;
      case 'maternal':
        return Icons.pregnant_woman_outlined;
      case 'mental_health':
        return Icons.psychology_outlined;
      case 'family_planning':
        return Icons.diversity_1_outlined;
      default:
        return Icons.local_hospital_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE9E2E9)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => ServiceDetailSheet.show(context, service),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Palette.lilac,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconForCategory(service.category),
                    color: Palette.plum,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Palette.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${service.providerName} · ${service.distanceKm} km',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Palette.slate,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.priceRange,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Palette.plum,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        service.isAvailable ? 'Available' : 'Book ahead',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Palette.slate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
