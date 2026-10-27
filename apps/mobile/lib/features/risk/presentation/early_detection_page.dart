import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/risk/presentation/risk_overview_page.dart';
import 'package:yanmata/features/services/presentation/services_page.dart';

class EarlyDetectionPage extends StatelessWidget {
  const EarlyDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.cream,
      appBar: AppBar(
        title: const Text('Early Detection'),
        backgroundColor: Palette.cream,
        elevation: 0,
      ),
      body: PageFrame(
        children: [
          // Hero card
          SoftCard(
            color: Palette.lilac,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.health_and_safety_outlined,
                  color: Palette.plum,
                  size: 36,
                ),
                const SizedBox(height: 12),
                Text(
                  'Detect early.\nProtect your future.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Palette.plum,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Evidence-based preventive screening identifies health changes early, making clinical intervention simpler, more effective, and less costly.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Screening & Prevention in Jos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Palette.plum,
            ),
          ),
          const SizedBox(height: 12),

          _ScreeningCard(
            icon: Icons.biotech_outlined,
            title: 'Cervical Cancer Screening',
            subtitle: 'Pap smear / HPV DNA testing (Recommended every 3 years)',
            facility: 'Available at JUTH & Plateau Specialist Hospital',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ServicesPage()),
            ),
          ),
          const SizedBox(height: 12),

          _ScreeningCard(
            icon: Icons.favorite_border,
            title: 'Breast Health Check',
            subtitle: 'Clinical breast exam / Mammography guidance',
            facility: 'Available at Plateau Specialist Hospital',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ServicesPage()),
            ),
          ),
          const SizedBox(height: 12),

          _ScreeningCard(
            icon: Icons.medical_services_outlined,
            title: 'Other Preventive Checks',
            subtitle: 'Routine blood pressure, iron levels, and reproductive wellness',
            facility: 'Available at Primary Healthcare Centre Tudun Wada',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ServicesPage()),
            ),
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const RiskOverviewPage(),
              ),
            ),
            child: const Text('Start Risk Assessment'),
          ),
          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('How Early Detection Works'),
                content: const Text(
                  'YanMata aligns with World Health Organization (WHO) and Nigerian Federal Ministry of Health guidelines. By assessing age-stratified indicators and tracking recurring symptoms, we recommend when to seek professional screening in Jos.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
            child: const Text('How it works'),
          ),
        ],
      ),
    );
  }
}

class _ScreeningCard extends StatelessWidget {
  const _ScreeningCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.facility,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String facility;
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Palette.slate),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      facility,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Palette.plum,
                        fontWeight: FontWeight.w500,
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
