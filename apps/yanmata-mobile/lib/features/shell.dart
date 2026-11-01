import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/localization/locale_provider.dart';
import 'package:yanmata/core/notifications.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/presentation/track_page.dart';
import 'package:yanmata/features/learning/presentation/learn_page.dart';
import 'package:yanmata/features/nearby/presentation/nearby_places_page.dart';
import 'package:yanmata/features/profile/presentation/you_page.dart';
import 'package:yanmata/features/services/presentation/services_page.dart';
import 'package:yanmata/features/specialists/application/care_providers.dart';
import 'package:yanmata/features/specialists/presentation/care_page.dart';
import 'package:yanmata/features/today/presentation/today_page.dart';

class YanMataShell extends ConsumerStatefulWidget {
  const YanMataShell({super.key});
  @override
  ConsumerState<YanMataShell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<YanMataShell>
    with WidgetsBindingObserver {
  int tab = 0;
  bool hidden = false;
  String? _lastPolledIso;
  final Set<String> _seenEventIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(_checkUnreadEvents);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkUnreadEvents() async {
    final journal = ref.read(journalProvider).value;
    final token = journal?.token;
    if (token == null) return;
    final events = await ref
        .read(deviceServiceProvider)
        .pollEvents(token: token, sinceIso: _lastPolledIso);
    if (!mounted || events.isEmpty) return;

    bool hasNew = false;
    for (final ev in events) {
      final id = ev['id']?.toString();
      if (id != null && _seenEventIds.add(id)) {
        hasNew = true;
      }
      final createdAt = ev['created_at']?.toString();
      if (createdAt != null) {
        _lastPolledIso = createdAt;
      }
    }

    if (hasNew && mounted) {
      ref.invalidate(myCareRequestsProvider);
      final prefs =
          ref.read(notificationPreferencesProvider).value ??
          const NotificationPreferences();
      if (prefs.careMessages && !prefs.isInQuietHours(TimeOfDay.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'A quiet moment: You have a new update in your Care space.',
            ),
            action: SnackBarAction(
              label: 'Open Care',
              onPressed: () {
                if (mounted) setState(() => tab = 3);
              },
            ),
          ),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    setState(() => hidden = !resumed);
    if (resumed) {
      _checkUnreadEvents();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: tab,
            children: [
              Today(
                onTrack: () => setState(() => tab = 1),
                onServices: () => setState(() => tab = 2),
                onNearby: () => setState(() => tab = 4),
                onProfile: () => setState(() => tab = 5),
                onLearn: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const Scaffold(body: SafeArea(child: Learn())),
                  ),
                ),
              ),
              const Track(),
              const ServicesPage(),
              const Care(),
              const NearbyPlacesPage(),
              You(
                onNavigateTrack: () => setState(() => tab = 1),
                onNavigateServices: () => setState(() => tab = 2),
                onNavigateNearby: () => setState(() => tab = 4),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Track',
            ),
            const NavigationDestination(
              icon: Icon(Icons.local_hospital_outlined),
              selectedIcon: Icon(Icons.local_hospital),
              label: 'Services',
            ),
            const NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Care',
            ),
            NavigationDestination(
              icon: const Icon(Icons.near_me_outlined),
              selectedIcon: const Icon(Icons.near_me),
              label: ref.tr('nav_nearby'),
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'More',
            ),
          ],
        ),
      ),
      if (hidden)
        const Positioned.fill(
          child: ColoredBox(
            color: Palette.cream,
            child: Center(
              child: Icon(Icons.spa_outlined, size: 64, color: Palette.plum),
            ),
          ),
        ),
    ],
  );
}
