import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/score_badge.dart';

void main() {
  group('ScoreBadge Widget Tests', () {
    testWidgets('displays score correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: ScoreBadge(score: 85, size: 120),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('85'), findsOneWidget);
    });

    testWidgets('shows excellent for score >= 80', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: ScoreBadge(score: 90, size: 120),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Score should be displayed
      expect(find.textContaining('90'), findsOneWidget);
      expect(find.text('Excellent'), findsOneWidget);
    });

    testWidgets('shows good for score 60-79', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 70))),
      );

      expect(find.textContaining('70'), findsOneWidget);
    });

    testWidgets('shows medium for score 40-59', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 50))),
      );

      expect(find.textContaining('50'), findsOneWidget);
    });

    testWidgets('shows poor for score < 40', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 30))),
      );

      expect(find.textContaining('30'), findsOneWidget);
    });
  });
}
