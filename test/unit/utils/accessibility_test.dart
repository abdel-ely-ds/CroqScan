import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/utils/accessibility_helpers.dart';

void main() {
  group('Accessibility Helpers Tests', () {
    testWidgets('AccessibleButton has correct semantics', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleButton(
              label: 'Test Button',
              hint: 'This is a test',
              onTap: () => tapped = true,
              child: const Text('Button'),
            ),
          ),
        ),
      );

      // Check semantics
      final semantics = tester.getSemantics(find.byType(AccessibleButton));
      expect(semantics.label, contains('Test Button'));

      // Tap functionality
      await tester.tap(find.text('Button'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('AccessibleImage has correct label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleImage(
              label: 'Product image',
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(AccessibleImage));
      expect(semantics.label, contains('Product image'));
    });

    testWidgets('MinimumTouchTarget enforces minimum size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MinimumTouchTarget(child: Icon(Icons.favorite, size: 20)),
          ),
        ),
      );

      final box = tester.getSize(find.byType(MinimumTouchTarget));
      expect(box.width, greaterThanOrEqualTo(48.0));
      expect(box.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('AccessibleContainer has focusable semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleContainer(
              label: 'Card label',
              hint: 'Tap to open',
              child: const SizedBox(width: 200, height: 100),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(AccessibleContainer));
      expect(semantics.label, contains('Card label'));
    });
  });
}
