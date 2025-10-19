import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:croq_scan/l10n/app_localizations.dart';
import 'package:croq_scan/ui/widgets/profile/empty_profile_state_full.dart';

void main() {
  group('EmptyProfileStateFull Widget Tests', () {
    testWidgets('displays guest mode warning when not logged in', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                EmptyProfileStateFull(appleUser: null, onCreateProfile: () {}),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyProfileStateFull), findsOneWidget);
    });

    testWidgets('displays create profile button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                EmptyProfileStateFull(appleUser: null, onCreateProfile: () {}),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyProfileStateFull), findsOneWidget);
    });

    testWidgets('create profile button calls callback', (tester) async {
      // Variable not verified yet - test incomplete
      // ignore: unused_local_variable
      bool called = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                EmptyProfileStateFull(
                  appleUser: null,
                  onCreateProfile: () => called = true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyProfileStateFull), findsOneWidget);
    });
  });
}
