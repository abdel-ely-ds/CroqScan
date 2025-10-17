import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/products_provider.dart';
import '../services/product_service.dart';
import 'product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  PetType? _selectedPetFilter;
  List<Product> _allProducts = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔄 didChangeDependencies appelé');
    final provider = ProductsProvider.of(context);
    print('   Provider: ${provider != null ? "trouvé" : "NULL"}');
    if (provider != null) {
      print('   Provider a ${provider.products.length} produits');
    }
    print('   _allProducts.length actuel: ${_allProducts.length}');

    if (provider != null && _allProducts.isEmpty) {
      _allProducts = provider.products;
      _searchResults = _allProducts;
      print('✅ SearchScreen initialisé avec ${_allProducts.length} produits');
      print('   _searchResults.length = ${_searchResults.length}');

      // Log quelques produits pour vérifier
      if (_allProducts.length > 0) {
        print('   Exemples de produits:');
        for (int i = 0; i < _allProducts.length && i < 3; i++) {
          print(
            '     ${i + 1}. ${_allProducts[i].name} (${_allProducts[i].brand})',
          );
        }
      }
    } else if (provider == null) {
      print('⚠️ PROBLÈME: Provider est NULL!');
    } else if (_allProducts.isNotEmpty) {
      print('ℹ️ Produits déjà chargés, skip');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    print('🔎 Recherche: "$query", filtre: $_selectedPetFilter');
    print('📊 Nombre de produits avant recherche: ${_allProducts.length}');

    setState(() {
      _searchResults = ProductService.searchProducts(
        _allProducts,
        query,
        petFilter: _selectedPetFilter,
      );
      print('📊 Résultats trouvés: ${_searchResults.length}');
      if (_searchResults.isNotEmpty && _searchResults.length <= 5) {
        for (var p in _searchResults) {
          print('  → ${p.name} (${p.brand})');
        }
      }
    });
  }

  void _filterByPetType(PetType? petType) {
    setState(() {
      _selectedPetFilter = petType;
      _performSearch(_searchController.text);
    });
  }

  void _quickSearch(String term) {
    print('⚡ Quick search: "$term"');
    _searchController.text = term;
    _performSearch(term);
  }

  @override
  Widget build(BuildContext context) {
    final isSearchEmpty =
        _searchController.text.isEmpty && _selectedPetFilter == null;

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
          'Rechercher des Produits',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Rechercher des produits...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Pet type filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Tous',
                    icon: Icons.pets,
                    isSelected: _selectedPetFilter == null,
                    onTap: () => _filterByPetType(null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Chiens',
                    icon: Icons.pets,
                    color: AppColors.dogColor,
                    isSelected: _selectedPetFilter == PetType.dog,
                    onTap: () => _filterByPetType(PetType.dog),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Chats',
                    icon: Icons.pets,
                    color: AppColors.catColor,
                    isSelected: _selectedPetFilter == PetType.cat,
                    onTap: () => _filterByPetType(PetType.cat),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Oiseaux',
                    icon: Icons.flutter_dash,
                    color: AppColors.birdColor,
                    isSelected: _selectedPetFilter == PetType.bird,
                    onTap: () => _filterByPetType(PetType.bird),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Lapins',
                    icon: Icons.pets,
                    color: AppColors.otherPetColor,
                    isSelected: _selectedPetFilter == PetType.rabbit,
                    onTap: () => _filterByPetType(PetType.rabbit),
                  ),
                ],
              ),
            ),
          ),

          // Popular searches and categories (when search is empty)
          if (isSearchEmpty) ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Popular searches
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Recherches Populaires',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _SearchChip(
                            label: 'Premium',
                            icon: Icons.star,
                            onTap: () => _quickSearch('premium'),
                          ),
                          _SearchChip(
                            label: 'Bio',
                            icon: Icons.eco,
                            onTap: () => _quickSearch('bio'),
                          ),
                          _SearchChip(
                            label: 'Saumon',
                            icon: Icons.set_meal,
                            onTap: () => _quickSearch('saumon'),
                          ),
                          _SearchChip(
                            label: 'Poulet',
                            icon: Icons.set_meal,
                            onTap: () => _quickSearch('poulet'),
                          ),
                          _SearchChip(
                            label: 'Sans Céréales',
                            icon: Icons.block,
                            onTap: () => _quickSearch('sans'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Categories
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Catégories',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Catégories basées sur la taxonomie OpenPetFoodFacts
                    // Source: https://world.openpetfoodfacts.org/data/taxonomies/categories.json
                    
                    _CategoryCard(
                      title: 'Nourriture pour Chats',
                      icon: Icons.pets,
                      color: AppColors.catColor,
                      description: 'Croquettes, pâtées et snacks pour chats',
                      onTap: () {
                        _searchController.clear();
                        _filterByPetType(PetType.cat);
                      },
                    ),

                    _CategoryCard(
                      title: 'Nourriture pour Chiens',
                      icon: Icons.pets,
                      color: AppColors.primary,
                      description: 'Croquettes, pâtées et snacks pour chiens',
                      onTap: () {
                        _searchController.clear();
                        _filterByPetType(PetType.dog);
                      },
                    ),

                    _CategoryCard(
                      title: 'Croquettes (Nourriture Sèche)',
                      icon: Icons.grain,
                      color: Colors.brown,
                      description: 'Aliments secs pour chiens et chats',
                      onTap: () => _quickSearch('croquettes'),
                    ),

                    _CategoryCard(
                      title: 'Pâtées (Nourriture Humide)',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                      description: 'Nourriture humide riche en protéines',
                      onTap: () => _quickSearch('pâtée'),
                    ),

                    _CategoryCard(
                      title: 'Produits Biologiques',
                      icon: Icons.eco,
                      color: AppColors.scoreExcellent,
                      description: 'Produits bio et naturels certifiés',
                      onTap: () => _quickSearch('bio'),
                    ),

                    _CategoryCard(
                      title: 'Nourriture pour Oiseaux',
                      icon: Icons.flutter_dash,
                      color: Colors.orange,
                      description: 'Graines et mélanges pour oiseaux',
                      onTap: () {
                        _searchController.clear();
                        _filterByPetType(PetType.bird);
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Results count
            if (_searchResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_searchResults.length} produit${_searchResults.length > 1 ? 's' : ''} trouvé${_searchResults.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    if (_selectedPetFilter != null ||
                        _searchController.text.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          _searchController.clear();
                          _filterByPetType(null);
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Tout effacer'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Results list
            Expanded(
              child: _searchResults.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final product = _searchResults[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun produit trouvé',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Essayez un autre terme de recherche ou scannez un code-barres',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : chipColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: chipColor.withOpacity(0.1),
      selectedColor: chipColor,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? chipColor : chipColor.withOpacity(0.3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SearchChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.divider),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.divider.withOpacity(0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
