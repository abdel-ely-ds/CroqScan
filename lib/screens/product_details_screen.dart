import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../constants/app_colors.dart';
import '../services/favorites_service.dart';

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

      // Snackbar amélioré
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isFavorite ? 'Ajouté à vos favoris' : 'Retiré de vos favoris',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isFavorite
              ? AppColors.scoreExcellent
              : AppColors.textSecondary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _shareProduct() {
    // TODO: Implémenter le partage avec share_plus
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📤 Fonctionnalité de partage à venir'),
        behavior: SnackBarBehavior.floating,
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
              // 🖼️ En-tête avec image
              _buildHeader(context),

              // Contenu scrollable
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // 💯 Score santé global
                    _buildHealthScoreSection(),

                    const SizedBox(height: 12),

                    // 💪 Valeurs nutritionnelles
                    _buildNutritionalValues(),

                    const SizedBox(height: 12),

                    // 🦴 Ingrédients
                    _buildIngredientsSection(),

                    const SizedBox(height: 12),

                    // ✅ ⚠️ Analyse (points positifs/négatifs)
                    if (widget.product.warnings.isNotEmpty ||
                        widget.product.benefits.isNotEmpty)
                      _buildAnalysisSection(),

                    if (widget.product.warnings.isNotEmpty ||
                        widget.product.benefits.isNotEmpty)
                      const SizedBox(height: 12),

                    // 📋 Catégories & origine
                    _buildCategoriesSection(),

                    const SizedBox(height: 12),

                    // 🔄 Produits similaires
                    _buildSimilarProducts(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),

          // 🔄 Bouton d'action flottant
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFloatingActionBar(),
          ),
        ],
      ),
    );
  }

  // 🖼️ En-tête avec image du produit
  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
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
        // Bouton Favori
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
        // Bouton Partager
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
            child: const Icon(
              Icons.share,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          onPressed: _shareProduct,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: widget.product.imageUrl.isNotEmpty
                  ? Center(
                      child: GestureDetector(
                        onTap: () => _showImagePopup(context),
                        child: Hero(
                          tag: 'product_image_${widget.product.barcode}',
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 220),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                widget.product.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Padding(
                                    padding: EdgeInsets.all(32),
                                    child: Icon(
                                      Icons.pets,
                                      size: 60,
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
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 60,
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

  // 💯 Score santé global
  Widget _buildHealthScoreSection() {
    final scoreColor = _getScoreColor(widget.product.healthScore);
    final scoreLabel = _getScoreLabel(widget.product.healthScore);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nom et marque
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.brand,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          // Score circulaire
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  scoreColor.withValues(alpha: 0.2),
                  scoreColor.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(color: scoreColor, width: 8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.product.healthScore}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                  const Text(
                    '/100',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Label du score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: scoreColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              scoreLabel,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Basé sur l\'analyse nutritionnelle et des ingrédients',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 💪 Valeurs nutritionnelles
  Widget _buildNutritionalValues() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '💪 Valeurs nutritionnelles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Nutriments en grille
          _buildNutrientCard(
            'Protéines',
            widget.product.nutritionalInfo.protein,
            Icons.fitness_center,
            AppColors.scoreExcellent,
          ),
          const SizedBox(height: 12),

          _buildNutrientCard(
            'Matières grasses',
            widget.product.nutritionalInfo.fat,
            Icons.water_drop,
            Colors.orange,
          ),
          const SizedBox(height: 12),

          _buildNutrientCard(
            'Fibres',
            widget.product.nutritionalInfo.fiber,
            Icons.grass,
            Colors.green,
          ),

          if (widget.product.nutritionalInfo.moisture > 0) ...[
            const SizedBox(height: 12),
            _buildNutrientCard(
              'Humidité',
              widget.product.nutritionalInfo.moisture,
              Icons.opacity,
              Colors.blue,
            ),
          ],

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pour 100g de produit',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(
    String label,
    double value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)} g',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 🦴 Ingrédients
  Widget _buildIngredientsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.list_alt,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '🦴 Ingrédients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Liste d'ingrédients avec chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.ingredients.map((ingredient) {
              final isProblematic = _isProblematicIngredient(ingredient);
              final isGood = _isGoodIngredient(ingredient);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isProblematic
                      ? Colors.red.withValues(alpha: 0.1)
                      : isGood
                      ? AppColors.scoreExcellent.withValues(alpha: 0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isProblematic
                        ? Colors.red.withValues(alpha: 0.3)
                        : isGood
                        ? AppColors.scoreExcellent.withValues(alpha: 0.3)
                        : AppColors.textSecondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isProblematic)
                      const Icon(
                        Icons.warning_amber,
                        size: 14,
                        color: Colors.red,
                      )
                    else if (isGood)
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.scoreExcellent,
                      ),
                    if (isProblematic || isGood) const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        ingredient,
                        style: TextStyle(
                          fontSize: 13,
                          color: isProblematic
                              ? Colors.red.shade700
                              : isGood
                              ? AppColors.scoreExcellent
                              : AppColors.textPrimary,
                          fontWeight: isProblematic || isGood
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ✅ ⚠️ Analyse (points positifs/négatifs)
  Widget _buildAnalysisSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Points positifs
          if (widget.product.benefits.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.scoreExcellent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.scoreExcellent.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.scoreExcellent,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '✅ Points positifs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.scoreExcellent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.product.benefits.map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 6,
                            color: AppColors.scoreExcellent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Avertissements
          if (widget.product.warnings.isNotEmpty) ...[
            if (widget.product.benefits.isNotEmpty) const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '⚠️ Points d\'attention',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.product.warnings.map(
                    (warning) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              warning,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 📋 Catégories & origine
  Widget _buildCategoriesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.category,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Informations produit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoRow(Icons.qr_code, 'Code-barres', widget.product.barcode),
          _buildInfoRow(Icons.business, 'Marque', widget.product.brand),
          _buildInfoRow(Icons.label, 'Catégorie', widget.product.description),

          if (widget.product.suitableFor.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.pets,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.product.suitableFor.map((petType) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPetColor(petType).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getPetColor(petType).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getPetEmoji(petType),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              petType.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _getPetColor(petType),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔄 Produits similaires (désactivé - mode API uniquement)
  Widget _buildSimilarProducts() {
    // Mode API uniquement - pas de base de données locale
    // Les produits similaires nécessiteraient une recherche API complexe
    return const SizedBox.shrink();
  }

  // 🔄 Barre d'actions flottante
  Widget _buildFloatingActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.qr_code_scanner, size: 22),
            label: const Text(
              'Scanner un autre produit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }

  // Afficher l'image en grand plein écran
  void _showImagePopup(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                // Image zoomable plein écran
                Hero(
                  tag: 'product_image_${widget.product.barcode}',
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5.0,
                    child: Center(
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Bouton fermer
                Positioned(
                  top: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Indication zoom
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.zoom_in,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Pincez pour zoomer',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helpers
  Color _getScoreColor(int score) {
    if (score >= 75) return AppColors.scoreExcellent;
    if (score >= 50) return AppColors.scoreGood;
    if (score >= 25) return AppColors.scoreMediocre;
    return AppColors.scorePoor;
  }

  String _getScoreLabel(int score) {
    if (score >= 75) return 'Excellent';
    if (score >= 50) return 'Bon';
    if (score >= 25) return 'Moyen';
    return 'À éviter';
  }

  bool _isProblematicIngredient(String ingredient) {
    final lower = ingredient.toLowerCase();
    return lower.contains('sous-produit') ||
        lower.contains('by-product') ||
        lower.contains('colorant') ||
        lower.contains('e1') ||
        lower.contains('sucre') ||
        lower.contains('sugar') ||
        lower.contains('additif');
  }

  bool _isGoodIngredient(String ingredient) {
    final lower = ingredient.toLowerCase();
    return lower.contains('poulet') ||
        lower.contains('chicken') ||
        lower.contains('saumon') ||
        lower.contains('salmon') ||
        lower.contains('bio') ||
        lower.contains('organic') ||
        lower.contains('viande') ||
        lower.contains('meat');
  }

  Color _getPetColor(PetType petType) {
    switch (petType) {
      case PetType.dog:
        return AppColors.dogColor;
      case PetType.cat:
        return AppColors.catColor;
      case PetType.bird:
        return AppColors.birdColor;
      case PetType.rabbit:
        return AppColors.otherPetColor;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getPetEmoji(PetType petType) {
    switch (petType) {
      case PetType.dog:
        return '🐶';
      case PetType.cat:
        return '🐱';
      case PetType.bird:
        return '🦜';
      case PetType.rabbit:
        return '🐰';
      default:
        return '🐾';
    }
  }
}
