import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Header avec avatar
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mon Profil',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Paramètres et préférences',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Section Mes Animaux
                const Text(
                  'Mes Animaux',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _ProfileCard(
                  icon: Icons.pets,
                  title: 'Gérer mes animaux',
                  subtitle: 'Ajouter ou modifier les profils',
                  onTap: () {
                    // TODO: Navigation vers gestion des animaux
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Section Préférences
                const Text(
                  'Préférences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _ProfileCard(
                  icon: Icons.filter_alt,
                  title: 'Critères de filtrage',
                  subtitle: 'Personnaliser les filtres de recherche',
                  onTap: () {
                    // TODO: Navigation vers paramètres de filtrage
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileCard(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Gérer les alertes et rappels',
                  onTap: () {
                    // TODO: Navigation vers paramètres de notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Section À propos
                const Text(
                  'À propos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _ProfileCard(
                  icon: Icons.info,
                  title: 'À propos de PetScan',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    // TODO: Afficher page "À propos"
                    showAboutDialog(
                      context: context,
                      applicationName: 'PetScan',
                      applicationVersion: '1.0.0 (MVP)',
                      applicationLegalese: '© 2025 PetScan',
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Application d\'analyse et de comparaison d\'aliments pour animaux de compagnie.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileCard(
                  icon: Icons.help,
                  title: 'Aide & Support',
                  subtitle: 'FAQ et contact',
                  onTap: () {
                    // TODO: Navigation vers aide
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileCard(
                  icon: Icons.privacy_tip,
                  title: 'Confidentialité',
                  subtitle: 'Politique de confidentialité',
                  onTap: () {
                    // TODO: Afficher politique de confidentialité
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Bouton de déconnexion (pour future authentification)
                /*
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implémenter déconnexion
                    },
                    child: const Text(
                      'Se déconnecter',
                      style: TextStyle(
                        color: AppColors.scorePoor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                */
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.divider, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
