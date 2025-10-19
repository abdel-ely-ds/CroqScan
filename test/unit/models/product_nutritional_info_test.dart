import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  group('NutritionalInfo Model Tests', () {
    test('creates nutritional info correctly', () {
      final info = NutritionalInfo(
        protein: 30.0,
        fat: 15.0,
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      expect(info.protein, 30.0);
      expect(info.fat, 15.0);
      expect(info.fiber, 3.0);
      expect(info.moisture, 10.0);
      expect(info.ash, 5.0);
    });

    test('fromJson parses correctly', () {
      final json = {
        'proteins_100g': 30.0,
        'fat_100g': 15.0,
        'fiber_100g': 3.0,
        'moisture_100g': 10.0,
        'ash_100g': 5.0,
      };

      final info = NutritionalInfo.fromJson(json);

      expect(info.protein, 30.0);
      expect(info.fat, 15.0);
    });

    test('handles null values in fromJson', () {
      final json = <String, dynamic>{};
      final info = NutritionalInfo.fromJson(json);

      expect(info.protein, 0.0);
      expect(info.fat, 0.0);
    });
  });
}

