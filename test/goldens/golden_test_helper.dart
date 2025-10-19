import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper class to wrap widgets for golden tests with Material app and localization
class GoldenTestHelper {
  /// Wraps a widget in a MaterialApp with localization support
  static Widget wrapWithApp(
    Widget child, {
    ThemeMode themeMode = ThemeMode.light,
    Size? surfaceSize,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr')],
      locale: const Locale('fr'),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: Scaffold(
        backgroundColor: themeMode == ThemeMode.light
            ? Colors.white
            : Colors.black,
        body: child,
      ),
    );
  }

  /// Pumps widget and waits for all animations to settle
  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget widget, {
    Size? surfaceSize,
  }) async {
    if (surfaceSize != null) {
      await tester.binding.setSurfaceSize(surfaceSize);
    }

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Standard phone size for consistent golden tests
  static const Size phoneSize = Size(375, 667); // iPhone SE

  /// Standard tablet size for golden tests
  static const Size tabletSize = Size(768, 1024); // iPad

  /// Loads fonts for golden tests
  static Future<void> loadFonts() async {
    // Font loading is handled automatically by Flutter test framework
    // This method is kept for consistency and future extensions
    await Future<void>.value();
  }

  /// Initialize mock SharedPreferences for golden tests
  static Future<void> initMocks() async {
    // Mock SharedPreferences to avoid MissingPluginException
    SharedPreferences.setMockInitialValues({});
  }
}
