import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 12,
      letterSpacing: 1.6,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.color = Palette.lilac});
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Material(color: Colors.transparent, child: child),
  );
}
