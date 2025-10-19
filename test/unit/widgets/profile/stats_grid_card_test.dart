import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/stats_grid_card_full.dart';
import 'package:croq_scan/core/services/profile_service.dart';

void main() {
  group('StatsGridCardFull Widget Tests', () {
    testWidgets('displays type and age when age exists', (tester) async {
      final profile = AnimalProfile(
        name: 'Rex',
        animalType: 'dog',
        ageYears: 5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsGridCardFull(
              profile: profile,
              getAnimalTypeName: (type) => 'Chien',
            ),
          ),
        ),
      );

      expect(find.text('Chien'), findsOneWidget);
      expect(find.text('5 ans'), findsOneWidget);
      expect(find.text('Type'), findsOneWidget);
      expect(find.text('Âge'), findsOneWidget);
    });

    testWidgets('displays type and status when no age', (tester) async {
      final profile = AnimalProfile(
        name: 'Luna',
        animalType: 'cat',
        isNeutered: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatsGridCardFull(
              profile: profile,
              getAnimalTypeName: (type) => 'Chat',
            ),
          ),
        ),
      );

      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Stérilisé'), findsOneWidget);
    });
  });
}
