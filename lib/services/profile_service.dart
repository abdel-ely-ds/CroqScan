import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Profil d'un animal
class AnimalProfile {
  final String name;
  final String animalType; // 'dog', 'cat', 'bird', 'rabbit', 'other'
  final String? breed;
  final int? ageYears;
  final double? weightKg;
  final bool? isNeutered;
  final String? foodType; // 'dry', 'wet', 'mixed'
  final List<String> allergies;
  final String? preferredBrand;
  final List<String> healthGoals;

  AnimalProfile({
    required this.name,
    required this.animalType,
    this.breed,
    this.ageYears,
    this.weightKg,
    this.isNeutered,
    this.foodType,
    this.allergies = const [],
    this.preferredBrand,
    this.healthGoals = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'animalType': animalType,
      'breed': breed,
      'ageYears': ageYears,
      'weightKg': weightKg,
      'isNeutered': isNeutered,
      'foodType': foodType,
      'allergies': allergies,
      'preferredBrand': preferredBrand,
      'healthGoals': healthGoals,
    };
  }

  factory AnimalProfile.fromJson(Map<String, dynamic> json) {
    return AnimalProfile(
      name: json['name'] ?? '',
      animalType: json['animalType'] ?? 'dog',
      breed: json['breed'],
      ageYears: json['ageYears'],
      weightKg: json['weightKg']?.toDouble(),
      isNeutered: json['isNeutered'],
      foodType: json['foodType'],
      allergies: List<String>.from(json['allergies'] ?? []),
      preferredBrand: json['preferredBrand'],
      healthGoals: List<String>.from(json['healthGoals'] ?? []),
    );
  }
}

/// Service de gestion du profil
class ProfileService {
  static const String _profileKey = 'animal_profile';
  static const String _userNameKey = 'user_name';

  /// Sauvegarder le profil de l'animal
  static Future<void> saveProfile(AnimalProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(profile.toJson());
    await prefs.setString(_profileKey, jsonStr);
    print('💾 Profil sauvegardé: ${profile.name}');
  }

  /// Charger le profil de l'animal
  static Future<AnimalProfile?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_profileKey);

      if (jsonStr == null) {
        print('ℹ️ Aucun profil trouvé');
        return null;
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AnimalProfile.fromJson(json);
    } catch (e) {
      print('❌ Erreur chargement profil: $e');
      return null;
    }
  }

  /// Supprimer le profil
  static Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    print('🗑️ Profil supprimé');
  }

  /// Sauvegarder le nom de l'utilisateur
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  /// Charger le nom de l'utilisateur
  static Future<String?> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }
}
