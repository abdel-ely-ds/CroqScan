import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/score_badge.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  group('ScoreBadge golden tests - different scores', () {
    testWidgets('ScoreBadge - excellent score (90+)', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 95, size: 100)),
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_excellent.png'),
      );
    });

    testWidgets('ScoreBadge - very good score (80-89)', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 85, size: 100)),
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_very_good.png'),
      );
    });

    testWidgets('ScoreBadge - good score (70-79)', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 75, size: 100)),
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_good.png'),
      );
    });

    testWidgets('ScoreBadge - average score (60-69)', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 65, size: 100)),
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_average.png'),
      );
    });

    testWidgets('ScoreBadge - poor score (50-59)', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 55, size: 100)),
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_poor.png'),
      );
    });

    testWidgets('ScoreBadge - bad score (<50)', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 35, size: 100)),
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_bad.png'),
      );
    });
  });

  group('ScoreBadge golden tests - dark mode', () {
    testWidgets('ScoreBadge - excellent dark mode', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 95, size: 100)),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_excellent_dark.png'),
      );
    });

    testWidgets('ScoreBadge - poor dark mode', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const Center(child: ScoreBadge(score: 55, size: 100)),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(250, 250),
      );

      await expectLater(
        find.byType(ScoreBadge),
        matchesGoldenFile('images/score_badge_poor_dark.png'),
      );
    });
  });
}
