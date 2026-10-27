import 'package:yanmata/features/today/presentation/today_page.dart';
import 'package:yanmata/features/journal/presentation/track_page.dart';
import 'package:yanmata/features/learning/presentation/learn_page.dart';
import 'package:yanmata/features/specialists/presentation/care_page.dart';
import 'package:yanmata/features/profile/presentation/you_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';

class YanMataShell extends ConsumerStatefulWidget {
  const YanMataShell({super.key});
  @override
  ConsumerState<YanMataShell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<YanMataShell>
    with WidgetsBindingObserver {
  int tab = 0;
  bool hidden = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() => hidden = state != AppLifecycleState.resumed);
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
                onLearn: () => setState(() => tab = 2),
              ),
              const Track(),
              const Learn(),
              const Care(),
              const You(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          backgroundColor: Palette.cream,
          indicatorColor: Palette.lilac,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Today',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Track',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              label: 'Learn',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Care',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'You',
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
