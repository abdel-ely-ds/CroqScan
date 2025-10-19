import 'package:flutter/material.dart';
import 'app.dart';
import 'core/app_initializer.dart';

/// Application entry point
/// Initializes services and launches the app
void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all critical services
  final initialized = await AppInitializer.initialize();

  if (!initialized) {
    debugPrint(
      '❌ Failed to initialize app - some services may not work correctly',
    );
  }

  // Launch the app
  runApp(const PetScanApp());
}
