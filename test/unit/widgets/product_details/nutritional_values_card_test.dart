import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/nutritional_values_card.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  group('NutritionalValuesCard Widget Tests', () {
    testWidgets('displays nutritional information', (tester) async {
      final product = Product(
        barcode: '123',
        name: 'Test',
        brand: 'Brand',
        imageUrl: '',
        healthScore: 70,
        suitableFor: [],
        description: '',
        ingredients: [],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 30.0,
          fat: 15.0,
          fiber: 3.0,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NutritionalValuesCard(product: product)),
        ),
      );

      expect(find.text('Protéines'), findsOneWidget);
      expect(find.text('30.0 g'), findsOneWidget);
      expect(find.text('Matières grasses'), findsOneWidget);
      expect(find.text('15.0 g'), findsOneWidget);
    });
  });
}
