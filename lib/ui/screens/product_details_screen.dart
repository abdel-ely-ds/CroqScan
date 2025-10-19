import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/product.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/favorites_service.dart';
import '../widgets/product_details/health_score_card.dart';
import '../widgets/product_details/nutritional_values_card.dart';
import '../widgets/product_details/ingredients_card.dart';
import '../widgets/product_details/product_analysis_card.dart';
import '../widgets/product_details/product_action_bar.dart';
import 'image_fullscreen_screen.dart';

/// Product details screen - refactored for modularity
class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final status = await FavoritesService.isFavorite(widget.product.barcode);
    if (mounted) {
      setState(() {
        isFavorite = status;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    HapticFeedback.lightImpact();

    final newStatus = await FavoritesService.toggleFavorite(
      widget.product.barcode,
    );

    if (mounted) {
      setState(() {
        isFavorite = newStatus;
      });

      _showFavoriteSnackbar(newStatus);
    }
  }

  void _showFavoriteSnackbar(bool added) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              added ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                added ? 'Ajouté à vos favoris' : 'Retiré de vos favoris',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: added
            ? AppColors.scoreExcellent
            : AppColors.textSecondary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _shareProduct() {
    // TODO: Implement sharing with share_plus
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📤 Fonctionnalité de partage à venir'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showImagePopup() {
    if (widget.product.imageUrl.isEmpty) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ImageFullscreenScreen(
              imageUrl: widget.product.imageUrl,
              heroTag: 'product_image_${widget.product.barcode}',
            ),
        opaque: false, // Permet de voir l'écran précédent pendant la transition
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade in du fond noir
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header with image
              _buildHeader(),

              // Scrollable content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Health score
                    HealthScoreCard(healthScore: widget.product.healthScore),

                    const SizedBox(height: 12),

                    // Nutritional values
                    NutritionalValuesCard(product: widget.product),

                    const SizedBox(height: 12),

                    // Ingredients
                    IngredientsCard(
                      ingredientsText: widget.product.ingredients.join(', '),
                    ),

                    const SizedBox(height: 12),

                    // Analysis (benefits/warnings)
                    ProductAnalysisCard(
                      benefits: widget.product.benefits,
                      warnings: widget.product.warnings,
                    ),

                    const SizedBox(height: 12),

                    // Product description
                    if (widget.product.description.isNotEmpty)
                      _buildDescriptionSection(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),

          // Floating action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProductActionBar(
              isFavorite: isFavorite,
              onFavoriteToggle: _toggleFavorite,
              onShare: _shareProduct,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // Favorite button
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : AppColors.textPrimary,
              size: 20,
            ),
          ),
          onPressed: _toggleFavorite,
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade50, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: widget.product.imageUrl.isNotEmpty
                  ? Center(
                      child: GestureDetector(
                        onTap: _showImagePopup,
                        child: Hero(
                          tag: 'product_image_${widget.product.barcode}',
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 150),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.product.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Icon(
                                      Icons.pets,
                                      size: 48,
                                      color: AppColors.textSecondary,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
