import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/theme.dart';
import '../../../core/ui_feedback.dart';
import '../../../core/widgets.dart';
import '../../ai/presentation/ai_companion_page.dart';
import '../application/cycle_settings_provider.dart';
import '../application/journal_controller.dart';
import 'cycle_setup_dialog.dart';

class Track extends ConsumerStatefulWidget {
  const Track({super.key});
  @override
  ConsumerState<Track> createState() => _TrackState();
}

class _TrackState extends ConsumerState<Track> {
  String _activeTab = 'Cycle';
  String mood = 'Okay';
  String flow = 'none';
  String energy = 'moderate';
  String sleepDuration = '7h 20m';
  final List<String> selectedSymptoms = [];
  final note = TextEditingController();
  bool busy = false;
  String? error;

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  Future<void> save() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await ref
          .read(journalProvider.notifier)
          .add(
            mood,
            note.text.trim(),
            flow: flow,
            symptoms: selectedSymptoms,
            energy: energy,
          );
      note.clear();
      setState(() {
        selectedSymptoms.clear();
        flow = 'none';
        energy = 'moderate';
      });
      if (mounted) {
        YanMataFeedback.showSuccessSnackbar(context, ref.tr('checkin_saved'));
      }
    } catch (e) {
      setState(() => error = e.toString());
      if (mounted) {
        YanMataFeedback.showErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalProvider);
    final cycle = ref.watch(cycleSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final progress = (cycle.currentDayOfCycle / cycle.cycleLength).clamp(
      0.0,
      1.0,
    );

    return PageFrame(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(ref.tr('track_subtitle')),
                  const SizedBox(height: 6),
                  Text(
                    ref.tr('track_title'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Palette.darkText : Palette.plum,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: ref.tr('set_cycle_details'),
              icon: const Icon(Icons.tune_rounded, color: Palette.plum),
              onPressed: () => CycleSetupDialog.show(context),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Notice your patterns without judgment. Every feeling has a place.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Palette.darkMuted : Palette.slate,
          ),
        ),
        const SizedBox(height: 16),

        // Sub-tabs: Cycle, Mood, Symptoms, Insights
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                [
                  ('Cycle', ref.tr('tab_cycle')),
                  ('Mood', ref.tr('tab_mood')),
                  ('Symptoms', ref.tr('tab_symptoms')),
                  ('Insights', ref.tr('tab_insights')),
                ].map((tab) {
                  final isSelected = _activeTab == tab.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab.$2),
                      selected: isSelected,
                      selectedColor: Palette.plum,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Palette.darkText : Palette.ink),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      backgroundColor: isDark ? Palette.darkCard : Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? Palette.plum
                            : (isDark
                                  ? Palette.darkBorder
                                  : const Color(0xFFE2D6E4)),
                      ),
                      onSelected: (_) => setState(() => _activeTab = tab.$1),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Circular Cycle Dial Card
        SoftCard(
          color: isDark ? Palette.darkCard : Colors.white,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 156,
                    height: 156,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 11,
                      backgroundColor: isDark
                          ? Palette.darkSurface
                          : const Color(0xFFFCE7F3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Palette.darkAccent : Palette.plum,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.water_drop,
                        color: Color(0xFFE11D48),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Day ${cycle.currentDayOfCycle}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Palette.darkText : Palette.plum,
                        ),
                      ),
                      Text(
                        'of ${cycle.cycleLength}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Palette.darkMuted : Palette.slate,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Palette.darkSurface : Palette.cream,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Palette.darkBorder
                        : const Color(0xFFE9E2E9),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Palette.plum,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cycle.currentPhase,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Palette.darkText : Palette.plum,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getPhaseDescription(cycle.currentPhase),
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: isDark ? Palette.darkMuted : Palette.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => CycleSetupDialog.show(context),
                    icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                    label: Text(ref.tr('set_cycle_details')),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // If activeTab == Insights: Display AI Cycle Intelligence & Anomaly Detection
        if (_activeTab == 'Insights') ...[
          SoftCard(
            color: isDark ? Palette.darkCard : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Palette.plum,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Cycle Rhythm Intelligence',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Palette.darkText : Palette.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Palette.darkSurface
                        : Palette.lilac.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF10B981),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cycle Regularity: Healthy (${cycle.cycleLength} days baseline)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Palette.darkText : Palette.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '• Next expected period: in ${cycle.nextPeriodInDays} days.\n'
                  '• Ovulation window: approximately Day ${(cycle.cycleLength / 2).round() - 2} to Day ${(cycle.cycleLength / 2).round() + 2}.\n'
                  '• Hormonal note: Estrogen and energy peak around ovulation.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? Palette.darkMuted : Palette.ink,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16,
                    ),
                    label: const Text('Ask Aisha AI about this phase'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const AiCompanionPage(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Conflicts resolution banner if any
        state.when(
          data: (s) {
            if (s.conflicts == 0) return const SizedBox.shrink();
            return Column(
              children: [
                SoftCard(
                  color: Palette.blush,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sync_problem, color: Palette.plum),
                          const SizedBox(width: 8),
                          Text(
                            'Sync conflicts (${s.conflicts})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Palette.plum,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This entry was modified on another device. Choose which version you would like to keep.',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      ...s.conflictList.map((c) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? Palette.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entry date: ${c.localPayload['date'] ?? 'Unknown'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Device draft: ${c.localPayload['mood']} · "${c.localPayload['note'] ?? ''}"',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (c.serverPayload != null)
                                Text(
                                  'Server version: ${c.serverPayload!['mood']} · "${c.serverPayload!['note'] ?? ''}"',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Palette.muted,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  FilledButton.tonal(
                                    onPressed: () => ref
                                        .read(journalProvider.notifier)
                                        .resolveConflict(
                                          c.entryId,
                                          keepLocal: true,
                                        ),
                                    child: const Text('Keep Device'),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () => ref
                                        .read(journalProvider.notifier)
                                        .resolveConflict(
                                          c.entryId,
                                          keepLocal: false,
                                        ),
                                    child: const Text('Accept Server'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),

        // Main check-in card
        SoftCard(
          color: isDark ? Palette.darkCard : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today’s Check-in',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 15),

              // Mood
              Text(
                ref.tr('mood_label'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: ['Great', 'Good', 'Okay', 'Low', 'Difficult'].map((
                  m,
                ) {
                  final isSelected = mood == m;
                  return ChoiceChip(
                    label: Text(m),
                    selected: isSelected,
                    selectedColor: Palette.plum,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Palette.darkText : Palette.ink),
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    backgroundColor: isDark
                        ? Palette.darkSurface
                        : Colors.white,
                    onSelected: (_) => setState(() => mood = m),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Sleep Duration
              Text(
                ref.tr('sleep_label'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: ['< 6h', '6h – 7h', '7h 20m', '8h – 9h', '> 9h'].map((
                  sl,
                ) {
                  final isSelected = sleepDuration == sl;
                  return ChoiceChip(
                    label: Text(sl),
                    selected: isSelected,
                    selectedColor: Palette.plum,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Palette.darkText : Palette.ink),
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    backgroundColor: isDark
                        ? Palette.darkSurface
                        : Colors.white,
                    onSelected: (_) => setState(() => sleepDuration = sl),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Flow section
              Text(
                ref.tr('flow_label'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Skip if not menstruating, or during pregnancy & menopause.',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Palette.darkMuted : Palette.muted,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    [
                      ('none', ref.tr('flow_none')),
                      ('spotting', ref.tr('flow_spotting')),
                      ('light', ref.tr('flow_light')),
                      ('medium', ref.tr('flow_medium')),
                      ('heavy', ref.tr('flow_heavy')),
                    ].map((f) {
                      final isSelected = flow == f.$1;
                      return ChoiceChip(
                        label: Text(f.$2),
                        selected: isSelected,
                        selectedColor: Palette.plum,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Palette.darkText : Palette.ink),
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        backgroundColor: isDark
                            ? Palette.darkSurface
                            : Colors.white,
                        onSelected: (_) => setState(() => flow = f.$1),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Energy level
              Text(
                ref.tr('energy_label'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    [
                      ('high', 'High'),
                      ('moderate', 'Moderate'),
                      ('low', 'Low'),
                      ('exhausted', 'Exhausted'),
                    ].map((e) {
                      final isSelected = energy == e.$1;
                      return ChoiceChip(
                        label: Text(e.$2),
                        selected: isSelected,
                        selectedColor: Palette.plum,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Palette.darkText : Palette.ink),
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        backgroundColor: isDark
                            ? Palette.darkSurface
                            : Colors.white,
                        onSelected: (_) => setState(() => energy = e.$1),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Symptoms
              Text(
                ref.tr('symptoms_label'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    [
                      ('Cramps', ref.tr('symptom_cramps')),
                      ('Headache', ref.tr('symptom_headache')),
                      ('Tender breasts', ref.tr('symptom_tender_breasts')),
                      ('Bloating', ref.tr('symptom_bloating')),
                      ('Fatigue', ref.tr('symptom_fatigue')),
                      ('Acne', ref.tr('symptom_acne')),
                      ('Backache', ref.tr('symptom_backache')),
                    ].map((s) {
                      final isSelected = selectedSymptoms.contains(s.$1);
                      return FilterChip(
                        label: Text(s.$2),
                        selected: isSelected,
                        selectedColor: Palette.blush,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Palette.plum
                              : (isDark ? Palette.darkText : Palette.ink),
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        backgroundColor: isDark
                            ? Palette.darkSurface
                            : Colors.white,
                        onSelected: (_) => _toggleSymptom(s.$1),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Notes
              TextField(
                controller: note,
                maxLength: 2000,
                maxLines: 3,
                style: TextStyle(
                  color: isDark ? Palette.darkText : Palette.ink,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  labelText: ref.tr('note_label'),
                  hintText: 'What’s on your mind today?',
                ),
              ),
              const SizedBox(height: 15),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: busy ? null : save,
                  child: Text(busy ? 'Saving…' : ref.tr('save_checkin')),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 13,
                    color: Palette.muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Saved privately on this device. Sync is optional.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Palette.darkMuted : Palette.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        Text(
          'Your recent moments',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(color: isDark ? Palette.darkText : Palette.ink),
        ),
        const SizedBox(height: 15),
        state.when(
          data: (s) => Column(
            children: [
              if (s.entries.isEmpty)
                SoftCard(
                  color: isDark ? Palette.darkSurface : const Color(0xFFF6F2EC),
                  child: const Text('Your story starts with a small check-in.'),
                ),
              ...s.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SoftCard(
                    color: isDark ? Palette.darkCard : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              e.mood,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Palette.plum,
                              ),
                            ),
                            if (e.flow != 'none') ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Palette.blush,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${e.flow.substring(0, 1).toUpperCase()}${e.flow.substring(1)} flow',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Palette.plum,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            Text(
                              e.date,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Palette.darkMuted
                                    : Palette.muted,
                              ),
                            ),
                          ],
                        ),
                        if (e.symptoms.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: e.symptoms
                                .map(
                                  (sym) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Palette.lilac,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      sym,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Palette.ink,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                        if (e.note.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            e.note,
                            style: TextStyle(
                              color: isDark ? Palette.darkText : Palette.ink,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          e.version == 0
                              ? 'Saved on device'
                              : 'Synced · v${e.version}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Palette.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          error: (e, _) => const Text(
            'Your private journal could not be opened. No data was overwritten.',
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  String _getPhaseDescription(String phase) {
    return switch (phase) {
      'Menstrual Phase' => ref.tr('menstrual_desc'),
      'Ovulation Window' => ref.tr('ovulation_desc'),
      'Luteal Phase' => ref.tr('luteal_desc'),
      _ => ref.tr('follicular_desc'),
    };
  }
}
