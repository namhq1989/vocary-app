import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vocary/core/http.dart';
import 'package:vocary/core/storage.dart';

class Startup {
  static Future<void> initialize({String env = 'dev'}) async {
    WidgetsFlutterBinding.ensureInitialized();

    await _loadEnv(env);
    await _loadConfigs();
    await _initializeStorage();
    await _initializeHttp();
    await _preloadData();
  }

  static Future<void> _loadEnv(String env) async {
    String envFilePath = 'assets/env/.env.$env';
    await dotenv.load(fileName: envFilePath);
  }

  static Future<void> _loadConfigs() async {
    print("Configurations loaded.");
  }

  static Future<void> _initializeStorage() async {
    await Storage.init();
  }

  static Future<void> _initializeHttp() async {
    await Http().initialize();
  }

  static Future<void> _preloadData() async {
    print("Preloaded data");
  }
}
