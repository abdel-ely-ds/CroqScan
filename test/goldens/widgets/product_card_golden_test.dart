import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_card.dart';
import 'package:croq_scan/core/models/product.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  group('ProductCard golden tests - different scores', () {
    testWidgets('ProductCard - excellent score product', (tester) async {
      final product = Product(
        barcode: '123456',
        name: 'Premium Dog Food',
        brand: 'Royal Canin',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 95,
        suitableFor: [PetType.dog],
        description: 'High quality dog food with excellent nutritional values',
        ingredients: ['Chicken', 'Rice', 'Vegetables'],
        warnings: [],
        benefits: ['High protein', 'Balanced nutrition'],
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
            child: SizedBox(width: 350, child: ProductCard(product: product)),
          ),
        ),
        surfaceSize: const Size(400, 600),
      );

      await expectLater(
        find.byType(ProductCard),
        matchesGoldenFile('images/product_card_excellent.png'),
      );
    });

    testWidgets('ProductCard - good score product', (tester) async {
      final product = Product(
        barcode: '234567',
        name: 'Standard Cat Food',
        brand: 'Purina',
        imageUrl: 'https://example.com/cat.jpg',
        healthScore: 75,
        suitableFor: [PetType.cat],
        description: 'Good quality cat food',
        ingredients: ['Fish', 'Corn', 'Vitamins'],
        warnings: ['Contains corn'],
        benefits: ['Good protein'],
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
            child: SizedBox(width: 350, child: ProductCard(product: product)),
          ),
        ),
        surfaceSize: const Size(400, 600),
      );

      await expectLater(
        find.byType(ProductCard),
        matchesGoldenFile('images/product_card_good.png'),
      );
    });

    testWidgets('ProductCard - poor score product', (tester) async {
      final product = Product(
        barcode: '345678',
        name: 'Budget Dog Food',
        brand: 'Generic',
        imageUrl: 'https://example.com/budget.jpg',
        healthScore: 45,
        suitableFor: [PetType.dog, PetType.cat],
        description: 'Basic pet food',
        ingredients: ['Corn', 'By-products', 'Additives'],
        warnings: ['Contains by-products', 'High in corn'],
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
            child: SizedBox(width: 350, child: ProductCard(product: product)),
          ),
        ),
        surfaceSize: const Size(400, 600),
      );

      await expectLater(
        find.byType(ProductCard),
        matchesGoldenFile('images/product_card_poor.png'),
      );
    });
  });

  group('ProductCard golden tests - different pet types', () {
    testWidgets('ProductCard - multi-pet product', (tester) async {
      final product = Product(
        barcode: '456789',
        name: 'Universal Pet Treats',
        brand: 'Multi Pet',
        imageUrl: 'https://example.com/treats.jpg',
        healthScore: 80,
        suitableFor: [PetType.dog, PetType.cat, PetType.rabbit],
        description: 'Suitable for multiple pet types',
        ingredients: ['Natural meat', 'Vegetables'],
        warnings: [],
        benefits: ['Natural ingredients', 'No additives'],
        nutritionalInfo: NutritionalInfo(
          protein: 30.0,
          fat: 14.0,
          fiber: 3.5,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          Center(
            child: SizedBox(width: 350, child: ProductCard(product: product)),
          ),
        ),
        surfaceSize: const Size(400, 600),
      );

      await expectLater(
        find.byType(ProductCard),
        matchesGoldenFile('images/product_card_multi_pet.png'),
      );
    });

    testWidgets('ProductCard - bird food', (tester) async {
      final product = Product(
        barcode: '567890',
        name: 'Premium Bird Seed Mix',
        brand: 'Bird Best',
        imageUrl: 'https://example.com/bird.jpg',
        healthScore: 88,
        suitableFor: [PetType.bird],
        description: 'Nutritious seed mix for birds',
        ingredients: ['Sunflower seeds', 'Millet', 'Oats'],
        warnings: [],
        benefits: ['Rich in vitamins', 'Natural seeds'],
        nutritionalInfo: NutritionalInfo(
          protein: 20.0,
          fat: 18.0,
          fiber: 8.0,
          moisture: 8.0,
          ash: 4.0,
        ),
      );

      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          Center(
            child: SizedBox(width: 350, child: ProductCard(product: product)),
          ),
        ),
        surfaceSize: const Size(400, 600),
      );

      await expectLater(
        find.byType(ProductCard),
        matchesGoldenFile('images/product_card_bird.png'),
      );
    });
  });

  group('ProductCard golden tests - dark mode', () {
    testWidgets('ProductCard - excellent score dark mode', (tester) async {
      final product = Product(
        barcode: '123456',
        name: 'Premium Dog Food',
        brand: 'Royal Canin',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 95,
        suitableFor: [PetType.dog],
        description: 'High quality dog food',
        ingredients: ['Chicken', 'Rice'],
        warnings: [],
        benefits: ['High protein'],
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
            child: SizedBox(width: 350, child: ProductCard(product: product)),
          ),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: const Size(400, 600),
      );

      await expectLater(
        find.byType(ProductCard),
        matchesGoldenFile('images/product_card_excellent_dark.png'),
      );
    });
  });
}
