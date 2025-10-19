import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/auth_service.dart';
import 'services/profile_service.dart';

/// Central app initializer - handles all service initialization before app starts
class AppInitializer {
  static bool _initialized = false;

  /// Initialize all critical services
  /// Returns true if initialization successful, false otherwise
  static Future<bool> initialize() async {
    if (_initialized) {
      debugPrint('⚠️ AppInitializer: Already initialized, skipping...');
      return true;
    }

    try {
      debugPrint('🚀 AppInitializer: Starting initialization...');

      // 1. Flutter bindings (should already be done, but ensure it)
      WidgetsFlutterBinding.ensureInitialized();
      debugPrint('✅ Flutter bindings initialized');

      // 2. System UI Configuration
      await _initializeSystemUI();
      debugPrint('✅ System UI configured');

      // 3. Initialize core services
      // Note: Individual services use lazy initialization via static methods,
      // so we just need to ensure they're ready
      await _initializeServices();
      debugPrint('✅ Core services initialized');

      _initialized = true;
      debugPrint('🎉 AppInitializer: Initialization complete!');
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ AppInitializer: Initialization failed!');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Configure system UI (status bar, orientation, etc.)
  static Future<void> _initializeSystemUI() async {
    // Set preferred orientations (portrait only)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style (transparent status bar)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Initialize core services
  /// Services use lazy initialization, so we just verify they're accessible
  static Future<void> _initializeServices() async {
    // Verify auth service is accessible
    try {
      await AuthService.isLoggedIn();
      debugPrint('  ✓ AuthService ready');
    } catch (e) {
      debugPrint('  ⚠️ AuthService check failed: $e');
    }

    // Verify profile service is accessible
    try {
      await ProfileService.loadProfile();
      debugPrint('  ✓ ProfileService ready');
    } catch (e) {
      debugPrint('  ⚠️ ProfileService check failed: $e');
    }

    // Note: Other services (FavoritesService, ScanHistoryService, OpenPetFoodFactsService)
    // are stateless and use lazy initialization, so no pre-initialization needed
  }

  /// Check if app is initialized
  static bool get isInitialized => _initialized;

  /// Reset initialization state (mainly for testing)
  static void reset() {
    _initialized = false;
    debugPrint('🔄 AppInitializer: Reset');
  }
}
