import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // Load from .env file
  static String get apiEndpoint =>
      dotenv.env['API_ENDPOINT'] ?? 'http://localhost:3000';

  // Hardcoded app settings
  static const String appName = 'Vocary';
  static const String defaultLanguage = 'en';

  static const bool enableLogging = true;

  // API configurations
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
}
