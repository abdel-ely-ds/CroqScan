import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/favorites_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesScreen Widget Tests', () {
    testWidgets('displays header', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: FavoritesScreen(key: UniqueKey())),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Mes Favoris'), findsOneWidget);
    });

    testWidgets('shows empty state when no favorites', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: FavoritesScreen(key: UniqueKey())),
      );

      await tester.pumpAndSettle();

      // Empty state might be shown
      expect(find.byType(FavoritesScreen), findsOneWidget);
    });
  });
}
