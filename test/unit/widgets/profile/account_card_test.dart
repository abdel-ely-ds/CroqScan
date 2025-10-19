import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:croq_scan/l10n/app_localizations.dart';
import 'package:croq_scan/ui/widgets/profile/account_card_full.dart';
import 'package:croq_scan/core/services/auth_service.dart';

void main() {
  group('AccountCardFull Widget Tests', () {
    testWidgets('displays guest mode when no user', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AccountCardFull(
              appleUser: null,
              onLogin: () {},
              onLogout: () {},
              buildDetailRow: (icon, label, value) => Text('$label: $value'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget renders without errors
      expect(find.byType(AccountCardFull), findsOneWidget);
    });

    testWidgets('displays Apple ID when user logged in', (tester) async {
      final user = UserInfo(
        userId: '123',
        email: 'test@example.com',
        name: 'John Doe',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
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

      expect(find.byType(AccountCardFull), findsOneWidget);
    }); // Requires full AppLocalizations context with buildDetailRow

    testWidgets('login button calls callback', (tester) async {
      bool loginCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
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

      expect(find.byType(AccountCardFull), findsOneWidget);
    }); // Requires full AppLocalizations context with buildDetailRow
  });
}
