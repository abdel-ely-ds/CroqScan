/// Centralized error handling for the application
///
/// This file provides global error handling following Flutter best practices.
/// All errors are logged and can be sent to crash reporting services.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Global logger instance
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

/// Initialize global error handlers
///
/// Should be called in main() before runApp()
void initializeErrorHandlers() {
  // Capture Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );

    // In debug mode, show the red error screen
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }

    // In production, you could send to Crashlytics/Sentry here
    // Example: FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  // Capture errors outside of Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('Platform Error', error: error, stackTrace: stack);

    // In production, send to crash reporting
    // Example: FirebaseCrashlytics.instance.recordError(error, stack);

    return true;
  };
}

/// Run the app with error handling zone
///
/// Usage:
/// ```dart
/// void main() {
///   initializeErrorHandlers();
///   runAppWithErrorHandling(() => runApp(MyApp()));
/// }
/// ```
void runAppWithErrorHandling(void Function() app) {
  runZonedGuarded(
    () async {
      app();
    },
    (error, stackTrace) {
      logger.e('Async Error', error: error, stackTrace: stackTrace);

      // In production, send to crash reporting
      // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

/// Handle errors gracefully with user feedback
///
/// Usage:
/// ```dart
/// try {
///   await riskyOperation();
/// } catch (e, stack) {
///   handleError(context, e, stack, userMessage: 'Operation failed');
/// }
/// ```
void handleError(
  BuildContext context,
  Object error,
  StackTrace stackTrace, {
  String? userMessage,
}) {
  logger.e('Handled Error', error: error, stackTrace: stackTrace);

  // Show user-friendly message
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(userMessage ?? 'Une erreur est survenue'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

/// Log info message
void logInfo(String message, [dynamic data]) {
  logger.i(message, error: data);
}

/// Log warning
void logWarning(String message, [dynamic data]) {
  logger.w(message, error: data);
}

/// Log debug message
void logDebug(String message, [dynamic data]) {
  logger.d(message, error: data);
}

/// Log error without throwing
void logError(String message, [Object? error, StackTrace? stackTrace]) {
  logger.e(message, error: error, stackTrace: stackTrace);
}
