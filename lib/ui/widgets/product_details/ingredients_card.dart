import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'product_helpers.dart';

/// Widget displaying product ingredients
class IngredientsCard extends StatelessWidget {
  final String ingredientsText;

  const IngredientsCard({super.key, required this.ingredientsText});

  @override
  Widget build(BuildContext context) {
    if (ingredientsText.isEmpty) {
      return const SizedBox.shrink();
    }

    final ingredients = ingredientsText
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

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
          const Row(
            children: [
              Text('🦴', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
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
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ingredients.map((ingredient) {
              final isProblematic = ProductHelpers.isProblematicIngredient(
                ingredient,
              );
              final isGood = ProductHelpers.isGoodIngredient(ingredient);

              Color bgColor;
              Color textColor;
              IconData? icon;

              if (isProblematic) {
                bgColor = AppColors.scorePoor.withValues(alpha: 0.1);
                textColor = AppColors.scorePoor;
                icon = Icons.warning_amber_rounded;
              } else if (isGood) {
                bgColor = AppColors.scoreExcellent.withValues(alpha: 0.1);
                textColor = AppColors.scoreExcellent;
                icon = Icons.check_circle_outline;
              } else {
                bgColor = AppColors.background;
                textColor = AppColors.textSecondary;
                icon = null;
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isProblematic || isGood
                        ? textColor.withValues(alpha: 0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 16, color: textColor),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        ingredient,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor,
                          fontWeight: isProblematic || isGood
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Légende
          Wrap(
            spacing: 16,
            children: [
              _buildLegendItem(
                Icons.check_circle_outline,
                'Bon',
                AppColors.scoreExcellent,
              ),
              _buildLegendItem(
                Icons.warning_amber_rounded,
                'À surveiller',
                AppColors.scorePoor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
