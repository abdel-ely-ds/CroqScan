import 'package:flutter/material.dart';
import '../../../core/models/product.dart';
import '../../../core/constants/app_colors.dart';
import '../score_badge.dart';
import '../../screens/product_details_screen.dart';

/// Widget displaying search results in a grid
class SearchResultsGrid extends StatelessWidget {
  final List<Product> results;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final bool hasMore;

  const SearchResultsGrid({
    super.key,
    required this.results,
    required this.isLoading,
    required this.onLoadMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty && !isLoading) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Results grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return _buildProductCard(context, results[index]);
          },
        ),

        // Load more indicator
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),

        // Load more trigger
        if (!isLoading && hasMore && results.isNotEmpty)
          GestureDetector(
            onTap: onLoadMore,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Charger plus de produits',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔍', style: TextStyle(fontSize: 60)),
            SizedBox(height: 24),
            Text(
              'Aucun résultat trouvé',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Essayez d\'ajuster vos filtres ou votre recherche.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.background,
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(
                            Icons.pets,
                            size: 40,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.pets,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  ScoreBadge(score: product.healthScore),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
