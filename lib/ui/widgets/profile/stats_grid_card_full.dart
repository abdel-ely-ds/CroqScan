import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/profile_service.dart';

/// Stats grid showing key animal statistics
class StatsGridCardFull extends StatelessWidget {
  final AnimalProfile profile;
  final String Function(String) getAnimalTypeName;

  const StatsGridCardFull({
    super.key,
    required this.profile,
    required this.getAnimalTypeName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.pets_rounded,
            label: 'Type',
            value: getAnimalTypeName(profile.animalType),
            color: profile.animalType == 'dog'
                ? AppColors.dogColor
                : AppColors.catColor,
          ),
        ),
        const SizedBox(width: 12),
        if (profile.ageYears != null)
          Expanded(
            child: _buildStatCard(
              icon: Icons.cake_rounded,
              label: 'Âge',
              value:
                  '${profile.ageYears} an${profile.ageYears! > 1 ? 's' : ''}',
              color: AppColors.pastelPeach,
            ),
          ),
        if (profile.ageYears == null)
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite_rounded,
              label: 'Statut',
              value: profile.isNeutered == true ? 'Stérilisé' : 'Info',
              color: AppColors.pastelMint,
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
