import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/risk/application/risk_provider.dart';
import 'package:yanmata/features/risk/presentation/health_profile_page.dart';
import 'package:yanmata/features/risk/presentation/risk_details_page.dart';

class RiskOverviewPage extends ConsumerWidget {
  const RiskOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riskAsync = ref.watch(riskAssessmentProvider);

    return Scaffold(
      backgroundColor: Palette.cream,
      appBar: AppBar(
        title: const Text('Health Risk Prediction'),
        backgroundColor: Palette.cream,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('About Risk Estimation'),
                content: const Text(
                  'Risk predictions are indicative estimates based on your profile inputs and clinical guidelines (WHO & FMOH Nigeria). They are not medical diagnoses. Consult an accredited specialist for clinical evaluation.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Understood'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: riskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) => PageFrame(
          children: [
            const Text(
              'Your personalised risk assessment is based on the information you’ve provided.',
              style: TextStyle(fontSize: 14, color: Palette.slate),
            ),
            const SizedBox(height: 24),

            // Circular Risk Gauge Card
            SoftCard(
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    'Your Overall Risk',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Palette.slate,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: data.overallRiskScore / 100,
                          strokeWidth: 12,
                          backgroundColor: const Color(0xFFF3E8FF),
                          valueColor: const AlwaysStoppedAnimation<Color>(Palette.plum),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.overallRiskLabel,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Palette.plum,
                            ),
                          ),
                          Text(
                            '(${data.overallRiskScore}%)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Palette.slate,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'You have a ${data.overallRiskLabel.toLowerCase()} risk of developing certain women’s health conditions based on your lifestyle and screening history.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Key Risk Areas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.plum,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const HealthProfilePage(),
                    ),
                  ),
                  child: const Text('Update Profile'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _RiskAreaCard(
              icon: Icons.shield_outlined,
              title: 'Cervical Cancer',
              riskScore: data.cervicalRiskScore,
              riskLabel: 'Moderate risk',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const RiskDetailsPage(initialTab: 'Cervical'),
                ),
              ),
            ),
            const SizedBox(height: 10),

            _RiskAreaCard(
              icon: Icons.favorite_outline,
              title: 'Breast Health',
              riskScore: data.breastRiskScore,
              riskLabel: 'Low to moderate risk',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const RiskDetailsPage(initialTab: 'Breast'),
                ),
              ),
            ),
            const SizedBox(height: 10),

            _RiskAreaCard(
              icon: Icons.wb_iridescent_outlined,
              title: 'Hormonal Health',
              riskScore: data.hormonalRiskScore,
              riskLabel: 'Moderate risk',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const RiskDetailsPage(initialTab: 'Hormonal'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const RiskDetailsPage(),
                ),
              ),
              child: const Text('View Full Report'),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const HealthProfilePage(),
                ),
              ),
              child: const Text('Edit Risk Factors & Inputs'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskAreaCard extends StatelessWidget {
  const _RiskAreaCard({
    required this.icon,
    required this.title,
    required this.riskScore,
    required this.riskLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final int riskScore;
  final String riskLabel;
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      '$riskLabel ($riskScore%)',
                      style: const TextStyle(fontSize: 12, color: Palette.slate),
                    ),
                  ],
                ),
              ),
              Row(
                children: const [
                  Text(
                    'View details',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Palette.plum,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: Palette.plum),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
