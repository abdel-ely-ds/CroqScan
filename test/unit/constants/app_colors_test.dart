import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/constants/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    test('primary color is defined', () {
      expect(AppColors.primary, isA<Color>());
      expect(AppColors.primary.value, 0xFF9B7EDE);
    });

    test('score colors are defined', () {
      expect(AppColors.scoreExcellent, isA<Color>());
      expect(AppColors.scoreGood, isA<Color>());
      expect(AppColors.scoreMedium, isA<Color>());
      expect(AppColors.scorePoor, isA<Color>());
    });

    test('getScoreColor returns correct color', () {
      expect(AppColors.getScoreColor(90), AppColors.scoreExcellent);
      expect(AppColors.getScoreColor(70), AppColors.scoreGood);
      expect(AppColors.getScoreColor(50), AppColors.scoreMedium);
      expect(AppColors.getScoreColor(30), AppColors.scorePoor);
    });

    test('getScoreLabel returns correct label', () {
      expect(AppColors.getScoreLabel(95), 'Excellent');
      expect(AppColors.getScoreLabel(85), 'Très bon');
      expect(AppColors.getScoreLabel(70), 'Bon');
      expect(AppColors.getScoreLabel(50), 'Moyen');
      expect(AppColors.getScoreLabel(30), 'Médiocre');
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

