import 'package:flutter/material.dart';
import 'app.dart';
import 'core/app_initializer.dart';
import 'core/utils/error_handler.dart';

/// Application entry point
/// Initializes services and launches the app
void main() async {
  // Initialize error handlers FIRST
  initializeErrorHandlers();

  // Run app with error handling zone
  runAppWithErrorHandling(() async {
    // Initialize Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize all critical services
    final initialized = await AppInitializer.initialize();

    if (!initialized) {
      logWarning(
        '❌ Failed to initialize app - some services may not work correctly',
      );
    }

    // Launch the app
    runApp(const PetScanApp());
  });
}
