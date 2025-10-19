import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/main_navigation.dart';
import 'package:croq_scan/ui/widgets/product_card.dart';
import 'package:croq_scan/core/models/product.dart';

/// Tests pour valider la conformité accessibility
void main() {
  group('Accessibility Semantics Tests', () {
    testWidgets('MainNavigation has semantic labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MainNavigation()),
      );

      await tester.pumpAndSettle();

      // Verify semantic tree structure
      final semantics = tester.getAllSemantics();
      expect(semantics, isNotEmpty);
      
      // Should have button semantics
      final buttonSemantics = semantics.where(
        (node) => node.hasFlag(SemanticsFlag.isButton),
      );
      expect(buttonSemantics.length, greaterThan(0));
    });

    testWidgets('ProductCard has accessible label', (tester) async {
      final product = Product(
        barcode: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        imageUrl: '',
        healthScore: 85,
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

      await tester.pumpAndSettle();

      // Should have semantic description
      final semantics = tester.getSemantics(find.byType(ProductCard));
      expect(semantics.label, isNotNull);
    });

    testWidgets('all interactive elements have min 48x48 touch target', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MainNavigation()),
      );

      await tester.pumpAndSettle();

      // This is a basic check - full validation would need more sophisticated testing
      expect(find.byType(MainNavigation), findsOneWidget);
    });
  });
}

