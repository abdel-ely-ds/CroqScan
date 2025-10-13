import '../models/product.dart';

// Sample product database
class SampleProducts {
  static final List<Product> products = [
    Product(
      barcode: '3017620422003',
      name: 'Premium Adult Dog Food',
      brand: 'PetNutrition',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Dog+Food',
      healthScore: 85,
      suitableFor: [PetType.dog],
      description:
          'High-quality protein-rich food for adult dogs with all essential nutrients.',
      ingredients: [
        'Chicken (40%)',
        'Brown rice',
        'Sweet potato',
        'Peas',
        'Chicken fat',
        'Vitamins & minerals',
      ],
      warnings: [],
      benefits: [
        'High protein content',
        'Natural ingredients',
        'No artificial colors',
        'Supports healthy digestion',
      ],
      nutritionalInfo: NutritionalInfo(
        protein: 28.0,
        fat: 16.0,
        fiber: 4.5,
        moisture: 10.0,
        ash: 7.5,
      ),
    ),
    Product(
      barcode: '3017620422010',
      name: 'Budget Dog Kibble',
      brand: 'EconomyPet',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Budget+Food',
      healthScore: 35,
      suitableFor: [PetType.dog],
      description: 'Economic dog food with basic nutrition.',
      ingredients: [
        'Cereals (60%)',
        'Meat by-products (20%)',
        'Animal fat',
        'Colorants E102, E110',
        'Preservatives',
      ],
      warnings: [
        'Contains artificial colors',
        'High cereal content',
        'Low meat content',
        'May cause allergies',
      ],
      benefits: ['Affordable price'],
      nutritionalInfo: NutritionalInfo(
        protein: 18.0,
        fat: 8.0,
        fiber: 3.0,
        moisture: 12.0,
        ash: 9.0,
      ),
    ),
    Product(
      barcode: '3017620422027',
      name: 'Gourmet Cat Food - Salmon',
      brand: 'FelineFine',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Cat+Food',
      healthScore: 92,
      suitableFor: [PetType.cat],
      description:
          'Premium wet food with real salmon, specially formulated for cats.',
      ingredients: [
        'Salmon (65%)',
        'Fish broth',
        'Rice',
        'Carrots',
        'Taurine',
        'Vitamins & minerals',
      ],
      warnings: [],
      benefits: [
        'Rich in Omega-3',
        'High protein',
        'Contains Taurine',
        'No grains',
        'Supports healthy coat',
      ],
      nutritionalInfo: NutritionalInfo(
        protein: 12.0,
        fat: 6.5,
        fiber: 0.8,
        moisture: 78.0,
        ash: 2.5,
      ),
    ),
    Product(
      barcode: '3017620422034',
      name: 'Bird Seed Mix Premium',
      brand: 'AvianCare',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Bird+Food',
      healthScore: 78,
      suitableFor: [PetType.bird],
      description: 'Nutritious seed mixture for parrots and parakeets.',
      ingredients: [
        'Sunflower seeds',
        'Millet',
        'Canary seed',
        'Oats',
        'Dried fruits',
        'Minerals',
      ],
      warnings: [],
      benefits: [
        'Variety of seeds',
        'Natural ingredients',
        'Rich in vitamins',
        'Supports immune system',
      ],
      nutritionalInfo: NutritionalInfo(
        protein: 14.0,
        fat: 18.0,
        fiber: 12.0,
        moisture: 8.0,
        ash: 4.0,
      ),
    ),
    Product(
      barcode: '3017620422041',
      name: 'Treats with Artificial Colors',
      brand: 'QuickSnack',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Dog+Treats',
      healthScore: 22,
      suitableFor: [PetType.dog, PetType.cat],
      description: 'Colorful pet treats.',
      ingredients: [
        'Wheat flour',
        'Sugar',
        'Meat derivatives',
        'Colorants E102, E110, E124',
        'Preservatives E320',
        'Flavor enhancers',
      ],
      warnings: [
        'High sugar content',
        'Multiple artificial colors',
        'Preservatives',
        'Low nutritional value',
        'May cause hyperactivity',
      ],
      benefits: [],
      nutritionalInfo: NutritionalInfo(
        protein: 8.0,
        fat: 12.0,
        fiber: 2.0,
        moisture: 15.0,
        ash: 6.0,
      ),
    ),
    Product(
      barcode: '3017620422058',
      name: 'Organic Rabbit Pellets',
      brand: 'GreenPet',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Rabbit+Food',
      healthScore: 88,
      suitableFor: [PetType.rabbit],
      description: 'Certified organic pellets for rabbits with timothy hay.',
      ingredients: [
        'Timothy hay (70%)',
        'Organic alfalfa',
        'Organic oats',
        'Dried vegetables',
        'Minerals',
      ],
      warnings: [],
      benefits: [
        'Organic certified',
        'High fiber content',
        'Supports dental health',
        'No artificial additives',
        'Natural ingredients only',
      ],
      nutritionalInfo: NutritionalInfo(
        protein: 14.0,
        fat: 2.5,
        fiber: 25.0,
        moisture: 10.0,
        ash: 8.0,
      ),
    ),
  ];

  // Find product by barcode
  static Product? findByBarcode(String barcode) {
    try {
      return products.firstWhere((p) => p.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  // Search products by name
  static List<Product> search(String query) {
    if (query.isEmpty) return products;
    final lowerQuery = query.toLowerCase();
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.brand.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }
}
