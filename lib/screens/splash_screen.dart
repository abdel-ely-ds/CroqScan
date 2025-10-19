import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/main_navigation.dart';
import 'login_screen.dart';
import 'pet_onboarding_screen.dart';

/// Écran de démarrage qui vérifie l'authentification
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Petit délai pour le splash
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Vérifier si l'utilisateur est déjà connecté
    final isLoggedIn = await AuthService.isLoggedIn();
    final profile = await ProfileService.loadProfile();

    if (isLoggedIn) {
      print('✅ Utilisateur déjà connecté - Auto-login');
      
      if (profile == null) {
        // Connecté mais pas de profil - aller vers onboarding
        print('ℹ️ Pas de profil - Redirection vers onboarding');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetOnboardingScreen()),
        );
      } else {
        // Connecté avec profil - aller vers l'app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    } else {
      print('ℹ️ Utilisateur non connecté - Affichage login');
      // Naviguer vers l'écran de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animé
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.accent.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets,
                  size: 100,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'PetScan',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Analyse pour animaux',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 48),

            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
