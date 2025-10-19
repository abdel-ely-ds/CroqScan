import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/product_details/product_action_bar.dart';

void main() {
  group('ProductActionBar Widget Tests', () {
    testWidgets('displays favorite button', (tester) async {
      bool favoriteToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductActionBar(
              isFavorite: false,
              onFavoriteToggle: () => favoriteToggled = true,
            ),
          ),
        ),
      );

      final favoriteButton = find.byIcon(Icons.favorite_border);
      expect(favoriteButton, findsOneWidget);

      await tester.tap(favoriteButton);
      expect(favoriteToggled, isTrue);
    });

    testWidgets('shows filled heart when favorite', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductActionBar(isFavorite: true, onFavoriteToggle: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('displays share button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductActionBar(isFavorite: false, onFavoriteToggle: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
    });
  });
}
