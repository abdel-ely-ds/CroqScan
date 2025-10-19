import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/favorites_screen.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
    await GoldenTestHelper.initMocks();
  });

  testWidgets('FavoritesScreen golden test - empty state', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const FavoritesScreen(),
        themeMode: ThemeMode.light,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(FavoritesScreen),
      matchesGoldenFile('images/favorites_screen_empty.png'),
    );
  });

  testWidgets('FavoritesScreen golden test - dark mode empty', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(
        const FavoritesScreen(),
        themeMode: ThemeMode.dark,
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(FavoritesScreen),
      matchesGoldenFile('images/favorites_screen_empty_dark.png'),
    );
  });
}
