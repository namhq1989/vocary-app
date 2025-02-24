import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vocary/app/controllers/theme_controller.dart';
import 'package:vocary/core/http.dart';
import 'package:vocary/core/storage.dart';

class Startup {
  static Future<void> initialize({String env = 'dev'}) async {
    WidgetsFlutterBinding.ensureInitialized();

    await _loadEnv(env);
    await _initializeStorage();
    await _initializeHttp();
    await _preloadData();
  }

  static Future<void> _loadEnv(String env) async {
    String envFilePath = 'assets/env/.env.$env';
    await dotenv.load(fileName: envFilePath);
  }

  static Future<void> _initializeStorage() async {
    await Storage.init();
  }

  static Future<void> _initializeHttp() async {
    await Http().initialize();
  }

  static Future<void> _preloadData() async {
    await ThemeController.loadTheme();
  }
}
