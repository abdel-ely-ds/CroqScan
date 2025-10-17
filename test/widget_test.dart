// This is a basic Flutter widget test for PetScan app.

import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/main.dart';

void main() {
  testWidgets('PetScan app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CroqScanApp());

    // Verify that the app loads
    expect(find.text('PetScan'), findsWidgets);
  });
}
