import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/profile_service.dart';

/// Animal info card showing detailed information
class AnimalInfoCardFull extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final AnimalProfile profile;

  const AnimalInfoCardFull({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 16),
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
          Column(
            children: [
              if (profile.breed != null)
                _buildDetailRow(Icons.pets_rounded, 'Race', profile.breed!),
              if (profile.ageYears != null)
                _buildDetailRow(
                  Icons.cake_rounded,
                  'Âge',
                  '${profile.ageYears} an${profile.ageYears! > 1 ? 's' : ''}',
                ),
              if (profile.weightKg != null)
                _buildDetailRow(
                  Icons.monitor_weight_rounded,
                  'Poids',
                  '${profile.weightKg} kg',
                ),
              if (profile.isNeutered != null)
                _buildDetailRow(
                  Icons.healing_rounded,
                  'Stérilisé(e)',
                  profile.isNeutered! ? 'Oui' : 'Non',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
