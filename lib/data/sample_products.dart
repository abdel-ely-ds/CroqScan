import '../models/product.dart';

// Base de données de produits d'exemple
class SampleProducts {
  static final List<Product> products = [
    Product(
      barcode: '3017620422003',
      name: 'Croquettes Premium Adulte Chien',
      brand: 'NutriAnimal',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Croquettes+Chien',
      healthScore: 85,
      suitableFor: [PetType.dog],
      description:
          'Alimentation riche en protéines de haute qualité pour chiens adultes avec tous les nutriments essentiels.',
      ingredients: [
        'Poulet (40%)',
        'Riz brun',
        'Patate douce',
        'Petits pois',
        'Graisse de poulet',
        'Vitamines et minéraux',
      ],
      warnings: [],
      benefits: [
        'Teneur élevée en protéines',
        'Ingrédients naturels',
        'Sans colorants artificiels',
        'Favorise une digestion saine',
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
      name: 'Croquettes Économiques Chien',
      brand: 'ÉconoAnimal',
      imageUrl:
          'https://via.placeholder.com/300x300.png?text=Croquettes+Budget',
      healthScore: 35,
      suitableFor: [PetType.dog],
      description: 'Alimentation économique pour chien avec nutrition de base.',
      ingredients: [
        'Céréales (60%)',
        'Sous-produits de viande (20%)',
        'Graisse animale',
        'Colorants E102, E110',
        'Conservateurs',
      ],
      warnings: [
        'Contient des colorants artificiels',
        'Teneur élevée en céréales',
        'Faible teneur en viande',
        'Peut causer des allergies',
      ],
      benefits: ['Prix abordable'],
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
      name: 'Pâtée Gourmet Chat - Saumon',
      brand: 'ChatFin',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Patee+Chat',
      healthScore: 92,
      suitableFor: [PetType.cat],
      description:
          'Pâtée premium au vrai saumon, spécialement formulée pour les chats.',
      ingredients: [
        'Saumon (65%)',
        'Bouillon de poisson',
        'Riz',
        'Carottes',
        'Taurine',
        'Vitamines et minéraux',
      ],
      warnings: [],
      benefits: [
        'Riche en Oméga-3',
        'Haute teneur en protéines',
        'Contient de la taurine',
        'Sans céréales',
        'Favorise un pelage sain',
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
      name: 'Mélange de Graines Premium Oiseaux',
      brand: 'AviSoin',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Graines+Oiseaux',
      healthScore: 78,
      suitableFor: [PetType.bird],
      description: 'Mélange nutritif de graines pour perroquets et perruches.',
      ingredients: [
        'Graines de tournesol',
        'Millet',
        'Alpiste',
        'Avoine',
        'Fruits séchés',
        'Minéraux',
      ],
      warnings: [],
      benefits: [
        'Variété de graines',
        'Ingrédients naturels',
        'Riche en vitamines',
        'Renforce le système immunitaire',
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
      name: 'Friandises aux Colorants Artificiels',
      brand: 'RapideSnack',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Friandises+Chien',
      healthScore: 22,
      suitableFor: [PetType.dog, PetType.cat],
      description: 'Friandises colorées pour animaux.',
      ingredients: [
        'Farine de blé',
        'Sucre',
        'Dérivés de viande',
        'Colorants E102, E110, E124',
        'Conservateurs E320',
        'Exhausteurs de goût',
      ],
      warnings: [
        'Teneur élevée en sucre',
        'Multiples colorants artificiels',
        'Conservateurs chimiques',
        'Faible valeur nutritionnelle',
        'Peut causer de l\'hyperactivité',
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
      name: 'Granulés Bio Lapin',
      brand: 'VertAnimal',
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Granules+Lapin',
      healthScore: 88,
      suitableFor: [PetType.rabbit],
      description:
          'Granulés certifiés biologiques pour lapins avec foin de timothy.',
      ingredients: [
        'Foin de timothy (70%)',
        'Luzerne biologique',
        'Avoine biologique',
        'Légumes séchés',
        'Minéraux',
      ],
      warnings: [],
      benefits: [
        'Certifié biologique',
        'Riche en fibres',
        'Favorise la santé dentaire',
        'Sans additifs artificiels',
        'Ingrédients naturels uniquement',
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

  // Trouver un produit par code-barres
  static Product? findByBarcode(String barcode) {
    try {
      return products.firstWhere((p) => p.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  // Rechercher des produits par nom
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
