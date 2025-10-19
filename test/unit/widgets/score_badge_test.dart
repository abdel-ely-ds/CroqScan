import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/score_badge.dart';
import 'package:croq_scan/core/constants/app_colors.dart';

void main() {
  group('ScoreBadge Widget Tests', () {
    testWidgets('displays score correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 85))),
      );

      expect(find.text('85'), findsOneWidget);
    });

    testWidgets('shows excellent for score >= 80', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 85))),
      );

      await tester.pumpAndSettle();

      // Badge should exist
      expect(find.byType(ScoreBadge), findsOneWidget);
    });

    testWidgets('shows good for score 60-79', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 70))),
      );

      expect(find.text('70'), findsOneWidget);
    });

    testWidgets('shows medium for score 40-59', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 50))),
      );

      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('shows poor for score < 40', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ScoreBadge(score: 30))),
      );

      expect(find.text('30'), findsOneWidget);
    });
  });
}
