import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Trustworthy and health-focused
  static const Color primary = Color(0xFF2D9CDB); // Calm blue
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color accent = Color(0xFF56CCF2); // Light blue

  // Product score colors (like Yuka)
  static const Color scoreExcellent = Color(0xFF27AE60); // Green
  static const Color scoreGood = Color(0xFF6FCF97); // Light green
  static const Color scoreMediocre = Color(0xFFF2994A); // Orange
  static const Color scorePoor = Color(0xFFEB5757); // Red

  // UI colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color divider = Color(0xFFE2E8F0);

  // Animal category colors
  static const Color dogColor = Color(0xFFFF6B6B);
  static const Color catColor = Color(0xFF4ECDC4);
  static const Color birdColor = Color(0xFFFFA07A);
  static const Color otherPetColor = Color(0xFF95E1D3);

  // Get color based on score (0-100)
  static Color getScoreColor(int score) {
    if (score >= 75) return scoreExcellent;
    if (score >= 50) return scoreGood;
    if (score >= 25) return scoreMediocre;
    return scorePoor;
  }

  // Get score label
  static String getScoreLabel(int score) {
    if (score >= 75) return 'Excellent';
    if (score >= 50) return 'Bon';
    if (score >= 25) return 'Moyen';
    return 'Mauvais';
  }
}
