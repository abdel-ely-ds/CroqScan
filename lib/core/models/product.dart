enum PetType {
  dog,
  cat,
  bird,
  rabbit,
  other;

  String get displayName {
    switch (this) {
      case PetType.dog:
        return 'Chien';
      case PetType.cat:
        return 'Chat';
      case PetType.bird:
        return 'Oiseau';
      case PetType.rabbit:
        return 'Lapin';
      case PetType.other:
        return 'Autre';
    }
  }
}

class Product {
  final String barcode;
  final String name;
  final String brand;
  final String imageUrl;
  final int healthScore; // 0-100
  final List<PetType> suitableFor;
  final String description;
  final List<String> ingredients;
  final List<String> warnings;
  final List<String> benefits;
  final NutritionalInfo nutritionalInfo;

  Product({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.healthScore,
    required this.suitableFor,
    required this.description,
    required this.ingredients,
    required this.warnings,
    required this.benefits,
    required this.nutritionalInfo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final nutritionalInfo = NutritionalInfo.fromJson(json['nutritionalInfo'] ?? {});
    final ingredients = List<String>.from(json['ingredients'] ?? []);
    
    return Product(
      barcode: json['barcode'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      healthScore: json['healthScore'] ?? _calculateHealthScore(nutritionalInfo, ingredients),
      suitableFor:
          (json['suitableFor'] as List<dynamic>?)
              ?.map(
                (e) => PetType.values.firstWhere(
                  (type) => type.name == e,
                  orElse: () => PetType.other,
                ),
              )
              .toList() ??
          [],
      description: json['description'] ?? '',
      ingredients: ingredients,
      warnings: List<String>.from(json['warnings'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      nutritionalInfo: nutritionalInfo,
    );
  }

  /// Calculate health score based on nutritional values and ingredients
  /// Score range: 0-100
  static int _calculateHealthScore(NutritionalInfo nutrition, List<String> ingredients) {
    double score = 50.0; // Start with neutral score

    // 1. Protein score (30 points max) - Higher is better for pets
    if (nutrition.protein >= 30) {
      score += 30; // Excellent protein
    } else if (nutrition.protein >= 25) {
      score += 25; // Very good
    } else if (nutrition.protein >= 20) {
      score += 20; // Good
    } else if (nutrition.protein >= 15) {
      score += 15; // Adequate
    } else if (nutrition.protein >= 10) {
      score += 10; // Low
    } else {
      score += 5; // Very low
    }

    // 2. Fat score (15 points max) - Moderate fat is ideal (10-20%)
    if (nutrition.fat >= 10 && nutrition.fat <= 20) {
      score += 15; // Optimal range
    } else if (nutrition.fat >= 8 && nutrition.fat < 10 || nutrition.fat > 20 && nutrition.fat <= 25) {
      score += 10; // Acceptable
    } else if (nutrition.fat >= 5 && nutrition.fat < 8 || nutrition.fat > 25 && nutrition.fat <= 30) {
      score += 5; // Suboptimal
    } else {
      score += 0; // Too low or too high
    }

    // 3. Fiber score (10 points max) - Moderate fiber is good (2-5%)
    if (nutrition.fiber >= 2 && nutrition.fiber <= 5) {
      score += 10; // Optimal
    } else if (nutrition.fiber >= 1 && nutrition.fiber < 2 || nutrition.fiber > 5 && nutrition.fiber <= 8) {
      score += 5; // Acceptable
    } else {
      score += 0; // Too low or too high
    }

    // 4. Ingredients quality (20 points max)
    int badIngredients = 0;
    int goodIngredients = 0;

    for (var ingredient in ingredients) {
      final lower = ingredient.toLowerCase();
      
      // Check for bad ingredients
      if (lower.contains('sous-produit') ||
          lower.contains('by-product') ||
          lower.contains('colorant') ||
          lower.contains('e1') || // Artificial colors
          lower.contains('e2') ||
          lower.contains('e3') ||
          lower.contains('e4') ||
          lower.contains('sucre') ||
          lower.contains('sugar') ||
          lower.contains('additif') ||
          lower.contains('corn syrup') ||
          lower.contains('céréale') && lower.contains('premier') // Grains as first ingredient
      ) {
        badIngredients++;
      }
      
      // Check for good ingredients
      if (lower.contains('poulet') ||
          lower.contains('chicken') ||
          lower.contains('saumon') ||
          lower.contains('salmon') ||
          lower.contains('bio') ||
          lower.contains('organic') ||
          lower.contains('viande') ||
          lower.contains('meat') ||
          lower.contains('dinde') ||
          lower.contains('turkey') ||
          lower.contains('agneau') ||
          lower.contains('lamb') ||
          lower.contains('poisson') ||
          lower.contains('fish')
      ) {
        goodIngredients++;
      }
    }

    // Deduct for bad ingredients
    score -= (badIngredients * 5);
    
    // Add for good ingredients (max +20)
    score += (goodIngredients * 4).clamp(0, 20);

    // 5. Bonus for balanced nutrition
    if (nutrition.protein >= 25 && nutrition.fat >= 10 && nutrition.fat <= 20 && nutrition.fiber >= 2) {
      score += 5; // Bonus for well-balanced formula
    }

    // Ensure score is between 0 and 100
    return score.clamp(0, 100).round();
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'healthScore': healthScore,
      'suitableFor': suitableFor.map((e) => e.name).toList(),
      'description': description,
      'ingredients': ingredients,
      'warnings': warnings,
      'benefits': benefits,
      'nutritionalInfo': nutritionalInfo.toJson(),
    };
  }
}

class NutritionalInfo {
  final double protein; // %
  final double fat; // %
  final double fiber; // %
  final double moisture; // %
  final double ash; // %

  NutritionalInfo({
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.moisture,
    required this.ash,
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      protein: (json['protein'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      moisture: (json['moisture'] ?? 0).toDouble(),
      ash: (json['ash'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'protein': protein,
      'fat': fat,
      'fiber': fiber,
      'moisture': moisture,
      'ash': ash,
    };
  }
}
