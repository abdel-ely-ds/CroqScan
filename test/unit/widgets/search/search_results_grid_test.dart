import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/search/search_results_grid.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  group('SearchResultsGrid Widget Tests', () {
    testWidgets('displays product grid', (tester) async {
      final products = [
        Product(
          barcode: '123',
          name: 'Product 1',
          brand: 'Brand 1',
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
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsGrid(
              products: products,
              isLoadingMore: false,
              hasMoreProducts: false,
              onProductTap: (p) {},
              onLoadMore: () {},
            ),
          ),
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays empty state when no products', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultsGrid(
              products: const [],
              isLoadingMore: false,
              hasMoreProducts: false,
              onProductTap: (p) {},
              onLoadMore: () {},
            ),
          ),
        ),
      );

      expect(find.text('Aucun résultat trouvé'), findsOneWidget);
    });
  });
}

