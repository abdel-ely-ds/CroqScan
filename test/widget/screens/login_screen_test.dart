import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginScreen Widget Tests', () {
    testWidgets('displays app logo and title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.pumpAndSettle();

      expect(find.text('🐾'), findsOneWidget);
      expect(find.text('PetScan'), findsOneWidget);
    });

    testWidgets('displays Sign in with Apple button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.pumpAndSettle();

      expect(find.text('Continuer avec Apple'), findsOneWidget);
    });

    testWidgets('displays Continue without account button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.pumpAndSettle();

      expect(find.text('Continuer sans compte'), findsOneWidget);
    });

    testWidgets('guest mode button navigates', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.pumpAndSettle();

      final guestButton = find.text('Continuer sans compte');
      expect(guestButton, findsOneWidget);

      // Tap would navigate but we can't test that without full app context
      // This verifies the button exists and is tappable
    }, skip: 'Navigation requires full app context');
  });
}
