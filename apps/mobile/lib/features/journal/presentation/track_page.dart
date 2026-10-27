import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';

import '../application/journal_controller.dart';

class Track extends ConsumerStatefulWidget {
  const Track({super.key});
  @override
  ConsumerState<Track> createState() => _TrackState();
}

class _TrackState extends ConsumerState<Track> {
  String mood = 'Okay';
  String flow = 'none';
  String energy = 'moderate';
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
      await ref.read(journalProvider.notifier).add(
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved privately on this device.')),
        );
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalProvider);

    return PageFrame(
      children: [
        const Eyebrow('Your personal journal'),
        const SizedBox(height: 12),
        Text(
          'Every feeling\nhas a place.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text('Take a breath. Notice how you are today.'),
        const SizedBox(height: 25),

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
                            color: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How are you feeling?',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: ['Great', 'Good', 'Okay', 'Low', 'Difficult']
                    .map(
                      (m) => ChoiceChip(
                        label: Text(m),
                        selected: mood == m,
                        onSelected: (_) => setState(() => mood = m),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Flow section
              const Text(
                'Cycle flow (optional)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Skip if not menstruating, or during pregnancy, menopause & later life.',
                style: TextStyle(fontSize: 12, color: Palette.muted),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ('none', 'None'),
                  ('spotting', 'Spotting'),
                  ('light', 'Light'),
                  ('medium', 'Medium'),
                  ('heavy', 'Heavy'),
                ].map(
                  (f) => ChoiceChip(
                    label: Text(f.$2),
                    selected: flow == f.$1,
                    onSelected: (_) => setState(() => flow = f.$1),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 20),

              // Energy level
              const Text(
                'Energy level',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ('high', 'High'),
                  ('moderate', 'Moderate'),
                  ('low', 'Low'),
                  ('exhausted', 'Exhausted'),
                ].map(
                  (e) => ChoiceChip(
                    label: Text(e.$2),
                    selected: energy == e.$1,
                    onSelected: (_) => setState(() => energy = e.$1),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 20),

              // Symptoms
              const Text(
                'Body & emotional signals',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  'Cramps',
                  'Headache',
                  'Tender breasts',
                  'Bloating',
                  'Fatigue',
                  'Hot flashes',
                  'Mood swings',
                  'Insomnia',
                ].map(
                  (s) => FilterChip(
                    label: Text(s),
                    selected: selectedSymptoms.contains(s),
                    onSelected: (_) => _toggleSymptom(s),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 20),

              // Notes
              TextField(
                controller: note,
                maxLength: 2000,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'A few words, if you like',
                  hintText: 'What’s on your mind?',
                ),
              ),
              const SizedBox(height: 15),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              FilledButton(
                onPressed: busy ? null : save,
                child: Text(busy ? 'Saving…' : 'Save my check-in'),
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Icon(Icons.lock_outline, size: 13, color: Palette.muted),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Saved on this device. Sync is optional.',
                      style: TextStyle(fontSize: 12),
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
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 15),
        state.when(
          data: (s) => Column(
            children: [
              if (s.entries.isEmpty)
                const SoftCard(
                  color: Color(0xFFF6F2EC),
                  child: Text('Your story starts with a small check-in.'),
                ),
              ...s.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SoftCard(
                    color: Colors.white,
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
                            Text(e.date, style: const TextStyle(fontSize: 12)),
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
                          Text(e.note),
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
}
