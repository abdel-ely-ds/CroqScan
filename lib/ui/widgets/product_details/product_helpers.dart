import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/product.dart';

/// Helper methods for product details
class ProductHelpers {
  /// Get color based on health score
  static Color getScoreColor(int score) {
    return AppColors.getScoreColor(score);
  }

  /// Get label based on health score
  static String getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Très bon';
    if (score >= 60) return 'Bon';
    if (score >= 50) return 'Moyen';
    if (score >= 40) return 'Passable';
    if (score >= 30) return 'Médiocre';
    return 'À éviter';
  }

  /// Check if ingredient is problematic
  static bool isProblematicIngredient(String ingredient) {
    final lower = ingredient.toLowerCase();
    return lower.contains('sous-produit') ||
        lower.contains('by-product') ||
        lower.contains('colorant') ||
        lower.contains('e1') ||
        lower.contains('sucre') ||
        lower.contains('sugar') ||
        lower.contains('additif');
  }

  /// Check if ingredient is good
  static bool isGoodIngredient(String ingredient) {
    final lower = ingredient.toLowerCase();
    return lower.contains('poulet') ||
        lower.contains('chicken') ||
        lower.contains('saumon') ||
        lower.contains('salmon') ||
        lower.contains('bio') ||
        lower.contains('organic') ||
        lower.contains('viande') ||
        lower.contains('meat');
  }

  /// Get color for pet type
  static Color getPetColor(PetType petType) {
    switch (petType) {
      case PetType.dog:
        return AppColors.dogColor;
      case PetType.cat:
        return AppColors.catColor;
      case PetType.bird:
        return AppColors.birdColor;
      case PetType.rabbit:
        return AppColors.otherPetColor;
      default:
        return AppColors.textSecondary;
    }
  }

  /// Get emoji for pet type
  static String getPetEmoji(PetType petType) {
    switch (petType) {
      case PetType.dog:
        return '🐶';
      case PetType.cat:
        return '🐱';
      case PetType.bird:
        return '🦜';
      case PetType.rabbit:
        return '🐰';
      default:
        return '🐾';
    }
  }
}
