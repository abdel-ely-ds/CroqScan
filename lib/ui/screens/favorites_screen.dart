import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/product_card.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/openpetfoodfacts_service.dart';
import '../../core/models/product.dart';
import 'scanner_screen.dart';
import 'product_details_screen.dart';
import '../widgets/main_navigation.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<String> favoriteIds = {};
  List<Product> favoriteProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint('📱 DEBUG: FavoritesScreen - initState');
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    final favorites = await FavoritesService.getFavorites();
    debugPrint('🔍 DEBUG: Favoris barcodes chargés: $favorites');

    // Charger les produits depuis l'API pour chaque barcode favori
    final List<Product> loadedProducts = [];
    for (final barcode in favorites) {
      debugPrint('⏳ Chargement du produit $barcode depuis l\'API...');
      final product = await OpenPetFoodFactsService.fetchProductByBarcode(
        barcode,
      );
      if (product != null) {
        loadedProducts.add(product);
        debugPrint('✅ Produit $barcode chargé');
      } else {
        debugPrint('❌ Produit $barcode non trouvé sur l\'API');
      }
    }

    if (mounted) {
      setState(() {
        favoriteIds = favorites;
        favoriteProducts = loadedProducts;
        isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(String barcode) async {
    HapticFeedback.mediumImpact();

    await FavoritesService.removeFavorite(barcode);

    // Animation de suppression
    setState(() {
      favoriteProducts.removeWhere((p) => p.barcode == barcode);
      favoriteIds.remove(barcode);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Retiré de vos favoris',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.textSecondary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          action: SnackBarAction(
            label: 'Annuler',
            textColor: Colors.white,
            onPressed: () async {
              // Remettre dans les favoris
              await FavoritesService.addFavorite(barcode);
              await _loadFavorites();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadFavorites,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // 1️⃣ Header avec titre et badge
              SliverToBoxAdapter(child: _buildHeader()),

              // 2️⃣ Liste des favoris / Loading / État vide
              if (isLoading)
                _buildLoadingState()
              else if (favoriteProducts.isEmpty)
                _buildEmptyState()
              else
                _buildFavoritesList(),

              // Espace pour la navbar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  // 1️⃣ Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mes Favoris ❤️', // AppLocalizations not available in sliver header
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                favoriteProducts.isEmpty
                    ? 'Sauvegarde tes produits préférés'
                    : '${favoriteProducts.length} produit${favoriteProducts.length > 1 ? 's' : ''} sauvegardé${favoriteProducts.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // État de chargement
  Widget _buildLoadingState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 20),
            const Text(
              'Chargement de vos favoris...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // État vide avec illustration et CTAs
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration emoji
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Text('🐶🧺', style: TextStyle(fontSize: 80)),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.noFavoritesYet,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.noFavoritesDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              // CTA Principal : Scanner
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScannerScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 22),
                  label: Text(
                    l10n.scanAProduct,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // CTA Secondaire : Explorer
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Ouvrir l'onglet recherche dans la navigation principale
                    final mainNav = context.findAncestorStateOfType<MainNavigationState>();
                    if (mainNav != null) {
                      mainNav.navigateToTab(1); // Index 1 = Search
                    }
                  },
                  icon: const Icon(Icons.explore, size: 20),
                  label: Text(
                    l10n.exploreCategories,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Liste des favoris avec swipe pour supprimer
  Widget _buildFavoritesList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = favoriteProducts[index];
          return Dismissible(
            key: Key(product.barcode),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeFavorite(product.barcode);
            },
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, color: Colors.white, size: 32),
                  SizedBox(height: 4),
                  Text(
                    'Retirer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProductCard(
                product: product,
                isFavorite: true,
                onFavoriteToggle: () => _removeFavorite(product.barcode),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    ),
                  );
                },
              ),
            ),
          );
        }, childCount: favoriteProducts.length),
      ),
    );
  }
}
