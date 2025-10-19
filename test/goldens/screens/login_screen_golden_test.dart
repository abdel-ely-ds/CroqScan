import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/login_screen.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  testWidgets('LoginScreen golden test - light mode', (tester) async {
    await GoldenTestHelper.pumpAndSettle(
      tester,
      GoldenTestHelper.wrapWithApp(
        const SingleChildScrollView(child: LoginScreen()),
        themeMode: ThemeMode.light,
      ),
      surfaceSize: const Size(
        375,
        900,
      ), // Taille plus grande pour tout le contenu
    );

    await expectLater(
      find.byType(SingleChildScrollView),
      matchesGoldenFile('images/login_screen_light.png'),
    );
  });

  testWidgets('LoginScreen golden test - dark mode', (tester) async {
    await GoldenTestHelper.pumpAndSettle(
      tester,
      GoldenTestHelper.wrapWithApp(
        const SingleChildScrollView(child: LoginScreen()),
        themeMode: ThemeMode.dark,
      ),
      surfaceSize: const Size(
        375,
        900,
      ), // Taille plus grande pour tout le contenu
    );

    await expectLater(
      find.byType(SingleChildScrollView),
      matchesGoldenFile('images/login_screen_dark.png'),
    );
  });
}
