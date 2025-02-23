import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/signals/theme_signal.dart';
import 'package:vocary/router/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final mode = themeMode.watch(context);

    // update status bar
    _updateStatusBar(mode);

    return ShadApp.router(
      routerConfig: AppRouter.router,
      theme: ShadThemeData(
        textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.poppins),
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(),
        primaryButtonTheme: ShadButtonTheme(
          decoration: ShadDecoration().copyWith(
            border: ShadBorder(radius: BorderRadius.circular(12)),
          ),
        ),
      ),
      darkTheme: ShadThemeData(
        textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.poppins),
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
        primaryButtonTheme: ShadButtonTheme(
          decoration: ShadDecoration().copyWith(
            border: ShadBorder(radius: BorderRadius.circular(12)),
          ),
        ),
      ),
      themeMode: mode,
      title: 'Vocary',
    );
  }

  void _updateStatusBar(ThemeMode mode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness:
            mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            mode == ThemeMode.dark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
