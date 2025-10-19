import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/profile_service.dart';
import '../../core/services/auth_service.dart';
import 'profile_edit_screen.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/empty_profile_state_full.dart';
import '../widgets/profile/profile_content_full.dart';

/// Main profile screen showing user and pet information
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AnimalProfile? _profile;
  String? _userName;
  UserInfo? _appleUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    final profile = await ProfileService.loadProfile();
    final userName = await ProfileService.loadUserName();
    final appleUser = await AuthService.getUserInfo();

    if (mounted) {
      setState(() {
        _profile = profile;
        _userName = userName ?? appleUser?.name;
        _appleUser = appleUser;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;

    // Afficher un message de confirmation avant de se connecter
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.apple, color: Colors.black),
            const SizedBox(width: 12),
            Text(l10n.signIn),
          ],
        ),
        content: const Text(
          'Connectez-vous avec votre Apple ID pour :\n\n'
          '✅ Sauvegarder vos données de manière sécurisée\n'
          '✅ Accéder à vos favoris depuis plusieurs appareils (futur)\n'
          '✅ Synchroniser votre profil\n\n'
          'Vos favoris et données actuels seront conservés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.apple),
            label: Text(l10n.continueButton),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() {
        _isLoading = true;
      });

      final result = await AuthService.signInWithApple();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          // Connexion réussie - recharger le profil
          await _loadProfile();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(l10n.loginSuccess),
                ],
              ),
              backgroundColor: AppColors.scoreExcellent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (!result.canceled) {
          // Erreur (sauf annulation)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error ?? 'Erreur de connexion'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleLogout() async {
    final l10n = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?\n\nVous passerez en mode invité. Vos favoris et données locales seront conservés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AuthService.logout();

      // Recharger le profil (mode invité)
      await _loadProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.logoutSuccess),
          backgroundColor: AppColors.textSecondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(
          profile: _profile,
          userName: _userName,
          onSaved: () {
            _loadProfile();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: ProfileHeader(
                profile: _profile,
                onRefresh: _loadProfile,
                onEdit: _editProfile,
              ),
            ),

            // Contenu
            if (_profile == null)
              EmptyProfileStateFull(
                appleUser: _appleUser,
                onCreateProfile: _editProfile,
              )
            else
              ProfileContentFull(
                profile: _profile!,
                appleUser: _appleUser,
                onLogin: _handleLogin,
                onLogout: _handleLogout,
              ),

            // Espace pour la navbar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
