import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';

class Care extends StatelessWidget {
  const Care({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      const Eyebrow('A human connection'),
      const SizedBox(height: 12),
      Text(
        'Room to ask.\nSomeone to listen.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 22),
      const SoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.forum_outlined, size: 48, color: Palette.plum),
            SizedBox(height: 24),
            Text(
              'Specialist conversations',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Palette.ink,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'We’re preparing private, in-platform conversations with verified professionals. This service is not available in the foundation preview.',
            ),
            SizedBox(height: 20),
            Text(
              'No facility listings or hospital bookings.',
              style: TextStyle(fontSize: 12, color: Palette.plum),
            ),
          ],
        ),
      ),
      const SizedBox(height: 25),
      const Text(
        'YanMata is not an emergency service. The clinical team will define and verify locally appropriate urgent-help information before the pilot.',
        style: TextStyle(fontSize: 13),
      ),
    ],
  );
}
