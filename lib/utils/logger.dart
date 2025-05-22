import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to display in the stack trace
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Include a timestamp in each log
    ),
  );

  static void info(String message) {
    _logger.i(message);
  }

  static void debug(String message) {
    _logger.d(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void verbose(String message) {
    _logger.v(message);
  }
}