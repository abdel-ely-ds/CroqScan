import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PetScanApp Tests', () {
    testWidgets('app builds without errors', (tester) async {
      await tester.pumpWidget(const PetScanApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('app has correct theme', (tester) async {
      await tester.pumpWidget(const PetScanApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });

    testWidgets('app has localization configured', (tester) async {
      await tester.pumpWidget(const PetScanApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.localizationsDelegates, isNotEmpty);
      expect(materialApp.supportedLocales, isNotEmpty);
    });
  });
}

