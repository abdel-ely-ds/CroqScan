import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/account_card_full.dart';
import 'package:croq_scan/core/services/auth_service.dart';

void main() {
  group('AccountCardFull Widget Tests', () {
    testWidgets('displays guest mode when no user', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCardFull(
              appleUser: null,
              onLogin: () {},
              onLogout: () {},
              buildDetailRow: (icon, label, value) => Container(),
            ),
          ),
        ),
      );

      expect(find.text('Mode Invité'), findsOneWidget);
    });

    testWidgets('displays Apple ID when user logged in', (tester) async {
      final user = UserInfo(
        userIdentifier: '123',
        email: 'test@example.com',
        name: 'John Doe',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCardFull(
              appleUser: user,
              onLogin: () {},
              onLogout: () {},
              buildDetailRow: (icon, label, value) => Container(),
            ),
          ),
        ),
      );

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('login button calls callback', (tester) async {
      bool loginCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCardFull(
              appleUser: null,
              onLogin: () => loginCalled = true,
              onLogout: () {},
              buildDetailRow: (icon, label, value) => Container(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Se connecter avec Apple'));
      expect(loginCalled, isTrue);
    });
  });
}
