import 'package:vocary/app/signals/theme_signal.dart';

class ThemeController {
  void onSwitchTheme() {
    ThemeSignals.themeId.value = ThemeSignals.isDark() ? lightMode : darkMode;
  }
}
