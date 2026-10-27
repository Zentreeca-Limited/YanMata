import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/mental_health/presentation/mental_health_page.dart';
import 'package:yanmata/features/risk/presentation/early_detection_page.dart';
import 'package:yanmata/features/risk/presentation/risk_overview_page.dart';

class Today extends ConsumerWidget {
  const Today({
    super.key,
    required this.onTrack,
    required this.onServices,
    required this.onProducts,
    required this.onProfile,
    required this.onLearn,
  });

  final VoidCallback onTrack;
  final VoidCallback onServices;
  final VoidCallback onProducts;
  final VoidCallback onProfile;
  final VoidCallback onLearn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider).value;

    return PageFrame(
      children: [
        // Brand & Status Bar
        Row(
          children: [
            const Icon(Icons.spa_outlined, color: Palette.plum, size: 32),
            const SizedBox(width: 8),
            const Text(
              'YanMata',
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Palette.plum,
                letterSpacing: -1,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Palette.lilac,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PREVIEW',
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: Palette.plum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Personalized Greeting Header (Wireframe Screen 2)
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Good day, Aisha ☀️',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Palette.plum,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Your health matters. You’re not alone.',
                    style: TextStyle(fontSize: 13, color: Palette.slate),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onProfile,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Palette.lilac,
                  shape: BoxShape.circle,
                  border: Border.all(color: Palette.plum, width: 1.5),
                ),
                child: const Icon(Icons.person, color: Palette.plum, size: 24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const Eyebrow('A little care, every day'),
        const SizedBox(height: 8),
        Text(
          'A moment,\njust for you.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          'Growing. Changing. Always you.\nThere’s room for every kind of day here.',
        ),
        const SizedBox(height: 20),

        // Next Cycle Summary Card
        SoftCard(
          color: Colors.white,
          child: InkWell(
            onTap: onTrack,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: Color(0xFFE11D48),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Next cycle in Day 12 of 28',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Palette.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Follicular Phase · View cycle details →',
                          style: TextStyle(
                            fontSize: 12,
                            color: Palette.plum,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Feature Shortcuts from Wireframe Screen 2
        _FeatureCard(
          icon: Icons.shield_outlined,
          title: 'Your Health Risk Prediction',
          subtitle: 'See your personalised risk summary and recommendations →',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const RiskOverviewPage(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        _FeatureCard(
          icon: Icons.psychology_outlined,
          title: 'Mental Health Support',
          subtitle: 'Talk to a professional or access supportive resources →',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const MentalHealthPage(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        _FeatureCard(
          icon: Icons.local_hospital_outlined,
          title: 'Find Health Services',
          subtitle: 'Verified hospitals, clinics & specialists in Jos →',
          onTap: onServices,
        ),
        const SizedBox(height: 12),

        _FeatureCard(
          icon: Icons.shopping_bag_outlined,
          title: 'Shop Health Products',
          subtitle: 'Verified pharmacies & wellness products in Jos →',
          onTap: onProducts,
        ),
        const SizedBox(height: 12),

        _FeatureCard(
          icon: Icons.biotech_outlined,
          title: 'Early Detection & Screening',
          subtitle: 'Detect early. Protect your future with regular checks →',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const EarlyDetectionPage(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Daily Check-in CTA
        SoftCard(
          color: Palette.blush,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: Palette.plum),
                  SizedBox(width: 8),
                  Text(
                    'DAILY REFLECTION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Palette.plum,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'How are you, really?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              const Text(
                'You don’t have to find the perfect words. Start with how you feel today.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onTrack,
                child: const Text('Check in with yourself'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Journal moments count
        SoftCard(
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Icons.favorite_outline, color: Palette.plum, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Small moments matter.',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Palette.ink),
                    ),
                    Text(
                      '${journal?.entries.length ?? 0} private moments recorded on this phone',
                      style: const TextStyle(fontSize: 12, color: Palette.slate),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9E2E9)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Palette.lilac,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Palette.plum, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Palette.slate,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 20, color: Palette.slate),
            ],
          ),
        ),
      ),
    );
  }
}
