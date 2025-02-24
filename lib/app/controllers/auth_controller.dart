import 'package:vocary/app/signals/auth_signal.dart';
import 'package:vocary/core/storage.dart';
import 'package:vocary/router/router.dart';
import 'package:vocary/router/routes.dart';

class AuthController {
  static const String _authTokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await Storage.save(_authTokenKey, token);
  }

  static Future<String?> getToken() async {
    return Storage.get(_authTokenKey);
  }

  static Future<void> clearToken() async {
    await Storage.remove(_authTokenKey);
  }

  static Future<bool> isAuthenticated() async {
    return (await getToken()) != null;
  }

  static checkAuthStatus() async {
    AuthSignals.isCheckingAuth.value = true;

    String? token = await getToken();

    if (token != null) {
      AppRouter.router.push(AppRoutes.homeUrl());
    }

    AuthSignals.isCheckingAuth.value = false;
  }

  static onTapSignIn() async {
    if (AuthSignals.isSigningIn.value) return;

    AuthSignals.isSigningIn.value = true;

    await Future.delayed(const Duration(seconds: 2));
    await saveToken("auth_token");

    AuthSignals.isSigningIn.value = false;

    AppRouter.router.replace(AppRoutes.homeUrl());
  }

  static onTapSignOut() async {
    if (AuthSignals.isSigningOut.value) return;

    AuthSignals.isSigningOut.value = true;

    await Future.delayed(const Duration(seconds: 2));
    await clearToken();

    AuthSignals.isSigningOut.value = false;

    AppRouter.router.replace(AppRoutes.onboardingUrl());
  }
}
