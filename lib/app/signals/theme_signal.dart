import 'package:flutter/material.dart';
import 'package:signals/signals_core.dart';

const lightMode = 'light';
const darkMode = 'dark';

final themeMode = computed(() {
  if (ThemeSignals.themeId.value == lightMode) {
    return ThemeMode.light;
  } else {
    return ThemeMode.dark;
  }
});

class ThemeSignals {
  static bool isDark() {
    return ThemeSignals.themeId.value == darkMode;
  }

  static final themeId = signal<String>(lightMode);
}
