import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import '../widgets/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.signInWithApple();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        // Connexion réussie - naviguer vers l'app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else if (!result.canceled) {
        // Erreur de connexion (sauf si annulée par l'utilisateur)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(result.error ?? 'Erreur de connexion')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      // Si canceled == true, ne rien faire (pas de message d'erreur)
    }
  }

  Future<void> _continueWithoutAccount() async {
    // Continuer sans compte (mode invité)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo et titre
              Container(
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
                  size: 80,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Bienvenue sur',
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 8),

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
                'Analyse et compare les produits\npour animaux 🐾',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Bouton Sign in with Apple
              if (_isLoading)
                const CircularProgressIndicator(color: AppColors.primary)
              else
                SignInWithAppleButton(
                  onPressed: _handleAppleSignIn,
                  text: 'Continuer avec Apple',
                  height: 56,
                  borderRadius: BorderRadius.circular(16),
                  style: SignInWithAppleButtonStyle.black,
                ),

              const SizedBox(height: 16),

              // Bouton continuer sans compte
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _continueWithoutAccount,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: AppColors.textSecondary),
                  ),
                  child: const Text(
                    'Continuer sans compte',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Texte légal
              const Text(
                'En continuant, vous acceptez nos conditions\nd\'utilisation et politique de confidentialité',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
