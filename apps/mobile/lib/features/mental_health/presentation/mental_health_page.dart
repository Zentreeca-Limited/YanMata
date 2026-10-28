import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/specialists/presentation/care_page.dart';

class MentalHealthPage extends StatefulWidget {
  const MentalHealthPage({super.key});

  @override
  State<MentalHealthPage> createState() => _MentalHealthPageState();
}

class _MentalHealthPageState extends State<MentalHealthPage> {
  String _selectedMood = 'Okay';

  void _showConcernModal(String title, String summary, List<String> tips) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Palette.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
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
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Palette.plum,
                ),
              ),
              const SizedBox(height: 10),
              Text(summary, style: const TextStyle(fontSize: 14, height: 1.5)),
              const SizedBox(height: 18),
              const Text(
                'Coping Strategies',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Palette.plum,
                ),
              ),
              const SizedBox(height: 8),
              ...tips.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.spa, size: 16, color: Palette.plum),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          t,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Understood'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.cream,
      appBar: AppBar(
        title: const Text('Mental Health Support'),
        backgroundColor: Palette.cream,
        elevation: 0,
      ),
      body: PageFrame(
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Palette.plum,
            ),
          ),
          const SizedBox(height: 14),

          // Mood Emojis Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                [
                  ('Great', '😄'),
                  ('Good', '🙂'),
                  ('Okay', '😐'),
                  ('Low', '😔'),
                  ('Very low', '😢'),
                ].map((m) {
                  final isSelected = _selectedMood == m.$1;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedMood = m.$1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Noticed: Feeling ${m.$1} today.'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: isSelected ? Palette.plum : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Palette.plum
                                  : const Color(0xFFE9E2E9),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            m.$2,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          m.$1,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? Palette.plum : Palette.slate,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 28),

          const Text(
            'Common Concerns',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Palette.plum,
            ),
          ),
          const SizedBox(height: 12),

          _ConcernCard(
            icon: Icons.psychology_outlined,
            title: 'Anxiety & Stress',
            subtitle: 'Learn gentle nervous system coping strategies',
            onTap: () => _showConcernModal(
              'Anxiety & Stress Coping Strategies',
              'When anxiety peaks, the nervous system enters overdrive. Practicing structured grounding returns your breathing and heart rate to calm regulation.',
              [
                '5-4-3-2-1 Grounding: Notice 5 things you see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste.',
                'Box Breathing: 4-count inhale, 4-count hold, 4-count exhale, 4-count pause.',
                'Gentle pacing: Give yourself permission to pause tasks without guilt.',
              ],
            ),
          ),
          const SizedBox(height: 10),

          _ConcernCard(
            icon: Icons.water_drop_outlined,
            title: 'Mood Changes',
            subtitle: 'Understand what is normal across your monthly cycle',
            onTap: () => _showConcernModal(
              'Navigating Hormonal Mood Fluctuations',
              'Estrogen and progesterone shifts during the premenstrual luteal phase naturally affect brain neurotransmitters like serotonin.',
              [
                'Track mood daily in your YanMata journal to recognise monthly rhythms.',
                'Prioritise restful sleep and warm hydration.',
                'Speak with our gynaecology team if mood shifts disrupt daily routines.',
              ],
            ),
          ),
          const SizedBox(height: 10),

          _ConcernCard(
            icon: Icons.family_restroom_outlined,
            title: 'Postpartum Depression',
            subtitle: 'Know the signs & get compassionate support',
            onTap: () => _showConcernModal(
              'Maternal Wellbeing & Postpartum Care',
              'The transition to motherhood carries enormous emotional and hormonal changes. Postpartum depression is treatable and seeking support is a sign of strength.',
              [
                'Accept practical community help with resting and infant care.',
                'Speak openly with a midwife or clinical counsellor in Jos.',
                'Remember that feelings of fatigue do not define your love or capability.',
              ],
            ),
          ),
          const SizedBox(height: 10),

          _ConcernCard(
            icon: Icons.support_agent_outlined,
            title: 'Talk to a Professional',
            subtitle: 'Find an accredited therapist or clinical nurse in Jos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const Care()),
            ),
          ),
          const SizedBox(height: 24),

          // Supportive banner
          SoftCard(
            color: const Color(0xFFF3E8FF),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Palette.plum, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'You are not alone.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Palette.plum,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Confidential, non-judgmental support is always available.',
                        style: TextStyle(fontSize: 12, color: Palette.ink),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Emergency Helpline Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE9E2E9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Emergency & Crisis Support in Nigeria',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Palette.plum,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '• SURPIN Toll-Free: 0800 123 4567 / 0908 021 7555\n• Emergency Ambulance / Police: 112\n• Asido Foundation Helpline: 0902 808 0416',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Palette.slate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConcernCard extends StatelessWidget {
  const _ConcernCard({
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
                    const SizedBox(height: 2),
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
