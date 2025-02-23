import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocary/router/routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(AppRoutes.signInUrl()),
          child: const Text('Get Started'),
        ),
      ),
    );
  }
}
