import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/profile_header.dart';
import 'package:croq_scan/core/services/profile_service.dart';

void main() {
  group('ProfileHeader Widget Tests', () {
    testWidgets('displays title when no profile', (tester) async {
      // Variables not verified yet - test incomplete
      // ignore: unused_local_variable
      bool refreshCalled = false;
      // ignore: unused_local_variable
      bool editCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              profile: null,
              onRefresh: () => refreshCalled = true,
              onEdit: () => editCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Mon Compte'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsNothing);
      expect(find.byIcon(Icons.edit_rounded), findsNothing);
    });

    testWidgets('displays profile name when profile exists', (tester) async {
      final profile = AnimalProfile(name: 'Rex', animalType: 'dog');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              profile: profile,
              onRefresh: () {},
              onEdit: () {},
            ),
          ),
        ),
      );

      expect(find.text('Rex'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
    });

    testWidgets('refresh button calls callback', (tester) async {
      bool refreshCalled = false;
      final profile = AnimalProfile(name: 'Max', animalType: 'dog');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              profile: profile,
              onRefresh: () => refreshCalled = true,
              onEdit: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pump();

      expect(refreshCalled, isTrue);
    });

    testWidgets('edit button calls callback', (tester) async {
      bool editCalled = false;
      final profile = AnimalProfile(name: 'Luna', animalType: 'cat');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              profile: profile,
              onRefresh: () {},
              onEdit: () => editCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pump();

      expect(editCalled, isTrue);
    });
  });
}
