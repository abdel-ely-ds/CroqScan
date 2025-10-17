import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../widgets/score_badge.dart';
import 'product_details_screen.dart';

class SearchScreenNew extends StatefulWidget {
  const SearchScreenNew({super.key});

  @override
  State<SearchScreenNew> createState() => _SearchScreenNewState();
}

class _SearchScreenNewState extends State<SearchScreenNew> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // État de la recherche
  String? _selectedMainCategory;
  final Set<String> _selectedSubCategories = {};
  bool _isLoading = false;
  bool _isLoadingMore = false;
  List<Product> _searchResults = [];
  int _currentPage = 1;
  int _totalResults = 0;
  bool _hasMoreResults = false;

  // Catégories principales
  final Map<String, MainCategory> _mainCategories = {
    'dog-food': MainCategory(
      id: 'dog-food',
      name: 'Chiens',
      icon: '🐶',
      color: Color(0xFF4A90E2),
      subCategories: [
        SubCategory(tag: 'en:dry-dog-food', name: 'Croquettes'),
        SubCategory(tag: 'en:wet-dog-food', name: 'Pâtées'),
        SubCategory(tag: 'en:dog-treats', name: 'Friandises'),
      ],
    ),
    'cat-food': MainCategory(
      id: 'cat-food',
      name: 'Chats',
      icon: '🐱',
      color: Color(0xFFFF6B9D),
      subCategories: [
        SubCategory(tag: 'en:dry-cat-food', name: 'Croquettes'),
        SubCategory(tag: 'en:wet-cat-food', name: 'Pâtées'),
        SubCategory(tag: 'en:cat-treats', name: 'Friandises'),
      ],
    ),
    'bird-food': MainCategory(
      id: 'bird-food',
      name: 'Oiseaux',
      icon: '🦜',
      color: Colors.orange,
      subCategories: [SubCategory(tag: 'en:bird-food', name: 'Graines')],
    ),
    'small-animal-food': MainCategory(
      id: 'small-animal-food',
      name: 'Petits animaux',
      icon: '🐰',
      color: Colors.brown,
      subCategories: [SubCategory(tag: 'en:rabbit-food', name: 'Lapins')],
    ),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  /// Lancer la recherche
  Future<void> _performSearch() async {
    // Vérifier qu'au moins un critère est sélectionné
    if (_searchController.text.isEmpty &&
        _selectedMainCategory == null &&
        _selectedSubCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Sélectionnez au moins un critère de recherche'),
              ),
            ],
          ),
          backgroundColor: AppColors.scoreMediocre,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _searchResults = [];
      _currentPage = 1;
      _isLoading = true;
    });

    await _loadResults();
  }

  /// Charger les résultats depuis l'API
  Future<void> _loadResults() async {
    try {
      print('🔍 Recherche OpenPetFoodFacts');
      print('   ━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      if (_searchController.text.isNotEmpty) {
        print('   🔤 Recherche textuelle: "${_searchController.text}"');
        print(
          '      → Paramètre API: search_terms="${_searchController.text}"',
        );
      }

      if (_selectedMainCategory != null) {
        print('   🏷️  Catégorie principale: $_selectedMainCategory');
      }
      if (_selectedSubCategories.isNotEmpty) {
        final cleanedTags = _selectedSubCategories
            .map((tag) => tag.replaceFirst('en:', ''))
            .join(', ');
        print('   🏷️  Sous-catégories: $cleanedTags');
      }

      print('   📄 Page: $_currentPage / 20 produits par page');

      // Construire l'URL
      final baseUrl = 'https://world.openpetfoodfacts.org/api/v2/search';
      final params = <String, String>{
        'page': _currentPage.toString(),
        'page_size': '20',
        'sort_by': 'unique_scans_n',
        'fields':
            'code,product_name,product_name_fr,brands,categories,categories_tags,image_front_url,image_front_small_url,nutriments,ingredients_text_fr',
        'json': '1',
      };

      // Recherche textuelle
      if (_searchController.text.isNotEmpty) {
        params['search_terms'] = _searchController.text;
      }

      // Filtres de catégories
      // Construire la liste de toutes les catégories à rechercher
      final List<String> allCategoriesToSearch = [];

      if (_selectedSubCategories.isNotEmpty) {
        // Si des sous-catégories sont sélectionnées, utiliser uniquement celles-ci
        final cleanedTags = _selectedSubCategories
            .map((tag) => tag.replaceFirst('en:', ''))
            .toList();
        allCategoriesToSearch.addAll(cleanedTags);
      } else if (_selectedMainCategory != null) {
        // Sinon, utiliser la catégorie principale seule
        allCategoriesToSearch.add(_selectedMainCategory!);
      }

      // Utiliser categories_tags directement (méthode simple et efficace)
      if (allCategoriesToSearch.length == 1) {
        // Une seule catégorie : utiliser categories_tags directement
        params['categories_tags'] = allCategoriesToSearch.first;
      } else if (allCategoriesToSearch.length > 1) {
        // Plusieurs catégories : utiliser tag_contains_0=contains_any
        params['tagtype_0'] = 'categories';
        params['tag_contains_0'] = 'contains_any';
        params['tag_0'] = allCategoriesToSearch.join(',');
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: params);
      print('   ━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('   📡 URL construite:');
      print('   $uri');
      print('   ━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        final int count = data['count'] ?? 0;

        print('');
        print('✅ Réponse de l\'API:');
        print('   📦 ${products.length} produits reçus sur cette page');
        print('   📊 Total dans la base: $count produits');
        print('   📄 Page actuelle: $_currentPage');

        final List<Product> parsedProducts = [];
        for (var productData in products) {
          try {
            final product = _parseProduct(productData);
            if (product != null) {
              parsedProducts.add(product);
            }
          } catch (e) {
            // Ignorer les produits mal formés
          }
        }

        print('');
        print('📦 Parsing des produits:');
        print('   ✅ ${parsedProducts.length} produits parsés avec succès');
        print(
          '   📋 Ajout à la liste existante: ${_searchResults.length} produits',
        );

        setState(() {
          if (_currentPage == 1) {
            _searchResults = parsedProducts;
          } else {
            _searchResults.addAll(parsedProducts);
          }
          _totalResults = count;
          _hasMoreResults = (_currentPage * 20) < count;
          _isLoading = false;
          _isLoadingMore = false;
        });

        print('');
        print('✅ RÉSULTAT FINAL:');
        print('   📊 ${_searchResults.length} produits dans la liste');
        print('   🔄 Plus de résultats disponibles: $_hasMoreResults');
        print('   ━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      } else {
        print('❌ Erreur HTTP: ${response.statusCode}');
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      print('❌ Erreur: $e');
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMoreResults || _isLoadingMore) {
      print(
        '⏸️ Chargement ignoré: hasMore=$_hasMoreResults, isLoadingMore=$_isLoadingMore',
      );
      return;
    }

    print('📥 Chargement de la page suivante...');
    setState(() {
      _currentPage++;
      _isLoadingMore = true;
    });
    await _loadResults();
  }

  Product? _parseProduct(Map<String, dynamic> data) {
    try {
      final code = data['code'] ?? '';
      final name = data['product_name_fr'] ?? data['product_name'] ?? 'Produit';
      final brand = data['brands'] ?? 'Marque inconnue';
      final imageUrl =
          data['image_front_small_url'] ?? data['image_front_url'] ?? '';

      final categories = data['categories'] ?? '';
      final categoriesTagsRaw = data['categories_tags'] ?? [];
      final categoriesTags = categoriesTagsRaw is List
          ? categoriesTagsRaw.map((e) => e.toString()).toList()
          : <String>[];

      final suitableFor = _detectPetTypes(categories, categoriesTags);

      final ingredientsText = data['ingredients_text_fr'] ?? '';
      final ingredients = ingredientsText.isNotEmpty
          ? ingredientsText
                .split(RegExp(r'[,;.]'))
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .take(15)
                .toList()
          : ['Ingrédients non disponibles'];

      final nutriments = data['nutriments'] ?? {};
      final nutritionalInfo = NutritionalInfo(
        protein: _parseNutrient(nutriments['proteins_100g']),
        fat: _parseNutrient(nutriments['fat_100g']),
        fiber: _parseNutrient(nutriments['fiber_100g']),
        moisture: _parseNutrient(nutriments['moisture_100g']),
        ash: _parseNutrient(nutriments['ash_100g']),
      );

      int score = 50;
      if (nutritionalInfo.protein >= 30)
        score += 15;
      else if (nutritionalInfo.protein >= 25)
        score += 10;
      final lowerIng = ingredientsText.toLowerCase();
      if (lowerIng.contains('bio')) score += 10;
      if (lowerIng.contains('poulet') || lowerIng.contains('chicken'))
        score += 10;
      score = score.clamp(0, 100);

      return Product(
        barcode: code,
        name: name,
        brand: brand,
        imageUrl: imageUrl,
        healthScore: score,
        suitableFor: suitableFor,
        description: categories,
        ingredients: ingredients,
        warnings: [],
        benefits: [],
        nutritionalInfo: nutritionalInfo,
      );
    } catch (e) {
      return null;
    }
  }

  double _parseNutrient(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  List<PetType> _detectPetTypes(String categories, List<String> tags) {
    final List<PetType> types = [];
    final allTags = tags.join(' ').toLowerCase();
    final lowerCat = categories.toLowerCase();

    if (allTags.contains('cat-food') || lowerCat.contains('chat'))
      types.add(PetType.cat);
    if (allTags.contains('dog-food') || lowerCat.contains('chien'))
      types.add(PetType.dog);
    if (allTags.contains('bird-food') || lowerCat.contains('oiseau'))
      types.add(PetType.bird);
    if (allTags.contains('rabbit-food') || lowerCat.contains('lapin'))
      types.add(PetType.rabbit);

    return types.isEmpty ? [PetType.other] : types;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rechercher',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_selectedMainCategory != null ||
              _selectedSubCategories.isNotEmpty ||
              _searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedMainCategory = null;
                  _selectedSubCategories.clear();
                  _searchResults = [];
                  _totalResults = 0;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche et filtres COMPACTS
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barre de recherche
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Nom, marque ou mot-clé...',
                    hintStyle: TextStyle(fontSize: 15),
                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 20),
                            onPressed: () =>
                                setState(() => _searchController.clear()),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),

                SizedBox(height: 12),

                // Catégories principales (horizontal scroll)
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _mainCategories.entries.map((entry) {
                      final isSelected = _selectedMainCategory == entry.key;
                      final cat = entry.value;

                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedMainCategory = null;
                                _selectedSubCategories.clear();
                              } else {
                                _selectedMainCategory = entry.key;
                                _selectedSubCategories.clear();
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        cat.color,
                                        cat.color.withOpacity(0.7),
                                      ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : cat.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected
                                    ? cat.color
                                    : cat.color.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cat.icon, style: TextStyle(fontSize: 20)),
                                SizedBox(width: 6),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : cat.color,
                                    fontSize: 14,
                                  ),
                                ),
                                if (isSelected) ...[
                                  SizedBox(width: 6),
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Sous-catégories si une catégorie principale est sélectionnée
                if (_selectedMainCategory != null) ...[
                  SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _mainCategories[_selectedMainCategory]!
                          .subCategories
                          .map((subCat) {
                            final isSelected = _selectedSubCategories.contains(
                              subCat.tag,
                            );
                            final color =
                                _mainCategories[_selectedMainCategory]!.color;

                            return Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedSubCategories.remove(subCat.tag);
                                    } else {
                                      _selectedSubCategories.add(subCat.tag);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? color
                                        : color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected
                                          ? color
                                          : color.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        subCat.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.white
                                              : color,
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                ],

                SizedBox(height: 12),

                // Bouton de recherche
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            'Rechercher',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Résultats (prend tout l'espace restant)
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_searchResults.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    if (_searchResults.isEmpty && _isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Header résultats
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.inventory_2, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                '$_totalResults produit${_totalResults > 1 ? 's' : ''} trouvé${_totalResults > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Liste scrollable
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            itemCount: _searchResults.length + (_hasMoreResults ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _searchResults.length) {
                // Indicateur de chargement en bas
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Chargement...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return _buildProductCard(_searchResults[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔍', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'Prêt à rechercher',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sélectionnez une catégorie ou\nsaisissez un mot-clé',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Image ou score
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            ScoreBadge(score: product.healthScore, size: 70),
                      )
                    : ScoreBadge(score: product.healthScore, size: 70),
              ),

              SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.brand,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: product.suitableFor.map((pet) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getPetColor(pet).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            pet.displayName,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getPetColor(pet),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPetColor(PetType petType) {
    switch (petType) {
      case PetType.dog:
        return Color(0xFF4A90E2);
      case PetType.cat:
        return Color(0xFFFF6B9D);
      case PetType.bird:
        return Colors.orange;
      case PetType.rabbit:
        return Colors.brown;
      default:
        return AppColors.textSecondary;
    }
  }
}

class MainCategory {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final List<SubCategory> subCategories;

  MainCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.subCategories,
  });
}

class SubCategory {
  final String tag;
  final String name;

  SubCategory({required this.tag, required this.name});
}
