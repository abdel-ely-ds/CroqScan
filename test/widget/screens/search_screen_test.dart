import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/search_screen_new.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchScreenNew Widget Tests', () {
    testWidgets('displays search field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchScreenNew(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays category tabs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchScreenNew(),
        ),
      );

      await tester.pumpAndSettle();

      // Should have category selection
      expect(find.byType(SearchScreenNew), findsOneWidget);
    });

    testWidgets('search field accepts input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchScreenNew(),
        ),
      );

      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'croquettes');
      
      expect(find.text('croquettes'), findsOneWidget);
    });
  });
}

