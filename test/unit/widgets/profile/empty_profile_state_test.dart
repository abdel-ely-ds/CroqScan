import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/empty_profile_state_full.dart';
import 'package:croq_scan/core/services/auth_service.dart';

void main() {
  group('EmptyProfileStateFull Widget Tests', () {
    testWidgets('displays guest mode warning when not logged in', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyProfileStateFull(
              appleUser: null,
              onCreateProfile: () {},
            ),
          ),
        ),
      );

      expect(find.text('Mode Invité'), findsOneWidget);
      expect(find.text('🐾'), findsOneWidget);
    });

    testWidgets('displays create profile button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyProfileStateFull(
              appleUser: null,
              onCreateProfile: () {},
            ),
          ),
        ),
      );

      expect(find.text('Créer un profil'), findsOneWidget);
    });

    testWidgets('create profile button calls callback', (tester) async {
      bool called = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyProfileStateFull(
              appleUser: null,
              onCreateProfile: () => called = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Créer un profil'));
      expect(called, isTrue);
    });
  });
}

