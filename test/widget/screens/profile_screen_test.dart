import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/profile_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileScreen Widget Tests', () {
    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ProfileScreen()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays profile header after loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ProfileScreen()),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Profil'), findsWidgets);
    });
  });
}

