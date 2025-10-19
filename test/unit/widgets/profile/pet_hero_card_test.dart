import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/pet_hero_card_full.dart';
import 'package:croq_scan/core/services/profile_service.dart';

void main() {
  group('PetHeroCardFull Widget Tests', () {
    testWidgets('displays pet name and type', (tester) async {
      final profile = AnimalProfile(
        name: 'Rex',
        animalType: 'dog',
        breed: 'Labrador',
      );

      String getAnimalEmoji(String type) => type == 'dog' ? '🐕' : '🐈';
      String getAnimalTypeName(String type) => type == 'dog' ? 'Chien' : 'Chat';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PetHeroCardFull(
              profile: profile,
              getAnimalEmoji: getAnimalEmoji,
              getAnimalTypeName: getAnimalTypeName,
            ),
          ),
        ),
      );

      expect(find.text('Rex'), findsOneWidget);
      expect(find.text('🐕 Chien'), findsOneWidget);
      expect(find.text('Labrador'), findsOneWidget);
    });

    testWidgets('handles cat profile correctly', (tester) async {
      final profile = AnimalProfile(name: 'Luna', animalType: 'cat');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PetHeroCardFull(
              profile: profile,
              getAnimalEmoji: (type) => '🐈',
              getAnimalTypeName: (type) => 'Chat',
            ),
          ),
        ),
      );

      expect(find.text('Luna'), findsOneWidget);
      expect(find.text('🐈 Chat'), findsOneWidget);
    });
  });
}
