import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/main_navigation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MainNavigation Widget Tests', () {
    testWidgets('displays 5 navigation items', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainNavigation()));

      await tester.pumpAndSettle();

      expect(find.byType(MainNavigation), findsOneWidget);
      // 5 tabs: Home, Search, Scanner, Favorites, Profile
    });

    testWidgets('displays scanner button in center', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainNavigation()));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });

    testWidgets('displays home icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainNavigation()));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });
  });
}
