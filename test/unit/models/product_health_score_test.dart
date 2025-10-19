import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/models/product.dart';

/// Tests for health score calculation logic
void main() {
  group('Product Health Score Calculation', () {
    test('high protein content increases score', () {
      final highProteinInfo = NutritionalInfo(
        protein: 35.0, // High protein
        fat: 15.0,
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final lowProteinInfo = NutritionalInfo(
        protein: 10.0, // Low protein
        fat: 15.0,
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final productHigh = Product.fromJson({
        'nutritionalInfo': highProteinInfo.toJson(),
        'ingredients': ['Chicken'],
      });

      final productLow = Product.fromJson({
        'nutritionalInfo': lowProteinInfo.toJson(),
        'ingredients': ['Chicken'],
      });

      expect(productHigh.healthScore, greaterThan(productLow.healthScore));
    });

    test('optimal fat range (10-20%) scores best', () {
      final optimalFat = NutritionalInfo(
        protein: 25.0,
        fat: 15.0, // Optimal
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final highFat = NutritionalInfo(
        protein: 25.0,
        fat: 35.0, // Too high
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final productOptimal = Product.fromJson({
        'nutritionalInfo': optimalFat.toJson(),
        'ingredients': [],
      });

      final productHigh = Product.fromJson({
        'nutritionalInfo': highFat.toJson(),
        'ingredients': [],
      });

      expect(productOptimal.healthScore, greaterThan(productHigh.healthScore));
    });

    test('good ingredients boost score', () {
      final nutritionalInfo = NutritionalInfo(
        protein: 20.0,
        fat: 15.0,
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final withGoodIngredients = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': ['Poulet', 'Saumon', 'Viande bio'],
      });

      final withoutGoodIngredients = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': ['Maïs', 'Riz'],
      });

      expect(
        withGoodIngredients.healthScore,
        greaterThan(withoutGoodIngredients.healthScore),
      );
    });

    test('bad ingredients lower score', () {
      final nutritionalInfo = NutritionalInfo(
        protein: 25.0,
        fat: 15.0,
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final noBadIngredients = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': ['Poulet', 'Riz'],
      });

      final withBadIngredients = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': ['Sous-produits animaux', 'Colorant E120', 'Sucre'],
      });

      expect(
        withBadIngredients.healthScore,
        lessThan(noBadIngredients.healthScore),
      );
    });

    test('balanced nutrition gets bonus', () {
      final balanced = NutritionalInfo(
        protein: 28.0, // Good
        fat: 15.0, // Optimal
        fiber: 3.5, // Good
        moisture: 10.0,
        ash: 5.0,
      );

      final unbalanced = NutritionalInfo(
        protein: 12.0, // Low
        fat: 30.0, // Too high
        fiber: 1.0, // Low
        moisture: 10.0,
        ash: 5.0,
      );

      final productBalanced = Product.fromJson({
        'nutritionalInfo': balanced.toJson(),
        'ingredients': [],
      });

      final productUnbalanced = Product.fromJson({
        'nutritionalInfo': unbalanced.toJson(),
        'ingredients': [],
      });

      expect(productBalanced.healthScore, greaterThan(productUnbalanced.healthScore));
    });

    test('score is always between 0 and 100', () {
      // Test extreme cases
      final extremelyGood = NutritionalInfo(
        protein: 40.0,
        fat: 15.0,
        fiber: 4.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final extremelyBad = NutritionalInfo(
        protein: 5.0,
        fat: 50.0,
        fiber: 0.5,
        moisture: 10.0,
        ash: 5.0,
      );

      final productGood = Product.fromJson({
        'nutritionalInfo': extremelyGood.toJson(),
        'ingredients': ['Poulet bio', 'Saumon', 'Viande'],
      });

      final productBad = Product.fromJson({
        'nutritionalInfo': extremelyBad.toJson(),
        'ingredients': ['Sous-produits', 'Colorant', 'Sucre', 'Additifs'],
      });

      expect(productGood.healthScore, greaterThanOrEqualTo(0));
      expect(productGood.healthScore, lessThanOrEqualTo(100));
      expect(productBad.healthScore, greaterThanOrEqualTo(0));
      expect(productBad.healthScore, lessThanOrEqualTo(100));
    });

    test('identical products get same score', () {
      final nutritionalInfo = NutritionalInfo(
        protein: 25.0,
        fat: 15.0,
        fiber: 3.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final product1 = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': ['Poulet', 'Riz'],
      });

      final product2 = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': ['Poulet', 'Riz'],
      });

      expect(product1.healthScore, equals(product2.healthScore));
    });
  });
}

