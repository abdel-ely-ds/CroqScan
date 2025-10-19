import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/score_badge.dart';

void main() {
  testWidgets('ScoreBadge excellent golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ScoreBadge(score: 90),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ScoreBadge),
      matchesGoldenFile('images/score_badge_excellent.png'),
    );
  });

  testWidgets('ScoreBadge good golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ScoreBadge(score: 70),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ScoreBadge),
      matchesGoldenFile('images/score_badge_good.png'),
    );
  });
}

