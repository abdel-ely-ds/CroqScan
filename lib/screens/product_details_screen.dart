import 'package:flutter/material.dart';
import '../models/product.dart';
import '../constants/app_colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 🖼️ En-tête avec image
          _buildHeader(context),

          // Contenu scrollable
          SliverToBoxAdapter(
            child: Column(
              children: [
                // 💯 Score santé global
                _buildHealthScoreSection(),

                SizedBox(height: 12),

                // 🍗 Analyse nutritionnelle
                _buildNutritionalAnalysis(),

                SizedBox(height: 12),

                // 🧠 Ingrédients
                _buildIngredientsSection(),

                SizedBox(height: 12),

                // 📋 Informations produit
                _buildProductInfo(),

                SizedBox(height: 12),

                // ⚠️ Avertissements & ✅ Avantages
                if (product.warnings.isNotEmpty || product.benefits.isNotEmpty)
                  _buildWarningsAndBenefits(),

                SizedBox(height: 20),

                // 🔄 Actions rapides
                _buildQuickActions(context),

                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🖼️ En-tête avec image du produit (version douce et élégante)
  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.share, color: AppColors.textPrimary, size: 20),
          ),
          onPressed: () {
            // TODO: Partager
          },
        ),
        SizedBox(width: 8),
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
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: product.imageUrl.isNotEmpty
                  ? Center(
                      child: GestureDetector(
                        onTap: () => _showImagePopup(context),
                        child: Hero(
                          tag: 'product_image_${product.barcode}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 20,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Padding(
                                        padding: EdgeInsets.all(32),
                                        child: Icon(
                                          Icons.pets,
                                          size: 60,
                                          color: AppColors.textSecondary
                                              .withOpacity(0.3),
                                        ),
                                      );
                                    },
                                  ),
                                  // Indicateur "tap to zoom"
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.zoom_in,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Agrandir',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.pets,
                          size: 60,
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // 💯 Score santé global (style Yuka)
  Widget _buildHealthScoreSection() {
    final scoreColor = _getScoreColor(product.healthScore);
    final scoreLabel = _getScoreLabel(product.healthScore);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nom et marque
          Text(
            product.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            product.brand,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 24),

          // Score circulaire
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  scoreColor.withOpacity(0.2),
                  scoreColor.withOpacity(0.05),
                ],
              ),
              border: Border.all(color: scoreColor, width: 8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${product.healthScore}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                  Text(
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

          SizedBox(height: 16),

          // Label du score
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scoreColor.withOpacity(0.3)),
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

          SizedBox(height: 12),

          Text(
            'Basé sur l\'analyse nutritionnelle et des ingrédients',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 🍗 Analyse nutritionnelle
  Widget _buildNutritionalAnalysis() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppColors.primary, size: 24),
              SizedBox(width: 12),
              Text(
                'Analyse nutritionnelle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Barres nutritionnelles
          _buildNutrientBar(
            'Protéines',
            product.nutritionalInfo.protein,
            Icons.fitness_center,
            AppColors.scoreExcellent,
            targetMin: 25,
          ),
          SizedBox(height: 16),

          _buildNutrientBar(
            'Matières grasses',
            product.nutritionalInfo.fat,
            Icons.water_drop,
            Colors.orange,
            targetMax: 20,
          ),
          SizedBox(height: 16),

          _buildNutrientBar(
            'Fibres',
            product.nutritionalInfo.fiber,
            Icons.grass,
            Colors.green,
            targetMin: 2,
          ),

          if (product.nutritionalInfo.ash > 0) ...[
            SizedBox(height: 16),
            _buildNutrientBar(
              'Cendres',
              product.nutritionalInfo.ash,
              Icons.local_fire_department,
              Colors.grey,
              targetMax: 10,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutrientBar(
    String label,
    double value,
    IconData icon,
    Color color, {
    double? targetMin,
    double? targetMax,
  }) {
    final percentage = (value / 50).clamp(0.0, 1.0);
    final isGood =
        (targetMin != null && value >= targetMin) ||
        (targetMax != null && value <= targetMax) ||
        (targetMin == null && targetMax == null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Spacer(),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              isGood ? Icons.check_circle : Icons.info,
              size: 18,
              color: isGood
                  ? AppColors.scoreExcellent
                  : AppColors.scoreMediocre,
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  // 🧠 Ingrédients
  Widget _buildIngredientsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt, color: AppColors.primary, size: 24),
              SizedBox(width: 12),
              Text(
                'Ingrédients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Liste d'ingrédients avec chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.ingredients.map((ingredient) {
              final isProblematic = _isProblematicIngredient(ingredient);
              final isGood = _isGoodIngredient(ingredient);

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isProblematic
                      ? Colors.red.withOpacity(0.1)
                      : isGood
                      ? AppColors.scoreExcellent.withOpacity(0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isProblematic
                        ? Colors.red.withOpacity(0.3)
                        : isGood
                        ? AppColors.scoreExcellent.withOpacity(0.3)
                        : AppColors.textSecondary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isProblematic)
                      Icon(Icons.warning_amber, size: 14, color: Colors.red)
                    else if (isGood)
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.scoreExcellent,
                      ),
                    if (isProblematic || isGood) SizedBox(width: 4),
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

  // 📋 Informations produit
  Widget _buildProductInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 24),
              SizedBox(width: 12),
              Text(
                'Informations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          _buildInfoRow('Code-barres', product.barcode),
          _buildInfoRow('Marque', product.brand),
          _buildInfoRow('Catégories', product.description),

          if (product.suitableFor.isNotEmpty) ...[
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.pets, size: 18, color: AppColors.textSecondary),
                SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: product.suitableFor.map((petType) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPetColor(petType).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getPetColor(petType).withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getPetEmoji(petType),
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 4),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6, color: AppColors.primary),
          SizedBox(width: 12),
          Text(
            '$label : ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // ⚠️ Avertissements & ✅ Avantages
  Widget _buildWarningsAndBenefits() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Avertissements
          if (product.warnings.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Points d\'attention',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...product.warnings.map(
                    (warning) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.circle, size: 6, color: Colors.red),
                          SizedBox(width: 8),
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

          // Avantages
          if (product.benefits.isNotEmpty) ...[
            if (product.warnings.isNotEmpty) SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.scoreExcellent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.scoreExcellent.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.scoreExcellent,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Points positifs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.scoreExcellent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...product.benefits.map(
                    (benefit) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: AppColors.scoreExcellent,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.scoreExcellent.withOpacity(
                                  0.9,
                                ),
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

  // 🔄 Actions rapides
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Bouton Scanner un autre produit
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Scanner un autre produit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12),

          // Info OpenPetFoodFacts
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Données issues d\'OpenPetFoodFacts',
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
                  tag: 'product_image_${product.barcode}',
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5.0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Image non disponible',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Bouton fermer en haut (avec fade)
                Positioned(
                  top: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: animation,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.close,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Indication en bas (avec fade)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: animation,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
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
    return 'Médiocre';
  }

  bool _isProblematicIngredient(String ingredient) {
    final lower = ingredient.toLowerCase();
    return lower.contains('sous-produit') ||
        lower.contains('by-product') ||
        lower.contains('colorant') ||
        lower.contains('e1') ||
        lower.contains('sucre') ||
        lower.contains('sugar');
  }

  bool _isGoodIngredient(String ingredient) {
    final lower = ingredient.toLowerCase();
    return lower.contains('poulet') ||
        lower.contains('chicken') ||
        lower.contains('saumon') ||
        lower.contains('salmon') ||
        lower.contains('bio') ||
        lower.contains('organic');
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
