import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';

class Track extends ConsumerStatefulWidget {
  const Track({super.key});
  @override
  ConsumerState<Track> createState() => _TrackState();
}

class _TrackState extends ConsumerState<Track> {
  String mood = 'Okay';
  final note = TextEditingController();
  bool busy = false;
  String? error;
  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await ref.read(journalProvider.notifier).add(mood, note.text.trim());
      note.clear();
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
              if (s.conflicts > 0)
                Text(
                  '${s.conflicts} sync conflicts need resolution. Both versions are preserved. Resolution UI is planned; do not erase this journal.',
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
                            const Spacer(),
                            Text(e.date, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
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
