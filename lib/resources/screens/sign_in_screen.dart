import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocary/router/routes.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(AppRoutes.homeUrl()),
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}
