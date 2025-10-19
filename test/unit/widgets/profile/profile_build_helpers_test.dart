import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/profile_build_helpers.dart';

void main() {
  group('ProfileBuildHelpers Tests', () {
    testWidgets('buildInfoCard creates card', (tester) async {
      final card = ProfileBuildHelpers.buildInfoCard(
        title: 'Test Title',
        icon: Icons.info,
        children: const [Text('Test Content')],
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('buildDetailRow creates row', (tester) async {
      final row = ProfileBuildHelpers.buildDetailRow(
        Icons.person,
        'Name',
        'Rex',
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: row)));

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Rex'), findsOneWidget);
    });

    test('getAnimalEmoji returns correct emoji', () {
      expect(ProfileBuildHelpers.getAnimalEmoji('dog'), '🐕');
      expect(ProfileBuildHelpers.getAnimalEmoji('cat'), '🐈');
      expect(ProfileBuildHelpers.getAnimalEmoji('other'), '🐾');
    });

    test('getAnimalTypeName returns correct name', () {
      expect(ProfileBuildHelpers.getAnimalTypeName('dog'), 'Chien');
      expect(ProfileBuildHelpers.getAnimalTypeName('cat'), 'Chat');
      expect(ProfileBuildHelpers.getAnimalTypeName('bird'), 'Oiseau');
    });

    test('getFoodTypeName returns correct name', () {
      expect(ProfileBuildHelpers.getFoodTypeName('dry'), 'Croquettes');
      expect(ProfileBuildHelpers.getFoodTypeName('wet'), 'Pâtée');
      expect(ProfileBuildHelpers.getFoodTypeName('mixed'), 'Mixte');
    });
  });
}
