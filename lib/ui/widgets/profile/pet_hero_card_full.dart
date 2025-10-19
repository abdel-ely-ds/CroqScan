import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/profile_service.dart';

/// Pet hero card showing main pet information with illustration
class PetHeroCardFull extends StatelessWidget {
  final AnimalProfile profile;
  final String Function(String) getAnimalEmoji;
  final String Function(String) getAnimalTypeName;

  const PetHeroCardFull({
    super.key,
    required this.profile,
    required this.getAnimalEmoji,
    required this.getAnimalTypeName,
  });

  @override
  Widget build(BuildContext context) {
    final isDog = profile.animalType == 'dog';
    final heroColor = isDog ? AppColors.dogColor : AppColors.catColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            heroColor.withValues(alpha: 0.15),
            heroColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: heroColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          // Pet illustration
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: heroColor.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              isDog
                  ? 'assets/images/dog_illustration.png'
                  : 'assets/images/cat_illustration.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 20),
          // Pet info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${getAnimalEmoji(profile.animalType)} ${getAnimalTypeName(profile.animalType)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (profile.breed != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    profile.breed!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
