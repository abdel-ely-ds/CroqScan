import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';

/// Account card showing user authentication status
class AccountCardFull extends StatelessWidget {
  final UserInfo? appleUser;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final Widget Function(IconData, String, String) buildDetailRow;

  const AccountCardFull({
    super.key,
    required this.appleUser,
    required this.onLogin,
    required this.onLogout,
    required this.buildDetailRow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: appleUser != null
              ? [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.02),
                ]
              : [
                  AppColors.pastelYellow.withValues(alpha: 0.3),
                  AppColors.pastelYellow.withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: appleUser != null
              ? Colors.black.withValues(alpha: 0.1)
              : AppColors.pastelYellow.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: appleUser != null
                      ? Colors.black
                      : AppColors.pastelYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  appleUser != null ? Icons.apple : Icons.warning_amber_rounded,
                  color: appleUser != null
                      ? Colors.white
                      : AppColors.textPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                appleUser != null ? 'Compte Apple' : 'Mode Invité',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (appleUser != null) ...[
            buildDetailRow(Icons.check_circle_rounded, 'Statut', 'Connecté'),
            if (appleUser!.email != null)
              buildDetailRow(Icons.email_rounded, 'Email', appleUser!.email!),
            if (appleUser!.name != null)
              buildDetailRow(Icons.person_rounded, 'Nom', appleUser!.name!),
          ] else ...[
            buildDetailRow(Icons.warning_rounded, 'Statut', 'Non connecté'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Connectez-vous pour sauvegarder vos données de manière sécurisée et accéder à vos favoris depuis plusieurs appareils.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
