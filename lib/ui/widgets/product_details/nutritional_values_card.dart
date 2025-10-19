import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/product.dart';

/// Widget displaying nutritional values of a product
class NutritionalValuesCard extends StatelessWidget {
  final Product product;

  const NutritionalValuesCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
            '💪 Valeurs Nutritionnelles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pour 100g de produit',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (product.nutritionalInfo.protein > 0)
                _buildNutrientCard(
                  'Protéines',
                  '${product.nutritionalInfo.protein.toStringAsFixed(1)}%',
                  Icons.fitness_center,
                  Colors.blue.shade400,
                ),
              if (product.nutritionalInfo.fat > 0)
                _buildNutrientCard(
                  'Matières grasses',
                  '${product.nutritionalInfo.fat.toStringAsFixed(1)}%',
                  Icons.water_drop,
                  Colors.orange.shade400,
                ),
              if (product.nutritionalInfo.fiber > 0)
                _buildNutrientCard(
                  'Fibres',
                  '${product.nutritionalInfo.fiber.toStringAsFixed(1)}%',
                  Icons.grass,
                  Colors.green.shade400,
                ),
              if (product.nutritionalInfo.ash > 0)
                _buildNutrientCard(
                  'Cendres',
                  '${product.nutritionalInfo.ash.toStringAsFixed(1)}%',
                  Icons.science,
                  Colors.grey.shade400,
                ),
              if (product.nutritionalInfo.moisture > 0)
                _buildNutrientCard(
                  'Humidité',
                  '${product.nutritionalInfo.moisture.toStringAsFixed(1)}%',
                  Icons.water,
                  Colors.cyan.shade400,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
