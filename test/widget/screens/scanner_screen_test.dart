import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/scanner_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScannerScreen Widget Tests', () {
    testWidgets(
      'displays scanner UI elements',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ScannerScreen()));

        // Scanner screen should display
        expect(find.byType(ScannerScreen), findsOneWidget);
      },
      skip: 'Camera permission required for full test',
    );

    testWidgets(
      'has back gesture support',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ScannerScreen()));

        // Verify GestureDetector exists for swipe-to-go-back
        expect(find.byType(GestureDetector), findsWidgets);
      },
      skip: 'Gesture testing complex without full integration',
    );
  });
}
