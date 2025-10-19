import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/profile_screen.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
    await GoldenTestHelper.initMocks();
  });

  testWidgets('ProfileScreen golden test - light mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const ProfileScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    // Pump plusieurs fois avec duration pour éviter le timeout
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('images/profile_screen_light.png'),
    );
  });

  testWidgets('ProfileScreen golden test - dark mode', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const ProfileScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    // Pump plusieurs fois avec duration pour éviter le timeout
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('images/profile_screen_dark.png'),
    );
  });

  testWidgets('ProfileScreen golden test - tablet', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.tabletSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const ProfileScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    // Pump plusieurs fois avec duration pour éviter le timeout
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('images/profile_screen_tablet.png'),
    );
  });
}
