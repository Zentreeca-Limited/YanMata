import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../application/location_provider.dart';

class LocationPickerSheet extends ConsumerWidget {
  const LocationPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LocationPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(availableLocationsProvider);
    final selected = ref.watch(selectedLocationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Palette.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Palette.darkBorder : const Color(0xFFE2D6E4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Your Location',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Palette.darkText : Palette.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tailor healthcare services and wellness products to your area.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Palette.darkMuted : Palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            available.when(
              data: (hubs) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hubs.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: isDark ? Palette.darkBorder : const Color(0xFFF3EBF4),
                ),
                itemBuilder: (context, index) {
                  final hub = hubs[index];
                  final isSelected =
                      hub.city.toLowerCase() == selected.city.toLowerCase();

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Palette.plum
                            : (isDark
                                  ? Palette.darkSurface
                                  : Palette.lilac.withValues(alpha: 0.3)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        hub.city.toLowerCase().contains('all')
                            ? Icons.public_rounded
                            : Icons.location_on_rounded,
                        size: 20,
                        color: isSelected ? Colors.white : Palette.plum,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          hub.city,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isDark ? Palette.darkText : Palette.ink,
                          ),
                        ),
                        if (hub.isPilotHub) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Palette.blush,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'LOCAL HUB',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Palette.plum,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      hub.state.isNotEmpty
                          ? '${hub.state}, ${hub.country}'
                          : hub.country,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Palette.darkMuted : Palette.muted,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Palette.plum,
                          )
                        : null,
                    onTap: () {
                      ref
                          .read(selectedLocationProvider.notifier)
                          .setLocation(hub);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: Palette.plum),
                ),
              ),
              error: (error, stack) => const Text('Unable to load locations'),
            ),
          ],
        ),
      ),
    );
  }
}
