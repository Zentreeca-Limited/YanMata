import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/learning/application/learning_provider.dart';

class Learn extends ConsumerWidget {
  const Learn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(learningProvider);
    return PageFrame(
      children: [
        const Eyebrow('The learning room'),
        const SizedBox(height: 12),
        Text(
          'A little knowledge.\nA little confidence.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 14),
        const Text('Explore at your pace, through every chapter.'),
        const SizedBox(height: 20),
        const SoftCard(
          child: Text(
            'Educational information includes source and review details. It does not replace care from a qualified professional.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 20),
        content.when(
          data: (items) => Column(
            children: [
              if (items.isEmpty)
                const Text(
                  'No learning articles are available right now. Please check again later.',
                ),
              ...items.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArticlePage(article: a),
                      ),
                    ),
                    child: SoftCard(
                      color: Palette.blush,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Eyebrow(a['stage']),
                              const Spacer(),
                              const Icon(
                                Icons.auto_awesome_outlined,
                                color: Palette.plum,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            a['title'],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          Text(a['summary']),
                          const SizedBox(height: 18),
                          const Row(
                            children: [
                              Text(
                                'Explore article',
                                style: TextStyle(
                                  color: Palette.plum,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: Palette.plum,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          error: (e, _) => Column(
            children: [
              const Text(
                'We could not load the learning library. Check your connection and try again.',
              ),
              TextButton(
                onPressed: () => ref.invalidate(learningProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key, required this.article});
  final Map<String, dynamic> article;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('The learning room')),
    body: PageFrame(
      children: [
        Eyebrow(article['stage']),
        const SizedBox(height: 18),
        Text(
          article['title'],
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        const SoftCard(
          child: Text(
            'Educational information · Not a diagnosis or prescription. Review the source and reviewer details below.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 25),
        Text(article['body']),
        const SizedBox(height: 25),
        const Eyebrow('Background source'),
        const SizedBox(height: 10),
        SelectableText(
          article['source_url'],
          style: const TextStyle(fontSize: 12, color: Palette.plum),
        ),
      ],
    ),
  );
}
