import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Warm, playful, and pet-friendly! 🐾
  static const Color primary = Color(0xFFFF6B9D); // Warm pink - love & care
  static const Color primaryDark = Color(0xFFE5568A);
  static const Color accent = Color(0xFFFFA07A); // Warm coral - playful
  static const Color secondary = Color(0xFF7B68EE); // Purple - fun & energetic

  // Navigation colors
  static const Color navActive = Color(0xFFFF6B9D); // Active tab color
  static const Color navInactive = Color(0xFFA7A7A7); // Inactive tab color

  // Product score colors (vibrant and friendly)
  static const Color scoreExcellent = Color(0xFF2ECC71); // Bright green
  static const Color scoreGood = Color(0xFF6FCF97); // Light green
  static const Color scoreMediocre = Color(0xFFFFB84D); // Warm orange
  static const Color scorePoor = Color(0xFFFF6B6B); // Soft red

  // UI colors - Warm and inviting
  static const Color background = Color(0xFFFFF8F5); // Warm white
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color divider = Color(0xFFFFE4E8);

  // Animal category colors - Vibrant and fun!
  static const Color dogColor = Color(0xFFFF8C42); // Warm orange
  static const Color catColor = Color(0xFF9B59B6); // Purple
  static const Color birdColor = Color(0xFF3498DB); // Sky blue
  static const Color otherPetColor = Color(0xFF1ABC9C); // Teal

  // Get color based on score (0-100) with smooth gradient
  static Color getScoreColor(int score) {
    if (score >= 80) return scoreExcellent; // Bright green
    if (score >= 70) return const Color(0xFF4CAF50); // Green
    if (score >= 60) return scoreGood; // Light green
    if (score >= 50) return const Color(0xFFFFC107); // Yellow
    if (score >= 40) return scoreMediocre; // Orange
    if (score >= 30) return const Color(0xFFFF9800); // Dark orange
    if (score >= 20) return const Color(0xFFFF7043); // Light red
    return scorePoor; // Red
  }

  // Get score label
  static String getScoreLabel(int score) {
    if (score >= 75) return 'Excellent';
    if (score >= 50) return 'Bon';
    if (score >= 25) return 'Moyen';
    return 'Mauvais';
  }
}
