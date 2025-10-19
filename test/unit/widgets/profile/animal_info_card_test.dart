import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/widgets/profile/animal_info_card_full.dart';
import 'package:croq_scan/core/services/profile_service.dart';

void main() {
  group('AnimalInfoCardFull Widget Tests', () {
    testWidgets('displays animal breed', (tester) async {
      final profile = AnimalProfile(
        name: 'Rex',
        animalType: 'dog',
        breed: 'Labrador',
        ageYears: 5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimalInfoCardFull(
              profile: profile,
              buildDetailRow: (icon, label, value) => Text('$label: $value'),
            ),
          ),
        ),
      );

      expect(find.textContaining('Labrador'), findsOneWidget);
    });

    testWidgets('displays age when provided', (tester) async {
      final profile = AnimalProfile(
        name: 'Luna',
        animalType: 'cat',
        ageYears: 3,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimalInfoCardFull(
              profile: profile,
              buildDetailRow: (icon, label, value) => Text('$label: $value'),
            ),
          ),
        ),
      );

      expect(find.textContaining('3'), findsOneWidget);
    });
  });
}
