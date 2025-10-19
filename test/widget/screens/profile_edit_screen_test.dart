import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/profile_edit_screen.dart';
import 'package:croq_scan/core/services/profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileEditScreen Widget Tests', () {
    testWidgets('displays form fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ProfileEditScreen(profile: null, onSaved: () {})),
      );

      await tester.pumpAndSettle();

      // Vérifie que les champs existent
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(DropdownButton), findsWidgets);
    });

    testWidgets('displays save button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ProfileEditScreen(profile: null, onSaved: () {})),
      );

      await tester.pumpAndSettle();

      expect(find.text('Enregistrer'), findsOneWidget);
    });

    testWidgets('loads existing profile data', (tester) async {
      final profile = AnimalProfile(
        name: 'Rex',
        animalType: 'dog',
        breed: 'Labrador',
      );

      await tester.pumpWidget(
        MaterialApp(home: ProfileEditScreen(profile: profile, onSaved: () {})),
      );

      await tester.pumpAndSettle();

      expect(find.text('Rex'), findsOneWidget);
    });
  });
}
