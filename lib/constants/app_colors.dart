import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Soft, modern, and calming pastels 🌸
  static const Color primary = Color(0xFF9B7EDE); // Soft lavender
  static const Color primaryDark = Color(0xFF8366CC);
  static const Color accent = Color(0xFFFFA8A4); // Soft peach/coral
  static const Color secondary = Color(0xFF89CFF0); // Baby blue

  // Pastel palette for cards and sections
  static const Color pastelPeach = Color(0xFFFFDDD2); // Very light peach
  static const Color pastelMint = Color(0xFFD4F1F4); // Mint green/cyan
  static const Color pastelLavender = Color(0xFFE8DCFF); // Light lavender
  static const Color pastelYellow = Color(0xFFFFF5CD); // Cream yellow
  static const Color pastelPink = Color(0xFFFFE5E5); // Very light pink

  // Navigation colors
  static const Color navActive = Color(0xFF9B7EDE); // Active tab - lavender
  static const Color navInactive = Color(0xFFB0B0B0); // Inactive tab - gray

  // Product score colors (soft and friendly)
  static const Color scoreExcellent = Color(0xFF5EC78C); // Soft green
  static const Color scoreGood = Color(0xFF7DD3A8); // Light green
  static const Color scoreMediocre = Color(0xFFFFC46B); // Soft orange
  static const Color scorePoor = Color(0xFFFF9494); // Soft red

  // UI colors - Clean and modern
  static const Color background = Color(0xFFFAF9F6); // Off-white cream
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color divider = Color(0xFFF0F0F0);

  // Animal category colors - Soft pastels
  static const Color dogColor = Color(0xFFFFB88C); // Soft orange
  static const Color catColor = Color(0xFFB8A4E5); // Soft purple
  static const Color birdColor = Color(0xFF89CFF0); // Baby blue
  static const Color otherPetColor = Color(0xFF7FC7AF); // Soft teal

  // Get color based on score (0-100) with smooth gradient
  static Color getScoreColor(int score) {
    if (score >= 80) return scoreExcellent; // Soft green
    if (score >= 70) return const Color(0xFF6ECC97); // Green
    if (score >= 60) return scoreGood; // Light green
    if (score >= 50) return const Color(0xFFFFD966); // Soft yellow
    if (score >= 40) return scoreMediocre; // Soft orange
    if (score >= 30) return const Color(0xFFFFAA7C); // Light orange
    if (score >= 20) return const Color(0xFFFF9C9C); // Light red
    return scorePoor; // Soft red
  }

  // Get score label
  static String getScoreLabel(int score) {
    if (score >= 75) return 'Excellent';
    if (score >= 50) return 'Bon';
    if (score >= 25) return 'Moyen';
    return 'Mauvais';
  }
}
