import 'package:flutter/material.dart';
import '../../core/models/product.dart';
import '../../core/constants/app_colors.dart';
import 'score_badge.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: _isPressed ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _controller.forward();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppColors.primary.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Product Image with gradient background
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.accent.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Icon(
                        Icons.pets,
                        size: 40,
                        color: AppColors.primary,
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
                          widget.product.brand,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.name,
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
                          children: widget.product.suitableFor
                              .take(2)
                              .map((pet) => _PetChip(petType: pet))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Favorite button (if callback provided)
                  if (widget.onFavoriteToggle != null)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: widget.isFavorite ? 1.2 : 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: IconButton(
                            icon: Icon(
                              widget.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.isFavorite
                                  ? Colors.red
                                  : AppColors.textSecondary,
                            ),
                            onPressed: widget.onFavoriteToggle,
                            iconSize: 24,
                          ),
                        );
                      },
                    ),

                  // Score Badge
                  ScoreBadge(score: widget.product.healthScore, size: 60),
                ],
              ),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getPetColor().withValues(alpha: 0.2),
            _getPetColor().withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getPetColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        petType.displayName,
        style: TextStyle(
          fontSize: 11,
          color: _getPetColor(),
          fontWeight: FontWeight.bold,
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
