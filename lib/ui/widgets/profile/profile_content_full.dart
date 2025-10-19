import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/profile_service.dart';
import '../../../core/services/auth_service.dart';
import 'pet_hero_card_full.dart';
import 'stats_grid_card_full.dart';
import 'account_card_full.dart';
import 'profile_build_helpers.dart';

/// Full profile content widget showing all pet and user information
class ProfileContentFull extends StatelessWidget {
  final AnimalProfile profile;
  final UserInfo? appleUser;
  final VoidCallback onLogin;
  final VoidCallback onLogout;

  const ProfileContentFull({
    super.key,
    required this.profile,
    required this.appleUser,
    required this.onLogin,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet hero section
            PetHeroCardFull(
              profile: profile,
              getAnimalEmoji: ProfileBuildHelpers.getAnimalEmoji,
              getAnimalTypeName: ProfileBuildHelpers.getAnimalTypeName,
            ),
            const SizedBox(height: 24),

            // Stats cards grid
            StatsGridCardFull(
              profile: profile,
              getAnimalTypeName: ProfileBuildHelpers.getAnimalTypeName,
            ),

            const SizedBox(height: 24),

            // Section informations animal
            if (profile.breed != null ||
                profile.ageYears != null ||
                profile.weightKg != null ||
                profile.isNeutered != null)
              ProfileBuildHelpers.buildInfoCard(
                title: 'Informations détaillées',
                icon: Icons.info_outline_rounded,
                children: [
                  if (profile.breed != null)
                    ProfileBuildHelpers.buildDetailRow(
                        Icons.pets_rounded, 'Race', profile.breed!),
                  if (profile.ageYears != null)
                    ProfileBuildHelpers.buildDetailRow(
                      Icons.cake_rounded,
                      'Âge',
                      '${profile.ageYears} an${profile.ageYears! > 1 ? 's' : ''}',
                    ),
                  if (profile.weightKg != null)
                    ProfileBuildHelpers.buildDetailRow(
                      Icons.monitor_weight_rounded,
                      'Poids',
                      '${profile.weightKg} kg',
                    ),
                  if (profile.isNeutered != null)
                    ProfileBuildHelpers.buildDetailRow(
                      Icons.medical_services_rounded,
                      'Stérilisé(e)',
                      profile.isNeutered! ? 'Oui' : 'Non',
                    ),
                ],
              ),

            const SizedBox(height: 16),

            // Section préférences
            if (profile.foodType != null ||
                profile.allergies.isNotEmpty ||
                profile.preferredBrand != null ||
                profile.healthGoals.isNotEmpty)
              ProfileBuildHelpers.buildInfoCard(
                title: 'Préférences alimentaires',
                icon: Icons.restaurant_rounded,
                children: [
                  if (profile.foodType != null)
                    ProfileBuildHelpers.buildDetailRow(
                      Icons.fastfood_rounded,
                      'Type d\'alimentation',
                      ProfileBuildHelpers.getFoodTypeName(profile.foodType!),
                    ),
                  if (profile.allergies.isNotEmpty)
                    ProfileBuildHelpers.buildDetailRow(
                      Icons.warning_amber_rounded,
                      'Allergies',
                      profile.allergies.join(', '),
                    ),
                  if (profile.preferredBrand != null)
                    ProfileBuildHelpers.buildDetailRow(
                      Icons.favorite_rounded,
                      'Marque préférée',
                      profile.preferredBrand!,
                    ),
                  if (profile.healthGoals.isNotEmpty)
                    ProfileBuildHelpers.buildDetailRow(
                      Icons.fitness_center_rounded,
                      'Objectifs santé',
                      profile.healthGoals.join(', '),
                    ),
                ],
              ),

            const SizedBox(height: 16),

            // Section compte - Invité ou Apple
            AccountCardFull(
              appleUser: appleUser,
              onLogin: onLogin,
              onLogout: onLogout,
              buildDetailRow: ProfileBuildHelpers.buildDetailRow,
            ),

            const SizedBox(height: 16),

            // Section paramètres
            ProfileBuildHelpers.buildInfoCard(
              title: 'Paramètres',
              icon: Icons.settings_rounded,
              children: [
                ProfileBuildHelpers.buildActionRow(
                  icon: Icons.info_outline_rounded,
                  title: 'À propos de CroqScan',
                  subtitle: 'Version 1.0.0',
                  color: AppColors.pastelMint,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CroqScan',
                      applicationVersion: '1.0.0 (MVP)',
                      applicationLegalese: '© 2025 CroqScan',
                      children: const [
                        SizedBox(height: 16),
                        Text(
                          'Application d\'analyse et de comparaison d\'aliments pour animaux de compagnie.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  },
                ),
                ProfileBuildHelpers.buildActionRow(
                  icon: Icons.help_outline_rounded,
                  title: 'Aide & Support',
                  subtitle: 'FAQ et contact',
                  color: AppColors.pastelPeach,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ProfileBuildHelpers.buildActionRow(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Confidentialité',
                  subtitle: 'Politique de confidentialité',
                  color: AppColors.pastelLavender,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bouton de connexion (si mode invité)
            if (appleUser == null)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onLogin,
                  icon: const Icon(Icons.apple, size: 24),
                  label: const Text(
                    'Se connecter avec Apple',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              )
            else
              // Bouton de déconnexion (si connecté avec Apple)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'Se déconnecter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Colors.red.shade400, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

