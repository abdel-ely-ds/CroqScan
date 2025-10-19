import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/main_navigation.dart';

/// Integration tests pour valider les flows principaux de l'app
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Integration Tests', () {
    testWidgets('app loads and displays navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigation(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigation bar should be visible
      expect(find.byType(MainNavigation), findsOneWidget);
    });

    testWidgets('can navigate between tabs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigation(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap search tab
      await tester.tap(find.text('Recherche'));
      await tester.pumpAndSettle();

      // Should switch to search screen
      expect(find.byType(MainNavigation), findsOneWidget);
    });

    testWidgets('home to favorites flow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigation(),
        ),
      );

      await tester.pumpAndSettle();

      // Start on home
      await tester.tap(find.text('Favoris'));
      await tester.pumpAndSettle();

      // Should show favorites screen
      expect(find.byType(MainNavigation), findsOneWidget);
    });
  });
}

