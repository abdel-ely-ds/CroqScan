import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_card.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  testWidgets('ProductCard golden test', (tester) async {
    final product = Product(
      barcode: '123456',
      name: 'Premium Dog Food',
      brand: 'Royal Canin',
      imageUrl: 'https://example.com/image.jpg',
      healthScore: 85,
      suitableFor: [PetType.dog],
      description: 'High quality dog food',
      ingredients: ['Chicken', 'Rice'],
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
        home: Scaffold(
          backgroundColor: Colors.white,
          body: ProductCard(product: product),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProductCard),
      matchesGoldenFile('images/product_card.png'),
    );
  });
}

