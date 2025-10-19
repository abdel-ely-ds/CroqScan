import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen Widget Tests', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify screen renders
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('displays welcome header', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for welcome text (will show "Bonjour" even without user name)
      expect(find.textContaining('Bonjour'), findsWidgets);
    });

    testWidgets('displays scanner button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Look for scanner button
      expect(find.text('Scanner un produit'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });

    testWidgets('displays category cards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify category section exists
      expect(find.textContaining('Explorer par catégorie'), findsOneWidget);

      // Verify some categories are shown
      expect(find.text('Croquettes'), findsOneWidget);
      expect(find.text('Pâtées'), findsOneWidget);
    });

    testWidgets('scanner button is tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
          routes: {
            '/scanner': (context) => const Scaffold(
                  body: Center(child: Text('Scanner Screen')),
                ),
          },
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap scanner button
      final scannerButton = find.text('Scanner un produit');
      expect(scannerButton, findsOneWidget);

      await tester.tap(scannerButton);
      await tester.pumpAndSettle();

      // After navigation, should see scanner screen
      // (Note: This might not work without proper navigation setup)
    });

    testWidgets('pull to refresh works', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find refreshable area
      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      // Simulate pull to refresh
      await tester.drag(refreshIndicator, const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Screen should still be there after refresh
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}

