import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/ingredients_card.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  group('IngredientsCard Widget Tests', () {
    testWidgets('displays ingredients list', (tester) async {
      final product = Product(
        barcode: '123',
        name: 'Test',
        brand: 'Brand',
        imageUrl: '',
        healthScore: 70,
        suitableFor: [],
        description: '',
        ingredients: ['Poulet', 'Riz', 'Légumes'],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 0,
          fat: 0,
          fiber: 0,
          moisture: 0,
          ash: 0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: IngredientsCard(product: product)),
        ),
      );

      expect(find.text('Poulet'), findsOneWidget);
      expect(find.text('Riz'), findsOneWidget);
      expect(find.text('Légumes'), findsOneWidget);
    });
  });
}
