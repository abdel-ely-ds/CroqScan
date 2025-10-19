import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/product_analysis_card.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  group('ProductAnalysisCard Widget Tests', () {
    testWidgets('displays product description', (tester) async {
      final product = Product(
        barcode: '123',
        name: 'Test Product',
        brand: 'Brand',
        imageUrl: '',
        healthScore: 75,
        suitableFor: [],
        description: 'This is a test product',
        ingredients: [],
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
          home: Scaffold(
            body: ProductAnalysisCard(
              benefits: product.benefits,
              warnings: product.warnings,
            ),
          ),
        ),
      );

      // Widget renders
      expect(find.byType(ProductAnalysisCard), findsOneWidget);
    });

    testWidgets('displays benefits when present', (tester) async {
      final product = Product(
        barcode: '123',
        name: 'Test',
        brand: 'Brand',
        imageUrl: '',
        healthScore: 85,
        suitableFor: [],
        description: '',
        ingredients: [],
        warnings: [],
        benefits: ['High in protein', 'Natural ingredients'],
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
          home: Scaffold(
            body: ProductAnalysisCard(
              benefits: product.benefits,
              warnings: product.warnings,
            ),
          ),
        ),
      );

      expect(find.text('High in protein'), findsOneWidget);
      expect(find.text('Natural ingredients'), findsOneWidget);
    });
  });
}
