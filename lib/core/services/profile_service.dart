import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Model representing an animal's profile
/// 
/// Stores essential information about a pet including:
/// - Basic info (name, type, breed)
/// - Physical stats (age, weight)
/// - Health info (neutered status, allergies)
/// - Food preferences
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

/// Service for managing animal profiles
/// 
/// Handles persistence of [AnimalProfile] and user name
/// using [SharedPreferences] for local storage.
/// 
/// Example:
/// ```dart
/// final profile = AnimalProfile(name: 'Rex', animalType: 'dog');
/// await ProfileService.saveProfile(profile);
/// final loaded = await ProfileService.loadProfile();
/// ```
class ProfileService {
  static const String _profileKey = 'animal_profile';
  static const String _userNameKey = 'user_name';

  /// Sauvegarder le profil de l'animal
  static Future<void> saveProfile(AnimalProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(profile.toJson());
    await prefs.setString(_profileKey, jsonStr);
    debugPrint('💾 Profil sauvegardé: ${profile.name}');
  }

  /// Charger le profil de l'animal
  static Future<AnimalProfile?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_profileKey);

      if (jsonStr == null) {
        debugPrint('ℹ️ Aucun profil trouvé');
        return null;
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AnimalProfile.fromJson(json);
    } catch (e) {
      debugPrint('❌ Erreur chargement profil: $e');
      return null;
    }
  }

  /// Supprimer le profil
  static Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    debugPrint('🗑️ Profil supprimé');
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
