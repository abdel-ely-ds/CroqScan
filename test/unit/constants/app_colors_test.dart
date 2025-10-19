import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/constants/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    test('primary color is defined', () {
      expect(AppColors.primary, isA<Color>());
      expect(AppColors.primary, const Color(0xFF9B7EDE));
    });

    test('score colors are defined', () {
      expect(AppColors.scoreExcellent, isA<Color>());
      expect(AppColors.scoreGood, isA<Color>());
      expect(AppColors.scoreMediocre, isA<Color>());
      expect(AppColors.scorePoor, isA<Color>());
    });

    test('getScoreColor returns correct color', () {
      expect(AppColors.getScoreColor(90), AppColors.scoreExcellent);
      expect(AppColors.getScoreColor(70), const Color(0xFF6ECC97)); // Green
      expect(AppColors.getScoreColor(50), const Color(0xFFFFD966)); // Yellow
      expect(
        AppColors.getScoreColor(30),
        const Color(0xFFFFAA7C),
      ); // Light orange
    });

    test('getScoreLabel returns correct label', () {
      expect(AppColors.getScoreLabel(95), 'Excellent');
      expect(AppColors.getScoreLabel(85), 'Excellent');
      expect(AppColors.getScoreLabel(75), 'Excellent');
      expect(AppColors.getScoreLabel(50), 'Bon');
      expect(AppColors.getScoreLabel(30), 'Moyen');
    });

    test('navigation colors are defined', () {
      expect(AppColors.navActive, isA<Color>());
      expect(AppColors.navInactive, isA<Color>());
    });

    test('pastel colors are defined', () {
      expect(AppColors.pastelPeach, isA<Color>());
      expect(AppColors.pastelMint, isA<Color>());
      expect(AppColors.pastelLavender, isA<Color>());
      expect(AppColors.pastelYellow, isA<Color>());
    });
  });
}
