import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Floating action bar for product details
class ProductActionBar extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onShare;

  const ProductActionBar({
    super.key,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
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
        top: false,
        child: Row(
          children: [
            // Favorite button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onFavoriteToggle,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                ),
                label: Text(
                  isFavorite ? 'Ajouté aux favoris' : 'Ajouter aux favoris',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFavorite
                      ? AppColors.scoreExcellent
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Share button
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: onShare,
                icon: const Icon(Icons.share, size: 22),
                color: AppColors.primary,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
