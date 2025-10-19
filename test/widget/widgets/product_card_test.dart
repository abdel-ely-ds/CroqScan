import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/models/product.dart';
import 'package:croq_scan/ui/widgets/product_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductCard Widget Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        barcode: '1234567890123',
        name: 'Test Product',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/test.jpg',
        healthScore: 85,
        suitableFor: [PetType.dog, PetType.cat],
        description: 'Test description',
        ingredients: ['Chicken'],
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
    });

    testWidgets('displays product name and brand', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Brand'), findsOneWidget);
    });

    testWidgets('displays health score', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('85'), findsOneWidget);
    });

    testWidgets('displays pet type icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display icons for dog and cat
      expect(find.text('🐕'), findsWidgets);
      expect(find.text('🐈'), findsWidgets);
    });

    testWidgets('card is tappable', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () => tapped = true,
              child: ProductCard(product: testProduct),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(ProductCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}

