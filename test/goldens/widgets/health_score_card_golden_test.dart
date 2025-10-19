import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/health_score_card.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  group('HealthScoreCard golden tests - different scores', () {
    testWidgets('HealthScoreCard - excellent score', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: HealthScoreCard(healthScore: 95)),
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(HealthScoreCard),
        matchesGoldenFile('images/health_score_card_excellent.png'),
      );
    });

    testWidgets('HealthScoreCard - good score', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: HealthScoreCard(healthScore: 75)),
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(HealthScoreCard),
        matchesGoldenFile('images/health_score_card_good.png'),
      );
    });

    testWidgets('HealthScoreCard - average score', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: HealthScoreCard(healthScore: 60)),
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(HealthScoreCard),
        matchesGoldenFile('images/health_score_card_average.png'),
      );
    });

    testWidgets('HealthScoreCard - poor score', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: HealthScoreCard(healthScore: 35)),
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(HealthScoreCard),
        matchesGoldenFile('images/health_score_card_poor.png'),
      );
    });
  });

  group('HealthScoreCard golden tests - dark mode', () {
    testWidgets('HealthScoreCard - excellent dark mode', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: HealthScoreCard(healthScore: 95)),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(HealthScoreCard),
        matchesGoldenFile('images/health_score_card_excellent_dark.png'),
      );
    });

    testWidgets('HealthScoreCard - poor dark mode', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: HealthScoreCard(healthScore: 35)),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(400, 400),
      );

      await expectLater(
        find.byType(HealthScoreCard),
        matchesGoldenFile('images/health_score_card_poor_dark.png'),
      );
    });
  });
}
