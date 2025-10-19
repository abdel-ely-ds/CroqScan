import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/splash_screen.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  testWidgets('SplashScreen golden test - light mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const SplashScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('images/splash_screen_light.png'),
    );
  });

  testWidgets('SplashScreen golden test - dark mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const SplashScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('images/splash_screen_dark.png'),
    );
  });
}
