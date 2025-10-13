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
    return Product(
      barcode: json['barcode'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      healthScore: json['healthScore'] ?? 50,
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
      ingredients: List<String>.from(json['ingredients'] ?? []),
      warnings: List<String>.from(json['warnings'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      nutritionalInfo: NutritionalInfo.fromJson(json['nutritionalInfo'] ?? {}),
    );
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
}
