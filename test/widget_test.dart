// This is a basic Flutter widget test for CroqScan app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:croq_scan/main.dart';

void main() {
  testWidgets('CroqScan app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CroqScanApp());

    // Verify that the app title is present.
    expect(find.text('CroqScan'), findsWidgets);

    // Verify that the welcome message is present.
    expect(find.text('Keep your pets healthy'), findsOneWidget);

    // Verify that scan button is present.
    expect(find.text('Scan a Product'), findsOneWidget);

    // Verify that search button is present.
    expect(find.text('Search Products'), findsOneWidget);
  });
}
