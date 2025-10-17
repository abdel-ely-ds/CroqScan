import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class OpenPetFoodFactsService {
  static const String baseUrl =
      'https://world.openpetfoodfacts.org/api/v2/product';

  /// Récupérer un produit par son code-barres depuis l'API OpenPetFoodFacts
  static Future<Product?> fetchProductByBarcode(String barcode) async {
    try {
      print('🌐 Recherche sur OpenPetFoodFacts API: $barcode');

      final url = Uri.parse('$baseUrl/$barcode.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1 && data['product'] != null) {
          print('✅ Produit trouvé sur l\'API!');
          return _parseProduct(data['product'], barcode);
        } else {
          print('❌ Produit non trouvé sur l\'API');
          return null;
        }
      } else {
        print('❌ Erreur API: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la requête API: $e');
      return null;
    }
  }

  /// Parser les données de l'API en objet Product
  static Product _parseProduct(Map<String, dynamic> apiData, String barcode) {
    // Nom du produit
    final productName =
        apiData['product_name_fr'] ??
        apiData['product_name'] ??
        'Produit sans nom';

    // Marque
    final brands = apiData['brands'] ?? 'Marque inconnue';

    // URL de l'image
    final imageUrl = apiData['image_front_url'] ?? apiData['image_url'] ?? '';

    // Catégories et détection du type d'animal
    final categories = apiData['categories'] ?? '';
    final categoriesTags = List<String>.from(apiData['categories_tags'] ?? []);
    final suitableFor = _detectPetTypes(categories, categoriesTags);

    // Ingrédients
    final ingredientsText =
        apiData['ingredients_text_fr'] ?? apiData['ingredients_text'] ?? '';
    final ingredients = _parseIngredients(ingredientsText);

    // Nutriments
    final nutriments = apiData['nutriments'] ?? {};
    final nutritionalInfo = _parseNutritionalInfo(nutriments);

    // Calcul du score de santé
    final healthScore = _calculateHealthScore(
      ingredients,
      ingredientsText,
      nutritionalInfo,
    );

    // Génération des avertissements et avantages
    final warnings = _generateWarnings(ingredientsText, nutritionalInfo);
    final benefits = _generateBenefits(ingredientsText, nutritionalInfo);

    // Description
    final description = _generateDescription(categories, ingredientsText);

    print('   📦 Produit parsé: $productName ($brands)');
    print('   🏷️  Catégories: $categories');
    print(
      '   🐾 Adapté pour: ${suitableFor.map((e) => e.displayName).join(", ")}',
    );
    print('   ⭐ Score calculé: $healthScore');

    return Product(
      barcode: barcode,
      name: productName,
      brand: brands,
      imageUrl: imageUrl,
      healthScore: healthScore,
      suitableFor: suitableFor,
      description: description,
      ingredients: ingredients,
      warnings: warnings,
      benefits: benefits,
      nutritionalInfo: nutritionalInfo,
    );
  }

  /// Détecter les types d'animaux à partir des catégories
  /// Utilise la taxonomie officielle d'OpenPetFoodFacts
  /// Source: https://world.openpetfoodfacts.org/data/taxonomies/categories.json
  static List<PetType> _detectPetTypes(String categories, List<String> tags) {
    final List<PetType> types = [];
    final lowerCategories = categories.toLowerCase();
    final allTags = tags.join(' ').toLowerCase();

    // Catégories pour chiens (Dog food)
    // en:dog-food, en:dog-biscuit, en:dry-dog-food, en:wet-dog-food, etc.
    if (allTags.contains('en:dog-food') ||
        allTags.contains('dog-food') ||
        allTags.contains('en:dog-biscuit') ||
        allTags.contains('en:dry-dog-food') ||
        allTags.contains('en:wet-dog-food') ||
        allTags.contains('en:puppy-food') ||
        lowerCategories.contains('dog') ||
        lowerCategories.contains('chien') ||
        lowerCategories.contains('perro') ||
        lowerCategories.contains('hund')) {
      types.add(PetType.dog);
    }

    // Catégories pour chats (Cat food)
    // en:cat-food, en:adult-cat-food, en:kitten-food, en:dry-cat-food, etc.
    if (allTags.contains('en:cat-food') ||
        allTags.contains('cat-food') ||
        allTags.contains('en:adult-cat-food') ||
        allTags.contains('en:kitten-food') ||
        allTags.contains('en:dry-cat-food') ||
        allTags.contains('en:wet-cat-food') ||
        allTags.contains('en:castrated-cat-food') ||
        allTags.contains('en:senior-cat-food') ||
        lowerCategories.contains('cat') ||
        lowerCategories.contains('chat') ||
        lowerCategories.contains('gato') ||
        lowerCategories.contains('katze')) {
      types.add(PetType.cat);
    }

    // Catégories pour oiseaux (Bird food)
    // en:bird-food
    if (allTags.contains('en:bird-food') ||
        allTags.contains('bird-food') ||
        lowerCategories.contains('bird') ||
        lowerCategories.contains('oiseau') ||
        lowerCategories.contains('pájaro') ||
        lowerCategories.contains('vogel')) {
      types.add(PetType.bird);
    }

    // Catégories pour lapins (Rabbit food)
    // en:rabbit-food
    if (allTags.contains('en:rabbit-food') ||
        allTags.contains('rabbit-food') ||
        lowerCategories.contains('rabbit') ||
        lowerCategories.contains('lapin') ||
        lowerCategories.contains('conejo') ||
        lowerCategories.contains('kaninchen')) {
      types.add(PetType.rabbit);
    }

    print('   🏷️  Tags détectés: ${tags.take(3).join(", ")}${tags.length > 3 ? "..." : ""}');
    print('   🐾 Types détectés: ${types.map((e) => e.displayName).join(", ")}');

    return types.isEmpty ? [PetType.other] : types;
  }

  /// Parser les ingrédients
  static List<String> _parseIngredients(String ingredientsText) {
    if (ingredientsText.isEmpty) {
      return ['Ingrédients non disponibles'];
    }

    final ingredients = ingredientsText
        .split(RegExp(r'[,;.]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(15)
        .toList();

    return ingredients.isEmpty ? ['Ingrédients non disponibles'] : ingredients;
  }

  /// Parser les informations nutritionnelles
  static NutritionalInfo _parseNutritionalInfo(
    Map<String, dynamic> nutriments,
  ) {
    return NutritionalInfo(
      protein: (nutriments['proteins_100g'] ?? 0).toDouble(),
      fat: (nutriments['fat_100g'] ?? 0).toDouble(),
      fiber: (nutriments['fiber_100g'] ?? 0).toDouble(),
      moisture: (nutriments['moisture_100g'] ?? 0).toDouble(),
      ash: (nutriments['ash_100g'] ?? 0).toDouble(),
    );
  }

  /// Calculer le score de santé
  static int _calculateHealthScore(
    List<String> ingredients,
    String ingredientsText,
    NutritionalInfo nutritionalInfo,
  ) {
    int score = 50; // Score de base
    final lowerIngredients = ingredientsText.toLowerCase();

    // Bonus pour les protéines
    if (nutritionalInfo.protein >= 30) {
      score += 15;
    } else if (nutritionalInfo.protein >= 25) {
      score += 10;
    } else if (nutritionalInfo.protein >= 20) {
      score += 5;
    }

    // Bonus pour bio/organic
    if (lowerIngredients.contains('bio') ||
        lowerIngredients.contains('organic')) {
      score += 10;
    }

    // Bonus pour viande de qualité
    if (lowerIngredients.contains('poulet') ||
        lowerIngredients.contains('chicken')) {
      score += 10;
    }
    if (lowerIngredients.contains('saumon') ||
        lowerIngredients.contains('salmon')) {
      score += 10;
    }

    // Malus pour colorants artificiels
    if (RegExp(r'e1[0-9]{2}').hasMatch(lowerIngredients)) {
      score -= 20;
    }

    // Malus pour sous-produits
    if (lowerIngredients.contains('sous-produit') ||
        lowerIngredients.contains('by-product')) {
      score -= 15;
    }

    // Malus pour céréales en début de liste
    if (ingredients.isNotEmpty &&
        (ingredients[0].toLowerCase().contains('céréale') ||
            ingredients[0].toLowerCase().contains('maïs') ||
            ingredients[0].toLowerCase().contains('blé'))) {
      score -= 10;
    }

    // Malus pour sucre
    if (lowerIngredients.contains('sucre') ||
        lowerIngredients.contains('sugar')) {
      score -= 10;
    }

    return score.clamp(0, 100);
  }

  /// Générer les avertissements
  static List<String> _generateWarnings(
    String ingredientsText,
    NutritionalInfo nutritionalInfo,
  ) {
    final List<String> warnings = [];
    final lowerIngredients = ingredientsText.toLowerCase();

    if (RegExp(r'e1[0-9]{2}').hasMatch(lowerIngredients)) {
      warnings.add('Contient des colorants artificiels');
    }

    if (lowerIngredients.contains('sous-produit') ||
        lowerIngredients.contains('by-product')) {
      warnings.add('Contient des sous-produits animaux');
    }

    if (lowerIngredients.contains('céréale') ||
        lowerIngredients.contains('maïs') ||
        lowerIngredients.contains('blé')) {
      warnings.add('Contient des céréales');
    }

    if (nutritionalInfo.protein < 20) {
      warnings.add('Faible teneur en protéines');
    }

    return warnings;
  }

  /// Générer les avantages
  static List<String> _generateBenefits(
    String ingredientsText,
    NutritionalInfo nutritionalInfo,
  ) {
    final List<String> benefits = [];
    final lowerIngredients = ingredientsText.toLowerCase();

    if (lowerIngredients.contains('bio') ||
        lowerIngredients.contains('organic')) {
      benefits.add('Ingrédients biologiques');
    }

    if (!lowerIngredients.contains('céréale') &&
        !lowerIngredients.contains('grain')) {
      benefits.add('Sans céréales');
    }

    if (lowerIngredients.contains('poulet') ||
        lowerIngredients.contains('chicken')) {
      benefits.add('Source de protéines de qualité (poulet)');
    }

    if (lowerIngredients.contains('saumon') ||
        lowerIngredients.contains('salmon')) {
      benefits.add('Riche en Oméga-3 (saumon)');
    }

    if (nutritionalInfo.protein >= 30) {
      benefits.add('Haute teneur en protéines');
    }

    return benefits;
  }

  /// Générer une description
  static String _generateDescription(
    String categories,
    String ingredientsText,
  ) {
    if (ingredientsText.isNotEmpty && ingredientsText.length > 50) {
      return ingredientsText.substring(0, 150) + '...';
    }
    return categories.isNotEmpty ? categories : 'Produit pour animaux';
  }
}
