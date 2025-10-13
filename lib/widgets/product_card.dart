import 'package:flutter/material.dart';
import '../models/product.dart';
import '../constants/app_colors.dart';
import 'score_badge.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(
                    Icons.pets,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: product.suitableFor
                          .take(2)
                          .map((pet) => _PetChip(petType: pet))
                          .toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Score Badge
              ScoreBadge(score: product.healthScore, size: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetChip extends StatelessWidget {
  final PetType petType;

  const _PetChip({required this.petType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPetColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        petType.displayName,
        style: TextStyle(
          fontSize: 10,
          color: _getPetColor(),
          fontWeight: FontWeight.w600,
        ),
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
}
