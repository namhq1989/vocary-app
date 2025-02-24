import 'package:flutter/material.dart';
import 'package:vocary/app/controllers/auth_controller.dart';
import 'package:vocary/router/router.dart';
import 'package:vocary/router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    if (await AuthController.isAuthenticated()) {
      AppRouter.router.replace(AppRoutes.homeUrl());
    } else {
      AppRouter.router.replace(AppRoutes.onboardingUrl());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
