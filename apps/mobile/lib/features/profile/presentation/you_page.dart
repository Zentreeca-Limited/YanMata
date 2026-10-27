import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/domain/journal_repository.dart';

class You extends ConsumerStatefulWidget {
  const You({super.key});
  @override
  ConsumerState<You> createState() => _YouState();
}

class _YouState extends ConsumerState<You> {
  final email = TextEditingController(), password = TextEditingController();
  bool consent = false, busy = false;
  String? message;
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

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(journalProvider).value ?? const JournalState();
    final controller = ref.read(journalProvider.notifier);
    return PageFrame(
      children: [
        const Eyebrow('Your wellbeing. Your boundaries.'),
        const SizedBox(height: 12),
        Text(
          'Your space,\nyour choice.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        const Text(
          'You can keep your journal on this device. Connecting a demo account is optional.',
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 25),
        const SoftCard(
          color: Palette.blush,
          child: Text(
            'Foundation preview: account export/deletion, app PIN, consent history, automated background sync and notification settings are not yet available. Use synthetic data only.',
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
