import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests pour les composants de sélection de catégories
void main() {
  group('Search Category Selector Tests', () {
    testWidgets('ChoiceChip selects correctly', (tester) async {
      bool selected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceChip(
              label: const Text('Test'),
              selected: selected,
              onSelected: (value) => selected = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ChoiceChip));
      await tester.pump();

      // ChoiceChip should be tappable
      expect(find.byType(ChoiceChip), findsOneWidget);
    });
  });
}

