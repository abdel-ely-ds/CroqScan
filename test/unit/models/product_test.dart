import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  group('Product', () {
    test('creates product with required fields', () {
      final product = Product(
        barcode: '1234567890123',
        name: 'Test Product',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 75,
        suitableFor: [PetType.dog],
        description: 'Test description',
        ingredients: ['Chicken', 'Rice'],
        warnings: [],
        benefits: [],
        nutritionalInfo: NutritionalInfo(
          protein: 25.0,
          fat: 15.0,
          fiber: 3.0,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      expect(product.barcode, '1234567890123');
      expect(product.name, 'Test Product');
      expect(product.brand, 'Test Brand');
      expect(product.healthScore, 75);
      expect(product.suitableFor, contains(PetType.dog));
    });

    test('fromJson creates product correctly', () {
      final json = {
        'barcode': '1234567890123',
        'name': 'Test Product',
        'brand': 'Test Brand',
        'imageUrl': 'https://example.com/image.jpg',
        'healthScore': 80,
        'suitableFor': ['dog', 'cat'],
        'description': 'A great product',
        'ingredients': ['Chicken', 'Rice'],
        'warnings': ['High in sodium'],
        'benefits': ['High protein'],
        'nutritionalInfo': {
          'protein': 30.0,
          'fat': 12.0,
          'fiber': 4.0,
          'moisture': 8.0,
          'ash': 6.0,
        },
      };

      final product = Product.fromJson(json);

      expect(product.barcode, '1234567890123');
      expect(product.name, 'Test Product');
      expect(product.healthScore, 80);
      expect(product.suitableFor.length, 2);
      expect(product.ingredients.length, 2);
      expect(product.nutritionalInfo.protein, 30.0);
    });

    test('toJson serializes product correctly', () {
      final product = Product(
        barcode: '1234567890123',
        name: 'Test Product',
        brand: 'Test Brand',
        imageUrl: 'https://example.com/image.jpg',
        healthScore: 75,
        suitableFor: [PetType.dog],
        description: 'Test description',
        ingredients: ['Chicken'],
        warnings: ['Warning 1'],
        benefits: ['Benefit 1'],
        nutritionalInfo: NutritionalInfo(
          protein: 25.0,
          fat: 15.0,
          fiber: 3.0,
          moisture: 10.0,
          ash: 5.0,
        ),
      );

      final json = product.toJson();

      expect(json['barcode'], '1234567890123');
      expect(json['name'], 'Test Product');
      expect(json['healthScore'], 75);
      expect(json['suitableFor'], ['dog']);
      expect(json['ingredients'], ['Chicken']);
    });

    test('health score calculation produces valid score', () {
      final nutritionalInfo = NutritionalInfo(
        protein: 30.0, // High protein - good
        fat: 15.0, // Moderate fat - good
        fiber: 3.0, // Good fiber
        moisture: 10.0,
        ash: 5.0,
      );

      final ingredients = ['Chicken', 'Rice', 'Salmon']; // Good ingredients

      final json = {
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': ingredients,
      };

      final product = Product.fromJson(json);

      expect(product.healthScore, greaterThanOrEqualTo(0));
      expect(product.healthScore, lessThanOrEqualTo(100));
      // With good nutrition and ingredients, should score well
      expect(product.healthScore, greaterThan(50));
    });

    test('health score penalizes bad ingredients', () {
      final nutritionalInfo = NutritionalInfo(
        protein: 15.0, // Low protein
        fat: 10.0,
        fiber: 2.0,
        moisture: 10.0,
        ash: 5.0,
      );

      final goodIngredients = ['Chicken', 'Salmon'];
      final badIngredients = [
        'Sous-produits animaux',
        'Colorant',
        'Sucre'
      ];

      final productGood = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': goodIngredients,
      });

      final productBad = Product.fromJson({
        'nutritionalInfo': nutritionalInfo.toJson(),
        'ingredients': badIngredients,
      });

      // Product with bad ingredients should score lower
      expect(productBad.healthScore, lessThan(productGood.healthScore));
    });
  });

  group('NutritionalInfo', () {
    test('creates nutritional info correctly', () {
      final info = NutritionalInfo(
        protein: 30.0,
        fat: 15.0,
        fiber: 4.0,
        moisture: 10.0,
        ash: 5.0,
      );

      expect(info.protein, 30.0);
      expect(info.fat, 15.0);
      expect(info.fiber, 4.0);
      expect(info.moisture, 10.0);
      expect(info.ash, 5.0);
    });

    test('fromJson handles missing values', () {
      final info = NutritionalInfo.fromJson({});

      expect(info.protein, 0.0);
      expect(info.fat, 0.0);
      expect(info.fiber, 0.0);
      expect(info.moisture, 0.0);
      expect(info.ash, 0.0);
    });

    test('toJson serializes correctly', () {
      final info = NutritionalInfo(
        protein: 25.0,
        fat: 12.0,
        fiber: 3.5,
        moisture: 8.0,
        ash: 4.5,
      );

      final json = info.toJson();

      expect(json['protein'], 25.0);
      expect(json['fat'], 12.0);
      expect(json['fiber'], 3.5);
      expect(json['moisture'], 8.0);
      expect(json['ash'], 4.5);
    });
  });

  group('PetType', () {
    test('has correct display names', () {
      expect(PetType.dog.displayName, 'Chien');
      expect(PetType.cat.displayName, 'Chat');
      expect(PetType.bird.displayName, 'Oiseau');
      expect(PetType.rabbit.displayName, 'Lapin');
      expect(PetType.other.displayName, 'Autre');
    });

    test('all pet types have unique display names', () {
      final displayNames = PetType.values.map((e) => e.displayName).toSet();
      expect(displayNames.length, PetType.values.length);
    });
  });
}

