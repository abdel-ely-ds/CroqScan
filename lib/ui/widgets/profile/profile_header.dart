import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/profile_service.dart';

/// Header widget for profile screen showing title and action buttons
class ProfileHeader extends StatelessWidget {
  final AnimalProfile? profile;
  final VoidCallback onRefresh;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onRefresh,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile != null ? profile!.name : 'Mon Compte',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          if (profile != null)
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.primary,
                    ),
                    tooltip: 'Actualiser',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: AppColors.primary,
                    ),
                    tooltip: 'Modifier',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
