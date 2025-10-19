import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/home_screen.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
    await GoldenTestHelper.initMocks();
  });

  testWidgets('HomeScreen golden test - light mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const HomeScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('images/home_screen_light.png'),
    );
  });

  testWidgets('HomeScreen golden test - dark mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const HomeScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('images/home_screen_dark.png'),
    );
  });

  testWidgets('HomeScreen golden test - tablet', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.tabletSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const HomeScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('images/home_screen_tablet.png'),
    );
  });
}
