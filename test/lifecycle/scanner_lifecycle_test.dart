import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/scanner_screen.dart';

/// Lifecycle tests pour ScannerScreen
/// Vérifie mount, dispose, et rapid navigation
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScannerScreen Lifecycle Tests', () {
    testWidgets('properly disposes resources', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ScannerScreen()),
      );

      // Navigate away
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Other'))),
      );

      // Should not throw errors
      await tester.pumpAndSettle();
    }, skip: 'Camera permissions required');

    testWidgets('handles rapid navigation', (tester) async {
      // Rapid enter/exit
      for (int i = 0; i < 3; i++) {
        await tester.pumpWidget(
          const MaterialApp(home: ScannerScreen()),
        );

        await tester.pump();

        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: Text('Away'))),
        );

        await tester.pump();
      }

      // Should not leak memory or throw errors
      expect(tester.takeException(), isNull);
    }, skip: 'Camera permissions required');
  });
}

