import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Will be generated
import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/profile_service.dart';
import '../../ui/widgets/main_navigation.dart';
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
    // Wait for splash animation
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    try {
      // Check authentication status
      final isLoggedIn = await AuthService.isLoggedIn();
      final profile = await ProfileService.loadProfile();

      if (!mounted) return;

      if (isLoggedIn) {
        debugPrint('✅ User already logged in - Auto-login');

        if (profile == null) {
          // Logged in but no profile - go to onboarding
          debugPrint('ℹ️ No profile found - Redirecting to onboarding');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PetOnboardingScreen(),
            ),
          );
        } else {
          // Logged in with profile - go to main app
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigation()),
          );
        }
      } else {
        debugPrint('ℹ️ User not logged in - Showing login screen');
        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error during auth check: $e');
      debugPrint('Stack trace: $stackTrace');

      if (!mounted) return;

      // On error, show login screen as fallback
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
              'PetScan', // TODO: AppLocalizations.of(context)!.appTitle
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Analyse pour animaux', // TODO: AppLocalizations.of(context)!.welcomeDescription
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
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
