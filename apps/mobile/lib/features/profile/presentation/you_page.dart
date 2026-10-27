import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/notifications.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/editorial/presentation/staff_portal_page.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/domain/journal_repository.dart';
import 'package:yanmata/features/risk/presentation/risk_overview_page.dart';

class You extends ConsumerStatefulWidget {
  const You({
    super.key,
    this.onNavigateServices,
    this.onNavigateProducts,
    this.onNavigateTrack,
  });

  final VoidCallback? onNavigateServices;
  final VoidCallback? onNavigateProducts;
  final VoidCallback? onNavigateTrack;

  @override
  ConsumerState<You> createState() => _YouState();
}

class _YouState extends ConsumerState<You> {
  final email = TextEditingController(), password = TextEditingController();
  bool consent = false, busy = false;
  String? message;

  String _selectedStage = 'Adolescence';
  final List<String> _selectedTopics = ['Body literacy', 'Menstrual wellbeing'];

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> act(Future<void> Function() action, String success) async {
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await action();
      if (mounted) setState(() => message = success);
    } catch (e) {
      if (mounted) setState(() => message = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _exportData(JournalState state) {
    final export = {
      'exported_at': DateTime.now().toIso8601String(),
      'member_name': state.userName ?? 'Aisha Yusuf',
      'life_stage': _selectedStage,
      'topics': _selectedTopics,
      'entries_count': state.entries.length,
      'entries': state.entries.map((e) => e.toJson()).toList(),
    };
    final jsonStr = const JsonEncoder.withIndent('  ').convert(export);

    showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Export My Journal'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your private journal is stored safely on this device. Below is a portable JSON copy of your recorded moments.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Palette.cream,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE9E2E9)),
                  ),
                  child: SelectableText(
                    jsonStr,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonStr));
              Navigator.pop(c);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied export data to clipboard.')),
              );
            },
            child: const Text('Copy to Clipboard'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(journalProvider).value ?? const JournalState();
    final controller = ref.read(journalProvider.notifier);
    final prefs = ref.watch(notificationPreferencesProvider).value ??
        const NotificationPreferences();

    return PageFrame(
      children: [
        // Member Header Card (Wireframe Screen 11)
        SoftCard(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Palette.lilac,
                  shape: BoxShape.circle,
                  border: Border.all(color: Palette.plum, width: 2),
                ),
                child: const Icon(Icons.person, color: Palette.plum, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.userName ?? 'Aisha Yusuf',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Palette.plum,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.signedIn
                          ? 'Connected (${s.userRole}) · Sync active'
                          : 'Member since 2025 · Private on device',
                      style: const TextStyle(fontSize: 12, color: Palette.slate),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Quick Navigation Menu from Screen 11
        SoftCard(
          color: Colors.white,
          child: Column(
            children: [
              _ProfileNavRow(
                icon: Icons.assignment_outlined,
                title: 'My Health Records',
                subtitle: 'Personalised risk scores & clinical indicators',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const RiskOverviewPage(),
                  ),
                ),
              ),
              const Divider(height: 1),
              _ProfileNavRow(
                icon: Icons.history,
                title: 'Cycle History',
                subtitle: 'View recent symptom entries and phase logs',
                onTap: widget.onNavigateTrack ?? () {},
              ),
              const Divider(height: 1),
              _ProfileNavRow(
                icon: Icons.star_border,
                title: 'Saved Services',
                subtitle: 'Bookmarked clinics and hospitals in Jos',
                onTap: widget.onNavigateServices ?? () {},
              ),
              const Divider(height: 1),
              _ProfileNavRow(
                icon: Icons.shopping_bag_outlined,
                title: 'Saved Products',
                subtitle: 'View products or check delivery orders',
                onTap: widget.onNavigateProducts ?? () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Life Chapter Selection
        SoftCard(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_stories_outlined, color: Palette.plum, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your life chapter',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Ages 9 through later life. We adapt learning without assuming reproductive or marital status.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ('Puberty', 'Puberty (9–14)'),
                  ('Adolescence', 'Adolescence (15–19)'),
                  ('Adulthood', 'Adulthood (20–44)'),
                  ('Menopause', 'Menopause (45–54)'),
                  ('Later life', 'Later life (55+)'),
                ].map(
                  (stage) => ChoiceChip(
                    label: Text(stage.$2),
                    selected: _selectedStage == stage.$1,
                    onSelected: (_) => setState(() => _selectedStage = stage.$1),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Topics of interest',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  'Body literacy',
                  'Menstrual wellbeing',
                  'Emotional wellbeing',
                  'Healthy ageing',
                  'Transitions',
                ].map(
                  (top) => FilterChip(
                    label: Text(top),
                    selected: _selectedTopics.contains(top),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedTopics.add(top);
                        } else {
                          _selectedTopics.remove(top);
                        }
                      });
                    },
                  ),
                ).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Staff Editorial Studio if staff
        if (s.isStaff) ...[
          SoftCard(
            color: const Color(0xFFF3E8FF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_user_outlined,
                        color: Palette.plum, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Staff Editorial Studio',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Signed in as ${s.userName ?? 'Staff'} (${s.userRole}). You can draft, review, and publish educational articles, or triage care inquiries.',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const StaffPortalPage(),
                    ),
                  ),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Open mobile editorial studio'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Reminders & Notifications Card
        SoftCard(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.notifications_active_outlined,
                      color: Palette.plum, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reminders & quiet hours',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Gentle, local check-in reminders with strict lock-screen privacy. No clinical labels appear outside the app.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 14),
              // Discreet Lock-Screen Preview
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Palette.cream,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9E2E9)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline, size: 14, color: Palette.slate),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Discreet lock-screen notice',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Palette.slate,
                            ),
                          ),
                        ),
                        Text(
                          '20:00',
                          style: TextStyle(fontSize: 11, color: Palette.slate),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'A quiet moment',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Palette.plum,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'How has your day felt so far?',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Daily reflection reminder',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text('Scheduled for ${prefs.checkInReminderTime} daily',
                    style: const TextStyle(fontSize: 12)),
                value: prefs.checkInReminderEnabled,
                onChanged: (val) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .toggleCheckInReminder(val),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Quiet hours',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text(
                    '${prefs.quietHoursStart} – ${prefs.quietHoursEnd} (no alerts sent)',
                    style: const TextStyle(fontSize: 12)),
                value: prefs.quietHoursEnabled,
                onChanged: (val) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .toggleQuietHours(val),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Care message notifications',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: const Text(
                    'Opaque alert when your assigned specialist replies',
                    style: TextStyle(fontSize: 12)),
                value: prefs.careMessages,
                onChanged: (val) => ref
                    .read(notificationPreferencesProvider.notifier)
                    .toggleCareMessages(val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Cloud sync card
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cloud_outlined, color: Palette.plum, size: 32),
              const SizedBox(height: 15),
              Text(
                s.signedIn
                    ? 'Cloud sync connected'
                    : 'Keep your moments together',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                '${s.pending} changes waiting to sync. ${s.conflicts} conflicts.',
              ),
              const SizedBox(height: 15),
              if (!s.signedIn) ...[
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Demo account email',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: password,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: consent,
                  onChanged: (v) => setState(() => consent = v ?? false),
                  title: const Text(
                    'I agree to sync this journal to my demo account.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                FilledButton(
                  onPressed: busy || !consent
                      ? null
                      : () => act(() async {
                          await controller.connect(
                            email.text.trim(),
                            password.text,
                          );
                          password.clear();
                        }, 'Connected. Tap Sync now to upload your journal.'),
                  child: const Text('Connect with consent'),
                ),
              ] else ...[
                FilledButton(
                  onPressed: busy
                      ? null
                      : () =>
                            act(controller.sync, 'Your journal is up to date.'),
                  child: Text(busy ? 'Working…' : 'Sync now'),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () => act(
                          controller.disconnect,
                          'Disconnected. Your local journal remains on this device.',
                        ),
                  child: const Text('Disconnect cloud account'),
                ),
              ],
            ],
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 15),
          Text(message!, style: const TextStyle(fontSize: 12)),
        ],
        const SizedBox(height: 20),

        // Export data button
        SoftCard(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data ownership & export',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Export all your local records anytime. You own your data completely.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () => _exportData(s),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Export journal records'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        const SoftCard(
          color: Palette.blush,
          child: Text(
            'Foundation preview: automated background sync, local notifications and biometric lock are in development. Use synthetic data only.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: busy || s.signedIn
              ? null
              : () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Erase this device journal?'),
                      content: const Text(
                        'This removes local entries and unsynced changes permanently. It does not delete records already synced to the server.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: const Text('Keep my journal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: const Text('Erase local journal'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await act(controller.erase, 'Local journal erased.');
                  }
                },
          child: const Text('Erase local journal'),
        ),
        const SizedBox(height: 12),
        const Text(
          'YanMata by Zentreeca · Ages 9 through later life\nJos, Plateau State · Development preview',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _ProfileNavRow extends StatelessWidget {
  const _ProfileNavRow({
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Palette.plum, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Palette.slate),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Palette.slate),
          ],
        ),
      ),
    );
  }
}
