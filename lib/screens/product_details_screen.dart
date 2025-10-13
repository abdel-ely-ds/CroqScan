import 'package:flutter/material.dart';
import '../models/product.dart';
import '../constants/app_colors.dart';
import '../widgets/score_badge.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with product image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.background,
                child: const Center(
                  child: Icon(
                    Icons.pets,
                    size: 100,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product header
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: product.suitableFor
                            .map((pet) => _PetChip(petType: pet))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Health Score Card
                _ScoreCard(product: product),

                const SizedBox(height: 8),

                // Description
                if (product.description.isNotEmpty)
                  _SectionCard(
                    title: 'Description',
                    icon: Icons.info_outline,
                    child: Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // Benefits
                if (product.benefits.isNotEmpty)
                  _SectionCard(
                    title: 'Benefits',
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.scoreExcellent,
                    child: Column(
                      children: product.benefits
                          .map(
                            (benefit) => _ListItem(
                              text: benefit,
                              icon: Icons.check,
                              iconColor: AppColors.scoreExcellent,
                            ),
                          )
                          .toList(),
                    ),
                  ),

                const SizedBox(height: 8),

                // Warnings
                if (product.warnings.isNotEmpty)
                  _SectionCard(
                    title: 'Warnings',
                    icon: Icons.warning_amber_outlined,
                    iconColor: AppColors.scorePoor,
                    child: Column(
                      children: product.warnings
                          .map(
                            (warning) => _ListItem(
                              text: warning,
                              icon: Icons.warning,
                              iconColor: AppColors.scorePoor,
                            ),
                          )
                          .toList(),
                    ),
                  ),

                const SizedBox(height: 8),

                // Ingredients
                _SectionCard(
                  title: 'Ingredients',
                  icon: Icons.list_alt,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.ingredients
                        .map(
                          (ingredient) => Chip(
                            label: Text(ingredient),
                            backgroundColor: AppColors.background,
                            side: const BorderSide(color: AppColors.divider),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 8),

                // Nutritional Info
                _SectionCard(
                  title: 'Nutritional Information',
                  icon: Icons.pie_chart_outline,
                  child: Column(
                    children: [
                      _NutritionRow(
                        label: 'Protein',
                        value: '${product.nutritionalInfo.protein}%',
                      ),
                      _NutritionRow(
                        label: 'Fat',
                        value: '${product.nutritionalInfo.fat}%',
                      ),
                      _NutritionRow(
                        label: 'Fiber',
                        value: '${product.nutritionalInfo.fiber}%',
                      ),
                      _NutritionRow(
                        label: 'Moisture',
                        value: '${product.nutritionalInfo.moisture}%',
                      ),
                      _NutritionRow(
                        label: 'Ash',
                        value: '${product.nutritionalInfo.ash}%',
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final Product product;

  const _ScoreCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getScoreColor(product.healthScore);
    final label = AppColors.getScoreLabel(product.healthScore);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          const Text(
            'Health Score',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ScoreBadge(score: product.healthScore, size: 120),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getScoreDescription(product.healthScore),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getScoreDescription(int score) {
    if (score >= 75) {
      return 'This product is excellent for your pet\'s health. It contains high-quality ingredients.';
    } else if (score >= 50) {
      return 'This product is good but could be improved. Check the warnings below.';
    } else if (score >= 25) {
      return 'This product is mediocre. Consider alternatives with better ingredients.';
    } else {
      return 'This product is not recommended for your pet. Please check warnings carefully.';
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const _ListItem({
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _NutritionRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _PetChip extends StatelessWidget {
  final PetType petType;

  const _PetChip({required this.petType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getPetColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getPetIcon(), color: _getPetColor(), size: 16),
          const SizedBox(width: 6),
          Text(
            petType.displayName,
            style: TextStyle(
              fontSize: 12,
              color: _getPetColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPetColor() {
    switch (petType) {
      case PetType.dog:
        return AppColors.dogColor;
      case PetType.cat:
        return AppColors.catColor;
      case PetType.bird:
        return AppColors.birdColor;
      default:
        return AppColors.otherPetColor;
    }
  }

  IconData _getPetIcon() {
    switch (petType) {
      case PetType.dog:
      case PetType.cat:
      case PetType.rabbit:
        return Icons.pets;
      case PetType.bird:
        return Icons.flutter_dash;
      default:
        return Icons.pets;
    }
  }
}
