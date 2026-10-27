import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/risk/application/risk_provider.dart';
import 'package:yanmata/features/specialists/presentation/care_page.dart';

class RiskDetailsPage extends ConsumerStatefulWidget {
  const RiskDetailsPage({super.key, this.initialTab = 'Cervical'});
  final String initialTab;

  @override
  ConsumerState<RiskDetailsPage> createState() => _RiskDetailsPageState();
}

class _RiskDetailsPageState extends ConsumerState<RiskDetailsPage> {
  late String _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final riskAsync = ref.watch(riskAssessmentProvider);

    return Scaffold(
      backgroundColor: Palette.cream,
      appBar: AppBar(
        title: const Text('Detailed Risk Report'),
        backgroundColor: Palette.cream,
        elevation: 0,
      ),
      body: riskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) {
          final factors = data.keyFactors[_currentTab] ?? [];
          int score = data.overallRiskScore;
          String label = data.overallRiskLabel;
          if (_currentTab == 'Cervical') {
            score = data.cervicalRiskScore;
            label = 'Moderate Risk';
          } else if (_currentTab == 'Breast') {
            score = data.breastRiskScore;
            label = 'Low to Moderate Risk';
          } else if (_currentTab == 'Hormonal') {
            score = data.hormonalRiskScore;
            label = 'Moderate Risk';
          }

          return PageFrame(
            children: [
              // Segmented Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Cervical', 'Breast', 'Hormonal', 'General'].map((tab) {
                    final isSelected = _currentTab == tab;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tab),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _currentTab = tab),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Category Assessment Card
              SoftCard(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Palette.lilac,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Palette.plum,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_currentTab Health Risk',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.plum,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$label ($score%)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFC2410C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Based on your recorded age, screening intervals, symptoms, and lifestyle indicators.',
                      style: const TextStyle(fontSize: 13, color: Palette.slate, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Key Factors
              const Text(
                'Key Factors',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Palette.plum,
                ),
              ),
              const SizedBox(height: 10),

              ...factors.map((factor) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE9E2E9)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFFC2410C),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              factor,
                              style: const TextStyle(fontSize: 13, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 20),

              // What You Can Do
              const Text(
                'What You Can Do',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Palette.plum,
                ),
              ),
              const SizedBox(height: 10),

              ...data.recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCFCE7)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF16A34A),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              rec,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.3,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const Care(),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Consult YanMata Specialist in Jos'),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Palette.cream,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9E2E9)),
                ),
                child: Text(
                  'Traceable source: ${data.traceableSource}',
                  style: const TextStyle(fontSize: 11, color: Palette.slate),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
