import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductService {
  static List<Product>? _cachedProducts;
  static bool _isLoading = false;

  /// Load products from the JSONL file
  static Future<List<Product>> loadProducts() async {
    // Return cached products if already loaded
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    // Prevent multiple simultaneous loads
    if (_isLoading) {
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedProducts ?? [];
    }

    _isLoading = true;

    try {
      print('📁 Chargement du fichier JSONL...');

      // Load JSONL file
      final String jsonlContent = await rootBundle.loadString(
        'assets/openpetfoodfacts-products.jsonl',
      );

      print('📄 Fichier chargé, parsing...');

      // Parse each line as JSON
      final List<String> lines = jsonlContent.split('\n');
      final List<Product> products = [];
      int successCount = 0;
      int skipCount = 0;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().isEmpty) continue;

        try {
          final Map<String, dynamic> json = jsonDecode(line);
          final product = _parseProduct(json);
          if (product != null) {
            products.add(product);
            successCount++;

            // Log first few products for debugging
            if (successCount <= 3) {
              print(
                '  ✓ Produit $successCount: ${product.name} (${product.brand})',
              );
            }
          } else {
            skipCount++;
          }
        } catch (e) {
          // Skip malformed lines
          skipCount++;
          if (skipCount <= 3) {
            print(
              '  ✗ Ligne ${i + 1} ignorée: ${e.toString().substring(0, 50)}...',
            );
          }
          continue;
        }
      }

      print(
        '✅ Parsing terminé: $successCount produits parsés, $skipCount ignorés',
      );

      _cachedProducts = products;
      _isLoading = false;
      return products;
    } catch (e) {
      print('❌ Erreur lors du chargement: $e');
      _isLoading = false;
      return [];
    }
  }

  /// Parse a product from OpenPetFoodFacts JSON
  static Product? _parseProduct(Map<String, dynamic> json) {
    try {
      // Extract basic info
      final String? code = json['code'];
      if (code == null || code.isEmpty) return null;

      final String name =
          json['product_name_fr'] ??
          json['product_name'] ??
          json['product_name_en'] ??
          '';

      if (name.isEmpty) return null;

      final String brand = json['brands'] ?? 'Marque inconnue';

      // Determine pet type from categories
      List<PetType> suitableFor = _determinePetTypes(json);
      // Accept products even without specific pet type, classify as "other"
      if (suitableFor.isEmpty) {
        suitableFor = [PetType.other];
      }

      // Calculate health score based on available data
      final int healthScore = _calculateHealthScore(json);

      // Extract ingredients
      final String ingredientsText =
          json['ingredients_text_fr'] ??
          json['ingredients_text'] ??
          json['ingredients_text_en'] ??
          '';

      final List<String> ingredients = _extractIngredients(ingredientsText);

      // Extract nutritional info
      final nutritionalInfo = _extractNutritionalInfo(json);

      // Generate warnings and benefits
      final warnings = _generateWarnings(json, ingredientsText);
      final benefits = _generateBenefits(json, healthScore);

      // Build description
      final String description = _buildDescription(json, suitableFor);

      return Product(
        barcode: code,
        name: name,
        brand: brand,
        imageUrl: '',
        healthScore: healthScore,
        suitableFor: suitableFor,
        description: description,
        ingredients: ingredients,
        warnings: warnings,
        benefits: benefits,
        nutritionalInfo: nutritionalInfo,
      );
    } catch (e) {
      return null;
    }
  }

  /// Determine which pets the product is suitable for
  static List<PetType> _determinePetTypes(Map<String, dynamic> json) {
    final List<PetType> types = [];
    final List<dynamic> categoriesTags = json['categories_tags'] ?? [];
    final String categoriesStr = categoriesTags.join(' ').toLowerCase();

    if (categoriesStr.contains('dog')) {
      types.add(PetType.dog);
    }
    if (categoriesStr.contains('cat')) {
      types.add(PetType.cat);
    }
    if (categoriesStr.contains('bird')) {
      types.add(PetType.bird);
    }
    if (categoriesStr.contains('rabbit')) {
      types.add(PetType.rabbit);
    }

    return types;
  }

  /// Calculate health score based on available data
  static int _calculateHealthScore(Map<String, dynamic> json) {
    int score = 50; // Base score

    final Map<String, dynamic> nutriments = json['nutriments'] ?? {};
    final String ingredientsText =
        (json['ingredients_text_fr'] ??
                json['ingredients_text'] ??
                json['ingredients_text_en'] ??
                '')
            .toLowerCase();

    // Positive factors
    if (nutriments['proteins_100g'] != null) {
      final double protein = (nutriments['proteins_100g'] as num).toDouble();
      if (protein >= 30)
        score += 15;
      else if (protein >= 25)
        score += 10;
      else if (protein >= 20)
        score += 5;
    }

    if (ingredientsText.contains('bio') ||
        ingredientsText.contains('organic')) {
      score += 10;
    }

    if (ingredientsText.contains('poulet') ||
        ingredientsText.contains('chicken') ||
        ingredientsText.contains('saumon') ||
        ingredientsText.contains('salmon')) {
      score += 10;
    }

    // Negative factors
    if (ingredientsText.contains('e102') ||
        ingredientsText.contains('e110') ||
        ingredientsText.contains('e124') ||
        ingredientsText.contains('colorant')) {
      score -= 20;
    }

    if (ingredientsText.contains('sous-produit') ||
        ingredientsText.contains('by-product')) {
      score -= 15;
    }

    if (ingredientsText.contains('céréale') &&
        !ingredientsText.contains('sans céréale')) {
      final bool highCereal =
          ingredientsText.indexOf('céréale') < ingredientsText.length / 3;
      if (highCereal) score -= 10;
    }

    if (ingredientsText.contains('sucre') ||
        ingredientsText.contains('sugar')) {
      score -= 10;
    }

    // Clamp score between 0 and 100
    return score.clamp(0, 100);
  }

  /// Extract ingredients list
  static List<String> _extractIngredients(String ingredientsText) {
    if (ingredientsText.isEmpty) return ['Ingrédients non disponibles'];

    // Split by common separators
    final List<String> ingredients = ingredientsText
        .split(RegExp(r'[,;.]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.length > 2)
        .take(15) // Limit to first 15 ingredients
        .toList();

    return ingredients.isNotEmpty
        ? ingredients
        : ['Ingrédients non disponibles'];
  }

  /// Extract nutritional information
  static NutritionalInfo _extractNutritionalInfo(Map<String, dynamic> json) {
    final Map<String, dynamic> nutriments = json['nutriments'] ?? {};

    return NutritionalInfo(
      protein: (nutriments['proteins_100g'] ?? 0).toDouble(),
      fat: (nutriments['fat_100g'] ?? 0).toDouble(),
      fiber: (nutriments['fiber_100g'] ?? 0).toDouble(),
      moisture: (nutriments['moisture_100g'] ?? 0).toDouble(),
      ash: (nutriments['ash_100g'] ?? 0).toDouble(),
    );
  }

  /// Generate warnings based on ingredients
  static List<String> _generateWarnings(
    Map<String, dynamic> json,
    String ingredientsText,
  ) {
    final List<String> warnings = [];
    final String lowerIngredients = ingredientsText.toLowerCase();

    if (lowerIngredients.contains('e102') ||
        lowerIngredients.contains('e110') ||
        lowerIngredients.contains('e124') ||
        lowerIngredients.contains('colorant')) {
      warnings.add('Contient des colorants artificiels');
    }

    if (lowerIngredients.contains('sous-produit') ||
        lowerIngredients.contains('by-product')) {
      warnings.add('Contient des sous-produits de viande');
    }

    if (lowerIngredients.contains('céréale') &&
        !lowerIngredients.contains('sans céréale')) {
      warnings.add('Contient des céréales');
    }

    if (lowerIngredients.contains('sucre') ||
        lowerIngredients.contains('sugar')) {
      warnings.add('Contient du sucre ajouté');
    }

    if (lowerIngredients.contains('conservateur') ||
        lowerIngredients.contains('preservative')) {
      warnings.add('Contient des conservateurs');
    }

    final Map<String, dynamic> nutriments = json['nutriments'] ?? {};
    if (nutriments['proteins_100g'] != null) {
      final double protein = (nutriments['proteins_100g'] as num).toDouble();
      if (protein < 20) {
        warnings.add('Faible teneur en protéines (< 20%)');
      }
    }

    return warnings;
  }

  /// Generate benefits based on ingredients and score
  static List<String> _generateBenefits(Map<String, dynamic> json, int score) {
    final List<String> benefits = [];
    final String ingredientsText =
        (json['ingredients_text_fr'] ??
                json['ingredients_text'] ??
                json['ingredients_text_en'] ??
                '')
            .toLowerCase();

    final Map<String, dynamic> nutriments = json['nutriments'] ?? {};

    if (ingredientsText.contains('bio') ||
        ingredientsText.contains('organic')) {
      benefits.add('Ingrédients biologiques');
    }

    if (ingredientsText.contains('sans céréale') ||
        ingredientsText.contains('grain-free')) {
      benefits.add('Sans céréales');
    }

    if (ingredientsText.contains('poulet') ||
        ingredientsText.contains('chicken')) {
      benefits.add('Source de protéines de poulet');
    }

    if (ingredientsText.contains('saumon') ||
        ingredientsText.contains('salmon')) {
      benefits.add('Riche en Oméga-3 (saumon)');
    }

    if (nutriments['proteins_100g'] != null) {
      final double protein = (nutriments['proteins_100g'] as num).toDouble();
      if (protein >= 30) {
        benefits.add('Riche en protéines (${protein.toStringAsFixed(1)}%)');
      }
    }

    if (score >= 75 && benefits.isEmpty) {
      benefits.add('Produit de bonne qualité');
    }

    return benefits;
  }

  /// Build product description
  static String _buildDescription(
    Map<String, dynamic> json,
    List<PetType> suitableFor,
  ) {
    final String categories = json['categories'] ?? '';

    if (categories.isNotEmpty) {
      return categories;
    }

    final petNames = suitableFor
        .map((p) => p.displayName.toLowerCase())
        .join(', ');
    return 'Produit pour $petNames';
  }

  /// Search products
  static List<Product> searchProducts(
    List<Product> products,
    String query, {
    PetType? petFilter,
  }) {
    print('🔍 ProductService.searchProducts appelé');
    print('   - ${products.length} produits en entrée');
    print('   - query: "$query"');
    print('   - petFilter: $petFilter');

    List<Product> filtered = products;

    // Filter by pet type
    if (petFilter != null) {
      filtered = filtered
          .where((p) => p.suitableFor.contains(petFilter))
          .toList();
      print('   - Après filtre animal: ${filtered.length} produits');
    }

    // Filter by search query
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered
          .where(
            (p) =>
                p.name.toLowerCase().contains(lowerQuery) ||
                p.brand.toLowerCase().contains(lowerQuery) ||
                p.description.toLowerCase().contains(lowerQuery) ||
                p.ingredients.any((i) => i.toLowerCase().contains(lowerQuery)),
          )
          .toList();
      print('   - Après recherche texte: ${filtered.length} produits');
    }

    print('   ✅ Retourne ${filtered.length} résultats');
    return filtered;
  }

  /// Find product by barcode
  static Product? findProductByBarcode(List<Product> products, String barcode) {
    try {
      return products.firstWhere((p) => p.barcode == barcode);
    } catch (e) {
      return null;
    }
  }
}
