import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:croq_scan/core/services/profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileService', () {
    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      // Clear profile before each test
      await ProfileService.deleteProfile();
    });

    test('saveProfile stores and retrieves profile correctly', () async {
      final testProfile = AnimalProfile(
        name: 'Rex',
        animalType: 'dog',
        breed: 'Golden Retriever',
        ageYears: 3,
        weightKg: 30.0,
        isNeutered: true,
      );

      await ProfileService.saveProfile(testProfile);
      final loaded = await ProfileService.loadProfile();

      expect(loaded, isNotNull);
      expect(loaded!.name, 'Rex');
      expect(loaded.animalType, 'dog');
      expect(loaded.breed, 'Golden Retriever');
      expect(loaded.ageYears, 3);
      expect(loaded.weightKg, 30.0);
      expect(loaded.isNeutered, true);
    });

    test('loadProfile returns null when no profile exists', () async {
      await ProfileService.deleteProfile();

      final profile = await ProfileService.loadProfile();

      expect(profile, isNull);
    });

    test('saveUserName stores and retrieves user name', () async {
      const testName = 'John Doe';

      await ProfileService.saveUserName(testName);
      final loaded = await ProfileService.loadUserName();

      expect(loaded, testName);
    });

    test('loadUserName returns null when no name stored', () async {
      await ProfileService.deleteProfile();

      final name = await ProfileService.loadUserName();

      expect(name, isNull);
    });

    test('deleteProfile removes all profile data', () async {
      // Save some data first
      final testProfile = AnimalProfile(name: 'Rex', animalType: 'dog');
      await ProfileService.saveProfile(testProfile);
      await ProfileService.saveUserName('John');

      // Delete profile
      await ProfileService.deleteProfile();

      // Verify profile is cleared (name might still exist)
      final profile = await ProfileService.loadProfile();

      expect(profile, isNull);
    });

    test('AnimalProfile with minimal data', () async {
      final testProfile = AnimalProfile(name: 'Fluffy', animalType: 'cat');

      await ProfileService.saveProfile(testProfile);
      final loaded = await ProfileService.loadProfile();

      expect(loaded, isNotNull);
      expect(loaded!.name, 'Fluffy');
      expect(loaded.animalType, 'cat');
      expect(loaded.breed, isNull);
      expect(loaded.ageYears, isNull);
      expect(loaded.weightKg, isNull);
    });

    test('AnimalProfile handles all optional fields', () async {
      final testProfile = AnimalProfile(
        name: 'Buddy',
        animalType: 'dog',
        breed: 'Mixed',
        ageYears: 5,
        weightKg: 15.5,
        isNeutered: false,
        foodType: 'mixed',
        allergies: ['Wheat'],
        preferredBrand: 'Royal Canin',
        healthGoals: ['Weight management', 'Joint health'],
      );

      await ProfileService.saveProfile(testProfile);
      final loaded = await ProfileService.loadProfile();

      expect(loaded, isNotNull);
      expect(loaded!.foodType, 'mixed');
      expect(loaded.allergies, ['Wheat']);
      expect(loaded.preferredBrand, 'Royal Canin');
      expect(loaded.healthGoals, ['Weight management', 'Joint health']);
    });
  });
}
