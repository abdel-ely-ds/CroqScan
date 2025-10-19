import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Widget displaying product analysis (benefits and warnings)
class ProductAnalysisCard extends StatelessWidget {
  final List<String> benefits;
  final List<String> warnings;

  const ProductAnalysisCard({
    super.key,
    required this.benefits,
    required this.warnings,
  });

  @override
  Widget build(BuildContext context) {
    if (benefits.isEmpty && warnings.isEmpty) {
      return const SizedBox.shrink();
    }

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
            '📊 Analyse',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Benefits
          if (benefits.isNotEmpty) ...[
            _buildSection(
              title: 'Points positifs',
              items: benefits,
              icon: Icons.check_circle,
              iconColor: AppColors.scoreExcellent,
              bgColor: AppColors.scoreExcellent.withValues(alpha: 0.1),
            ),
          ],
          if (benefits.isNotEmpty && warnings.isNotEmpty)
            const SizedBox(height: 16),
          // Warnings
          if (warnings.isNotEmpty) ...[
            _buildSection(
              title: 'Points d\'attention',
              items: warnings,
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.scoreMediocre,
              bgColor: AppColors.scoreMediocre.withValues(alpha: 0.1),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle, size: 6, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
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
    );
  }
}
