import 'package:flutter/material.dart';
import 'package:yanmata/core/theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.onGetStarted, required this.onSignIn});
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Palette.lilac,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.spa_outlined,
                  size: 52,
                  color: Palette.plum,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'YanMata',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Palette.plum,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Healthy Women. Brighter Futures.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Palette.plum,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Cervical health. Women’s wellness.\nStronger communities in Jos & beyond.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Palette.slate,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: onGetStarted,
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onSignIn,
                child: const Text('I already have an account'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ages 9 through later life · Zero health data sold',
                style: TextStyle(fontSize: 11, color: Palette.slate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
