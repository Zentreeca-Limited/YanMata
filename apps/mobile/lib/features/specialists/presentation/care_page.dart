import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';

import '../../journal/application/journal_controller.dart';
import '../application/care_providers.dart';
import '../domain/specialist.dart';
import 'care_chat_page.dart';

class Care extends ConsumerWidget {
  const Care({super.key});

  void _openInquirySheet(
    BuildContext context,
    WidgetRef ref, {
    Specialist? specialist,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Palette.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _InquirySheet(initialSpecialist: specialist),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider).value;
    final isSignedIn = journal?.signedIn ?? false;
    final specialistsAsync = ref.watch(specialistsProvider);
    final myRequestsAsync = ref.watch(myCareRequestsProvider);

    return PageFrame(
      children: [
        const Eyebrow('A human connection'),
        const SizedBox(height: 12),
        Text(
          'Room to ask.\nSomeone to listen.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Speak with verified healthcare professionals for non-emergency guidance. No facility search or hospital booking required.',
        ),
        const SizedBox(height: 22),

        // Action card
        SoftCard(
          color: Palette.lilac,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.forum_outlined, size: 32, color: Palette.plum),
                  Spacer(),
                  Text(
                    'JOS PILOT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Palette.plum,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Confidential guidance',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Ask questions about your body, periods, emotions or transitions. Verified Nigerian clinicians respond within 24–48 hours.',
              ),
              const SizedBox(height: 18),
              if (isSignedIn)
                FilledButton.icon(
                  onPressed: () => _openInquirySheet(context, ref),
                  icon: const Icon(Icons.edit_note, color: Colors.white),
                  label: const Text('Ask a question'),
                )
              else
                const Text(
                  'Connect your demo account in the "You" tab to start a conversation.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Palette.plum,
                  ),
                ),
            ],
          ),
        ),

        // Active Conversations section
        if (isSignedIn) ...[
          const SizedBox(height: 32),
          Text(
            'Your conversations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 14),
          myRequestsAsync.when(
            data: (requests) {
              if (requests.isEmpty) {
                return const SoftCard(
                  color: Colors.white,
                  child: Text(
                    'No active questions yet. Tap "Ask a question" above to connect with a verified specialist.',
                  ),
                );
              }
              return Column(
                children: requests.map((req) {
                  final convId = req.conversationId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SoftCard(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: req.status == 'assigned'
                                      ? Palette.lilac
                                      : Palette.blush,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  req.status.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Palette.plum,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                req.stage,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Palette.muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            req.topic,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Palette.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            req.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          if (req.specialist != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.medical_services_outlined,
                                  size: 16,
                                  color: Palette.teal,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${req.specialist!.name} (${req.specialist!.credentials})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Palette.teal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (convId != null) ...[
                            const SizedBox(height: 14),
                            FilledButton.tonal(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CareChatPage(conversationId: convId),
                                  ),
                                );
                              },
                              child: const Text('Open Conversation'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(
              'Could not load conversations: $e',
              style: const TextStyle(fontSize: 12, color: Palette.muted),
            ),
          ),
        ],

        // Verified specialists directory
        const SizedBox(height: 32),
        Text(
          'Verified Specialists',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        const Text(
          'Independent clinical reviewers and practitioners registered with MDCN and NMCN.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 16),
        specialistsAsync.when(
          data: (specialists) {
            if (specialists.isEmpty) {
              return const SoftCard(
                color: Colors.white,
                child: Text('No specialists are listed at this time.'),
              );
            }
            return Column(
              children: specialists.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: SoftCard(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Palette.lilac,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Palette.plum,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Palette.ink,
                                    ),
                                  ),
                                  Text(
                                    s.title,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Palette.plum,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s.credentials,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Palette.teal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.bio,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Palette.cream,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE9E2E9)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified,
                                size: 14,
                                color: Palette.teal,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  s.verificationSource,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Palette.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSignedIn) ...[
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _openInquirySheet(context, ref, specialist: s),
                            icon: const Icon(Icons.send, size: 16),
                            label: Text('Ask ${s.name.split(' ').first}'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Could not load specialists: $e'),
        ),

        const SizedBox(height: 25),
        const Text(
          'YanMata is not an emergency service. Response times are 24–48 hours by verified clinical volunteers.',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}

class _InquirySheet extends ConsumerStatefulWidget {
  const _InquirySheet({this.initialSpecialist});
  final Specialist? initialSpecialist;

  @override
  ConsumerState<_InquirySheet> createState() => _InquirySheetState();
}

class _InquirySheetState extends ConsumerState<_InquirySheet> {
  final _summaryController = TextEditingController();
  String _topic = 'Menstrual wellbeing';
  String _stage = 'Puberty';
  bool _shareJournal = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _summaryController.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Please enter your question.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final req = await ref
          .read(myCareRequestsProvider.notifier)
          .createRequest(
            topic: _topic,
            stage: _stage,
            summary: text,
            shareJournalConsent: _shareJournal,
            specialistId: widget.initialSpecialist?.id,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your question has been sent to the specialist.'),
          ),
        );
        if (req.conversationId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CareChatPage(conversationId: req.conversationId!),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.initialSpecialist != null
                        ? 'Ask ${widget.initialSpecialist!.name}'
                        : 'Ask a specialist',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Topic',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children:
                  [
                        'Menstrual wellbeing',
                        'Body literacy',
                        'Emotional wellbeing',
                        'Transitions',
                      ]
                      .map(
                        (t) => ChoiceChip(
                          label: Text(t),
                          selected: _topic == t,
                          onSelected: (_) => setState(() => _topic = t),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Life chapter',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children:
                  [
                        'Puberty',
                        'Adolescence',
                        'Adulthood',
                        'Menopause',
                        'Later life',
                      ]
                      .map(
                        (s) => ChoiceChip(
                          label: Text(s),
                          selected: _stage == s,
                          onSelected: (_) => setState(() => _stage = s),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _summaryController,
              maxLines: 4,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'Your question',
                hintText: 'Describe what is on your mind in your own words...',
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _shareJournal,
              onChanged: (v) => setState(() => _shareJournal = v ?? false),
              title: const Text(
                'Allow assigned clinician to view recent health log entries to provide better guidance',
                style: TextStyle(fontSize: 12),
              ),
            ),
            if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _busy ? null : _submit,
                child: Text(_busy ? 'Submitting...' : 'Send to Specialist'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
