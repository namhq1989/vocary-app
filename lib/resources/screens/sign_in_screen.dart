import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/controllers/auth_controller.dart';
import 'package:vocary/app/signals/auth_signal.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sign-in-background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.15)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Vocary',
                      style: ShadTheme.of(
                        context,
                      ).textTheme.h2.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your daily companion for vocabulary mastery',
                      style: ShadTheme.of(
                        context,
                      ).textTheme.p.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80),
                    Watch((context) {
                      final isLoading = AuthSignals.isSigningIn.value;

                      return Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 1,
                        child: InkWell(
                          onTap: isLoading ? null : AuthController.onTapSignIn,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child:
                                        isLoading
                                            ? SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(
                                                      ShadTheme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                              ),
                                            )
                                            : SvgPicture.asset(
                                              'assets/images/google.svg',
                                              width: 24,
                                              height: 24,
                                              colorFilter: ColorFilter.mode(
                                                ShadTheme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    isLoading
                                        ? 'Signing in ...'
                                        : 'Continue with Google',
                                    style: ShadTheme.of(context).textTheme.p
                                        .copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        // TODO: Add terms and privacy policy
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 14),
                          children: [
                            const TextSpan(
                              text: 'By continuing, you agree to our ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Terms',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: ' and ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
