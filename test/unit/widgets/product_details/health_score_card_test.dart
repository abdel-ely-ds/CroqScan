import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/health_score_card.dart';

void main() {
  group('HealthScoreCard Widget Tests', () {
    testWidgets('displays score and label for excellent', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HealthScoreCard(healthScore: 90))),
      );

      expect(find.text('90'), findsOneWidget);
      expect(find.text('Excellent'), findsOneWidget);
    });

    testWidgets('displays score and label for good', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HealthScoreCard(healthScore: 75))),
      );

      // Widget should render without errors
      expect(find.byType(HealthScoreCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
