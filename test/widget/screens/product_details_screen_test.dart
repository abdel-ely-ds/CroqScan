import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/models/product.dart';
import 'package:croq_scan/ui/screens/product_details_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductDetailsScreen Widget Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        barcode: '1234567890123',
        name: 'Test Product',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/test.jpg',
        healthScore: 75,
        suitableFor: [PetType.dog],
        description: 'A test product description',
        ingredients: ['Chicken', 'Rice', 'Vegetables'],
        warnings: ['Contains grain'],
        benefits: ['High in protein'],
        nutritionalInfo: NutritionalInfo(
          protein: 28.0,
          fat: 15.0,
          fiber: 3.5,
          moisture: 10.0,
          ash: 5.0,
        ),
      );
    });

    testWidgets('displays product information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: testProduct),
        ),
      );

      // Wait for widget to build
      await tester.pumpAndSettle();

      // Verify health score is displayed
      expect(find.text('75'), findsWidgets);
      expect(find.textContaining('/ 100'), findsOneWidget);

      // Verify score label
      expect(find.text('Très bon'), findsOneWidget);

      // Verify section headers
      expect(find.text('💯 Score Santé Global'), findsOneWidget);
      expect(find.text('💪 Valeurs Nutritionnelles'), findsOneWidget);
    });

    testWidgets('displays nutritional values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: testProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verify nutritional values are displayed
      expect(find.textContaining('28.0'), findsOneWidget); // Protein
      expect(find.text('Protéines'), findsOneWidget);
      expect(find.textContaining('15.0'), findsOneWidget); // Fat
      expect(find.text('Matières grasses'), findsOneWidget);
    });

    testWidgets('displays ingredients', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: testProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verify ingredients section exists
      expect(find.text('🦴'), findsOneWidget);
      expect(find.text('Ingrédients'), findsOneWidget);

      // Verify ingredients are displayed
      expect(find.text('Chicken'), findsOneWidget);
      expect(find.text('Rice'), findsOneWidget);
      expect(find.text('Vegetables'), findsOneWidget);
    });

    testWidgets('displays warnings and benefits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: testProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verify analysis section
      expect(find.text('📊 Analyse'), findsOneWidget);
      expect(find.text('Contains grain'), findsOneWidget);
      expect(find.text('High in protein'), findsOneWidget);
    });

    testWidgets('favorite button works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: testProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Find favorite button (there are multiple - in app bar and bottom bar)
      final favoriteButtons = find.byIcon(Icons.favorite_border);
      expect(favoriteButtons, findsWidgets);

      // Tap first favorite button
      await tester.tap(favoriteButtons.first);
      await tester.pumpAndSettle();

      // After tapping, should show snackbar
      expect(find.textContaining('favoris'), findsWidgets);
    });

    testWidgets('back button navigates back', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(product: testProduct),
                    ),
                  );
                },
                child: const Text('Go to Details'),
              ),
            ),
          ),
        ),
      );

      // Navigate to product details
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();

      // Verify we're on product details screen
      expect(find.text('75'), findsWidgets);

      // Tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify we're back
      expect(find.text('Go to Details'), findsOneWidget);
    });

    testWidgets('displays description when available', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: testProduct),
        ),
      );

      await tester.pumpAndSettle();

      // Verify description is displayed
      expect(find.text('📋 Description'), findsOneWidget);
      expect(find.text('A test product description'), findsOneWidget);
    });

    testWidgets('hides description section when empty', (tester) async {
      final productWithoutDesc = Product(
        barcode: '1234567890123',
        name: 'Test Product',
        brand: 'Test Brand',
        imageUrl: '',
        healthScore: 50,
        suitableFor: [PetType.cat],
        description: '', // Empty description
        ingredients: ['Chicken'],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 20.0,
          fat: 10.0,
          fiber: 2.0,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: productWithoutDesc),
        ),
      );

      await tester.pumpAndSettle();

      // Description section should not be visible
      expect(find.text('📋 Description'), findsNothing);
    });
  });
}

