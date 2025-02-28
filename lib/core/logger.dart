import 'dart:convert';
import 'package:logger/web.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(dynamic message) {
    _logger.d(message);
  }

  static void i(dynamic message) {
    _logger.i(message);
  }

  static void w(dynamic message) {
    _logger.w(message);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void t(dynamic message) {
    _logger.t(message);
  }

  static void p(String message, dynamic data) {
    String prettyData;
    try {
      const encoder = JsonEncoder.withIndent('  ');
      prettyData = encoder.convert(data);
    } catch (e) {
      prettyData = data.toString();
    }

    _logger.i("$message\n$prettyData");
  }
}
