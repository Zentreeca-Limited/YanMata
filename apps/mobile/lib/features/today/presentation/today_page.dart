import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';

class Today extends ConsumerWidget {
  const Today({super.key, required this.onTrack, required this.onLearn});
  final VoidCallback onTrack, onLearn;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider).value;
    return PageFrame(
      children: [
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
        const SizedBox(height: 35),
        const Eyebrow('A little care, every day'),
        const SizedBox(height: 12),
        Text(
          'A moment,\njust for you.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Growing. Changing. Always you.\nThere’s room for every kind of day here.',
        ),
        const SizedBox(height: 28),
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: Palette.plum),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'YOUR DAILY CHECK-IN',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1,
                        color: Palette.plum,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                'How are you, really?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              const Text(
                'You don’t have to find the perfect words.\nStart with how you feel.',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onTrack,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Check in with yourself',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 14),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Text(
              'Your space',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            const Icon(
              Icons.auto_awesome_outlined,
              color: Palette.plum,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 15),
        SoftCard(
          color: Palette.blush,
          child: Row(
            children: [
              const Icon(Icons.favorite_outline, color: Palette.plum, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Small moments matter.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Palette.ink,
                      ),
                    ),
                    Text(
                      '${journal?.entries.length ?? 0} moments in your journal',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          leading: const Icon(Icons.menu_book_outlined, color: Palette.teal),
          title: const Text('A little more understood.'),
          subtitle: const Text('Explore the learning room'),
          trailing: const Icon(Icons.arrow_forward, size: 18),
          onTap: onLearn,
        ),
        const SizedBox(height: 12),
        const Text(
          'Development preview · Use synthetic data only.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Palette.muted),
        ),
      ],
    );
  }
}
