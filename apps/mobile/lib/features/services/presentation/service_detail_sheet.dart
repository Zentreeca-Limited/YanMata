import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/features/services/domain/health_service.dart';

class ServiceDetailSheet extends StatelessWidget {
  const ServiceDetailSheet({super.key, required this.service});
  final HealthService service;

  static void show(BuildContext context, HealthService service) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceDetailSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Palette.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6C7D6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 14, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 4),
                      Text(
                        service.isVerified ? 'VERIFIED PROVIDER' : 'LISTED',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E7D32),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              service.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Palette.plum,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              service.providerName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Palette.slate,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Badge(icon: Icons.location_on_outlined, text: '${service.distanceKm} km · ${service.city}'),
                _Badge(icon: Icons.payments_outlined, text: service.priceRange),
                _Badge(icon: Icons.access_time_outlined, text: service.openingHours),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'About this service',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Palette.plum),
            ),
            const SizedBox(height: 6),
            Text(
              service.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE9E2E9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Facility address & verification',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Palette.slate),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.address,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 14, color: Palette.plum),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service.verificationSource,
                          style: const TextStyle(fontSize: 11, color: Palette.slate),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Inquiry sent to ${service.providerName}. YanMata care team notified.'),
                    backgroundColor: Palette.plum,
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Contact Service Provider'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9E2E9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Palette.plum),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
