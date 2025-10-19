import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/profile_content_full.dart';
import 'package:croq_scan/core/services/profile_service.dart';
import 'package:croq_scan/core/services/auth_service.dart';

void main() {
  group('ProfileContentFull Widget Tests', () {
    testWidgets('displays pet hero card', (tester) async {
      final profile = AnimalProfile(
        name: 'Rex',
        animalType: 'dog',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileContentFull(
              profile: profile,
              appleUser: null,
              onLogin: () {},
              onLogout: () {},
            ),
          ),
        ),
      );

      expect(find.text('Rex'), findsOneWidget);
    });

    testWidgets('displays logout button when logged in', (tester) async {
      final profile = AnimalProfile(name: 'Max', animalType: 'dog');
      final user = UserInfo(
        userIdentifier: '123',
        email: 'test@example.com',
        name: 'John',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileContentFull(
              profile: profile,
              appleUser: user,
              onLogin: () {},
              onLogout: () {},
            ),
          ),
        ),
      );

      expect(find.text('Déconnexion'), findsOneWidget);
    });
  });
}

