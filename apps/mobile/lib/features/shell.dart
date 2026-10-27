import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/features/journal/presentation/track_page.dart';
import 'package:yanmata/features/learning/presentation/learn_page.dart';
import 'package:yanmata/features/profile/presentation/you_page.dart';
import 'package:yanmata/features/services/presentation/services_page.dart';
import 'package:yanmata/features/shop/presentation/shop_page.dart';
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
                onServices: () => setState(() => tab = 2),
                onProducts: () => setState(() => tab = 4),
                onProfile: () => setState(() => tab = 5),
                onLearn: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const Scaffold(body: SafeArea(child: Learn()))),
                ),
              ),
              const Track(),
              const ServicesPage(),
              const Care(),
              const ShopPage(),
              You(
                onNavigateTrack: () => setState(() => tab = 1),
                onNavigateServices: () => setState(() => tab = 2),
                onNavigateProducts: () => setState(() => tab = 4),
              ),
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
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Track',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_hospital_outlined),
              selectedIcon: Icon(Icons.local_hospital),
              label: 'Services',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Care',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'Products',
            ),
            NavigationDestination(
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
