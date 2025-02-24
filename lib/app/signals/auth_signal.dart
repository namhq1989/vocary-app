import 'package:signals/signals_flutter.dart';

class AuthSignals {
  static final isSigningIn = signal<bool>(false);
  static final isSigningOut = signal<bool>(false);
  static final isCheckingAuth = signal<bool>(true);
}
