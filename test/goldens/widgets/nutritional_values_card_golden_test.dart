import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/nutritional_values_card.dart';
import 'package:croq_scan/core/models/product.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  group('NutritionalValuesCard golden tests', () {
    testWidgets('NutritionalValuesCard - high protein', (tester) async {
      final product = Product(
        barcode: '123456',
        name: 'High Protein Food',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 95,
        suitableFor: [PetType.dog],
        description: 'High protein product',
        ingredients: ['Chicken', 'Fish'],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 35.0,
          fat: 15.0,
          fiber: 3.0,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          Center(
            child: SizedBox(
              width: 350,
              child: NutritionalValuesCard(product: product),
            ),
          ),
        ),
        surfaceSize: const Size(400, 700),
      );

      await expectLater(
        find.byType(NutritionalValuesCard),
        matchesGoldenFile('images/nutritional_values_card_high_protein.png'),
      );
    });

    testWidgets('NutritionalValuesCard - balanced', (tester) async {
      final product = Product(
        barcode: '234567',
        name: 'Balanced Food',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 80,
        suitableFor: [PetType.cat],
        description: 'Balanced product',
        ingredients: ['Chicken', 'Rice'],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 28.0,
          fat: 12.0,
          fiber: 2.5,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          Center(
            child: SizedBox(
              width: 350,
              child: NutritionalValuesCard(product: product),
            ),
          ),
        ),
        surfaceSize: const Size(400, 700),
      );

      await expectLater(
        find.byType(NutritionalValuesCard),
        matchesGoldenFile('images/nutritional_values_card_balanced.png'),
      );
    });

    testWidgets('NutritionalValuesCard - low quality', (tester) async {
      final product = Product(
        barcode: '345678',
        name: 'Budget Food',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 45,
        suitableFor: [PetType.dog],
        description: 'Budget product',
        ingredients: ['Corn', 'By-products'],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 15.0,
          fat: 8.0,
          fiber: 1.5,
          moisture: 12.0,
          ash: 6.0,
        ),
      );

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          Center(
            child: SizedBox(
              width: 350,
              child: NutritionalValuesCard(product: product),
            ),
          ),
        ),
        surfaceSize: const Size(400, 700),
      );

      await expectLater(
        find.byType(NutritionalValuesCard),
        matchesGoldenFile('images/nutritional_values_card_low_quality.png'),
      );
    });

    testWidgets('NutritionalValuesCard - dark mode', (tester) async {
      final product = Product(
        barcode: '456789',
        name: 'Premium Food',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 88,
        suitableFor: [PetType.dog],
        description: 'Premium product',
        ingredients: ['Chicken', 'Salmon'],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 30.0,
          fat: 14.0,
          fiber: 3.0,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          Center(
            child: SizedBox(
              width: 350,
              child: NutritionalValuesCard(product: product),
            ),
          ),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(400, 700),
      );

      await expectLater(
        find.byType(NutritionalValuesCard),
        matchesGoldenFile('images/nutritional_values_card_dark.png'),
      );
    });
  });
}
