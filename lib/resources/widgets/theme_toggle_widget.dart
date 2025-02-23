import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/controllers/theme_controller.dart';
import 'package:vocary/app/signals/theme_signal.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((_) {
      final isDark = ThemeSignals.isDark();
      return ShadSwitch(
        value: isDark,
        onChanged: (v) => ThemeController().onSwitchTheme(),
      );
    });
  }
}
