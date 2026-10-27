import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';

import '../../journal/application/journal_controller.dart';
import '../../specialists/application/care_providers.dart';
import '../application/staff_providers.dart';
import '../data/staff_repository.dart';

class StaffPortalPage extends ConsumerStatefulWidget {
  const StaffPortalPage({super.key});

  @override
  ConsumerState<StaffPortalPage> createState() => _StaffPortalPageState();
}

class _StaffPortalPageState extends ConsumerState<StaffPortalPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showNewArticleSheet(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final titleCtrl = TextEditingController();
    final summaryCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final sourceCtrl = TextEditingController(text: 'https://www.who.int');
    String selectedTopic = 'Body literacy';
    String selectedStage = 'Puberty';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Draft educational article',
                      style: Theme.of(ctx).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'YanMata editorial protocol: All articles must carry clinical sources and undergo verified practitioner review.',
                  style: TextStyle(fontSize: 12, color: Palette.slate),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Article title',
                    hintText: 'e.g. Understanding cycle changes',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedTopic,
                        decoration: const InputDecoration(labelText: 'Topic'),
                        items: const [
                          DropdownMenuItem(
                              value: 'Body literacy',
                              child: Text('Body literacy')),
                          DropdownMenuItem(
                              value: 'Menstrual wellbeing',
                              child: Text('Menstrual wellbeing')),
                          DropdownMenuItem(
                              value: 'Emotional wellbeing',
                              child: Text('Emotional wellbeing')),
                          DropdownMenuItem(
                              value: 'Healthy ageing',
                              child: Text('Healthy ageing')),
                        ],
                        onChanged: (v) =>
                            setModalState(() => selectedTopic = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedStage,
                        decoration:
                            const InputDecoration(labelText: 'Life stage'),
                        items: const [
                          DropdownMenuItem(
                              value: 'Puberty', child: Text('Puberty (9–14)')),
                          DropdownMenuItem(
                              value: 'Adolescence',
                              child: Text('Adolescence (15–19)')),
                          DropdownMenuItem(
                              value: 'Adulthood',
                              child: Text('Adulthood (20–44)')),
                          DropdownMenuItem(
                              value: 'Menopause',
                              child: Text('Menopause (45–54)')),
                          DropdownMenuItem(
                              value: 'Later life',
                              child: Text('Later life (55+)')),
                        ],
                        onChanged: (v) =>
                            setModalState(() => selectedStage = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: summaryCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Summary / Preview note',
                    hintText: 'A brief summary of what readers will learn.',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Article body text',
                    hintText: 'Educational narrative...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: sourceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Traceable clinical source URL',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (titleCtrl.text.trim().isEmpty ||
                          summaryCtrl.text.trim().isEmpty ||
                          bodyCtrl.text.trim().isEmpty) {
                        return;
                      }
                      Navigator.pop(ctx);
                      setState(() => _busy = true);
                      try {
                        final journal = ref.read(journalProvider).value;
                        if (journal?.token == null) return;
                        final repo = ref.read(staffRepositoryProvider);
                        await repo.createContent(
                          token: journal!.token!,
                          title: titleCtrl.text.trim(),
                          topic: selectedTopic,
                          stage: selectedStage,
                          summary: summaryCtrl.text.trim(),
                          body: bodyCtrl.text.trim(),
                          sourceUrl: sourceCtrl.text.trim(),
                        );
                        ref.invalidate(staffContentProvider);
                        if (mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Draft created successfully.'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          messenger.showSnackBar(
                            SnackBar(content: Text('Draft error: $e')),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _busy = false);
                      }
                    },
                    child: const Text('Save draft article'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTransition(
    StaffContentItem item,
    String action, {
    String? notes,
  }) async {
    setState(() => _busy = true);
    try {
      final journal = ref.read(journalProvider).value;
      if (journal?.token == null) return;
      final repo = ref.read(staffRepositoryProvider);
      await repo.transitionContent(
        token: journal!.token!,
        id: item.id,
        action: action,
        notes: notes,
      );
      ref.invalidate(staffContentProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Article transitioned to $action.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showAssignSpecialistDialog(StaffCareRequestItem req) {
    final specialistsAsync = ref.read(specialistsProvider);
    final specialists = specialistsAsync.value ?? [];

    showDialog<void>(
      context: context,
      builder: (dlgContext) => AlertDialog(
        title: const Text('Assign Jos Specialist'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Member inquiry: "${req.summary}"',
                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select verified clinician to oversee this inquiry:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (specialists.isEmpty)
                const Text('No verified specialists available.')
              else
                ...specialists.map(
                  (spec) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(spec.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${spec.title} · ${spec.verificationSource}',
                        style: const TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () async {
                      Navigator.pop(dlgContext);
                      setState(() => _busy = true);
                      try {
                        final journal = ref.read(journalProvider).value;
                        if (journal?.token == null) return;
                        final repo = ref.read(staffRepositoryProvider);
                        await repo.assignSpecialist(
                          token: journal!.token!,
                          requestId: req.id,
                          specialistId: spec.id,
                        );
                        ref.invalidate(staffCareRequestsProvider);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Assigned to ${spec.name}')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Assignment error: $e')),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _busy = false);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journal = ref.watch(journalProvider).value;
    final contentAsync = ref.watch(staffContentProvider);
    final requestsAsync = ref.watch(staffCareRequestsProvider);

    return Scaffold(
      backgroundColor: Palette.cream,
      appBar: AppBar(
        title: const Text('Staff Editorial Studio'),
        backgroundColor: Palette.cream,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Palette.plum,
          indicatorColor: Palette.plum,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_outlined), text: 'Content Pipeline'),
            Tab(icon: Icon(Icons.medical_services_outlined), text: 'Care Inquiries'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Content Pipeline Tab
          contentAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Error loading studio content: $err'),
              ),
            ),
            data: (articles) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Educational Library',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Role: ${journal?.userRole ?? 'staff'} · Verified Jos publishing pipeline',
                          style: const TextStyle(fontSize: 12, color: Palette.slate),
                        ),
                      ],
                    ),
                    FilledButton.icon(
                      onPressed: _busy ? null : () => _showNewArticleSheet(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('New draft'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (articles.isEmpty)
                  const SoftCard(
                    child: Text('No articles found in the editorial pipeline.'),
                  )
                else
                  ...articles.map(
                    (art) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SoftCard(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _StatusBadge(status: art.status),
                                const SizedBox(width: 8),
                                Text(
                                  art.stage,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Palette.slate,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  art.topic,
                                  style: const TextStyle(
                                      fontSize: 11, color: Palette.slate),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              art.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.plum,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              art.summary,
                              style: const TextStyle(fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'By ${art.authorName ?? 'Staff Author'}',
                                  style: const TextStyle(
                                      fontSize: 11, color: Palette.slate),
                                ),
                                _buildActionButtons(art),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 2. Care Inquiries Tab
          requestsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Error loading care requests: $err'),
              ),
            ),
            data: (requests) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Support & Care Requests',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Triage and assign inquiries to Jos verified medical doctors and nurse specialists.',
                  style: TextStyle(fontSize: 12, color: Palette.slate),
                ),
                const SizedBox(height: 16),
                if (requests.isEmpty)
                  const SoftCard(
                    child: Text('No care requests currently in triage.'),
                  )
                else
                  ...requests.map(
                    (req) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SoftCard(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _StatusBadge(status: req.status),
                                const SizedBox(width: 8),
                                Text(
                                  req.stage,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Palette.slate,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                if (req.shareJournalConsent)
                                  const Row(
                                    children: [
                                      Icon(Icons.lock_open,
                                          size: 13, color: Palette.plum),
                                      SizedBox(width: 4),
                                      Text('Journal shared',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Palette.plum)),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              req.summary,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  req.specialistName != null
                                      ? 'Assigned: ${req.specialistName}'
                                      : 'Unassigned',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: req.specialistName != null
                                        ? Colors.green.shade800
                                        : Colors.amber.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (req.status == 'pending')
                                  FilledButton.tonal(
                                    onPressed: _busy
                                        ? null
                                        : () => _showAssignSpecialistDialog(req),
                                    child: const Text('Assign specialist'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(StaffContentItem art) {
    if (art.status == 'draft') {
      return OutlinedButton(
        onPressed: _busy
            ? null
            : () => _handleTransition(art, 'submit_for_review'),
        child: const Text('Submit for review'),
      );
    } else if (art.status == 'in_review') {
      return OutlinedButton(
        onPressed: _busy ? null : () => _handleTransition(art, 'approve'),
        child: const Text('Approve article'),
      );
    } else if (art.status == 'approved') {
      return FilledButton(
        onPressed: _busy ? null : () => _handleTransition(art, 'publish'),
        child: const Text('Publish'),
      );
    } else {
      return const Text(
        'Published live',
        style: TextStyle(
            fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
      );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'draft':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        label = 'DRAFT';
        break;
      case 'in_review':
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1E40AF);
        label = 'IN REVIEW';
        break;
      case 'approved':
        bg = const Color(0xFFEDE9FE);
        fg = const Color(0xFF5B21B6);
        label = 'APPROVED';
        break;
      case 'published':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        label = 'PUBLISHED';
        break;
      case 'assigned':
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF3730A3);
        label = 'ASSIGNED';
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF374151);
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
