import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';

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
    // Afficher un message de confirmation avant de se connecter
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.apple, color: Colors.black),
            SizedBox(width: 12),
            Text('Se connecter'),
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
            label: const Text('Continuer'),
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
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Connecté avec succès !'),
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
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
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AuthService.logout();

      // Recharger le profil (mode invité)
      await _loadProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Déconnexion réussie - Mode invité activé'),
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
            SliverToBoxAdapter(child: _buildHeader()),

            // Contenu
            if (_profile == null)
              _buildEmptyState()
            else
              _buildProfileContent(),

            // Espace pour la navbar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _profile != null ? _profile!.name : 'Mon Compte',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          if (_profile != null)
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _loadProfile,
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    tooltip: 'Actualiser',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                    tooltip: 'Modifier',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Message mode invité si pas connecté
              if (_appleUser == null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.pastelPeach,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '⚠️',
                        style: TextStyle(fontSize: 32),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Mode Invité',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Connectez-vous pour sauvegarder vos données de manière sécurisée',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.pastelPeach,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Text('🐾', style: TextStyle(fontSize: 80)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Créer le profil de ton animal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Dis-nous en plus sur ton compagnon pour des recommandations personnalisées ! 🐾',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text(
                    'Créer un profil',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet hero section
            _buildPetHero(),
            const SizedBox(height: 24),

            // Stats cards grid
            _buildStatsGrid(),

            const SizedBox(height: 24),

            // Section informations animal
            if (_profile!.breed != null || 
                _profile!.ageYears != null || 
                _profile!.weightKg != null || 
                _profile!.isNeutered != null)
              _buildInfoCard(
                title: 'Informations détaillées',
                icon: Icons.info_outline_rounded,
                children: [
                  if (_profile!.breed != null)
                    _buildDetailRow(Icons.pets_rounded, 'Race', _profile!.breed!),
                  if (_profile!.ageYears != null)
                    _buildDetailRow(
                      Icons.cake_rounded,
                      'Âge',
                      '${_profile!.ageYears} an${_profile!.ageYears! > 1 ? 's' : ''}',
                    ),
                  if (_profile!.weightKg != null)
                    _buildDetailRow(
                      Icons.monitor_weight_rounded,
                      'Poids',
                      '${_profile!.weightKg} kg',
                    ),
                  if (_profile!.isNeutered != null)
                    _buildDetailRow(
                      Icons.medical_services_rounded,
                      'Stérilisé(e)',
                      _profile!.isNeutered! ? 'Oui' : 'Non',
                    ),
                ],
              ),

            const SizedBox(height: 16),

            // Section préférences
            if (_profile!.foodType != null ||
                _profile!.allergies.isNotEmpty ||
                _profile!.preferredBrand != null ||
                _profile!.healthGoals.isNotEmpty)
              _buildInfoCard(
                title: 'Préférences alimentaires',
                icon: Icons.restaurant_rounded,
                children: [
                  if (_profile!.foodType != null)
                    _buildDetailRow(
                      Icons.fastfood_rounded,
                      'Type d\'alimentation',
                      _getFoodTypeName(_profile!.foodType!),
                    ),
                  if (_profile!.allergies.isNotEmpty)
                    _buildDetailRow(
                      Icons.warning_amber_rounded,
                      'Allergies',
                      _profile!.allergies.join(', '),
                    ),
                  if (_profile!.preferredBrand != null)
                    _buildDetailRow(
                      Icons.favorite_rounded,
                      'Marque préférée',
                      _profile!.preferredBrand!,
                    ),
                  if (_profile!.healthGoals.isNotEmpty)
                    _buildDetailRow(
                      Icons.fitness_center_rounded,
                      'Objectifs santé',
                      _profile!.healthGoals.join(', '),
                    ),
                ],
              ),

            const SizedBox(height: 16),

            // Section compte - Invité ou Apple
            _buildAccountCard(),

            const SizedBox(height: 16),

            // Section paramètres
            _buildInfoCard(
              title: 'Paramètres',
              icon: Icons.settings_rounded,
              children: [
                _buildActionRow(
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
                _buildActionRow(
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
                _buildActionRow(
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
            if (_appleUser == null)
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
                  onPressed: _handleLogin,
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
                  onPressed: _handleLogout,
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

  Widget _buildPetHero() {
    final isDog = _profile!.animalType == 'dog';
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
        border: Border.all(
          color: heroColor.withValues(alpha: 0.2),
          width: 1,
        ),
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
                  _profile!.name,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getAnimalEmoji(_profile!.animalType)} ${_getAnimalTypeName(_profile!.animalType)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_profile!.breed != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _profile!.breed!,
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

  // Stats grid with key information
  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.pets_rounded,
            label: 'Type',
            value: _getAnimalTypeName(_profile!.animalType),
            color: _profile!.animalType == 'dog' 
                ? AppColors.dogColor 
                : AppColors.catColor,
          ),
        ),
        const SizedBox(width: 12),
        if (_profile!.ageYears != null)
          Expanded(
            child: _buildStatCard(
              icon: Icons.cake_rounded,
              label: 'Âge',
              value: '${_profile!.ageYears} an${_profile!.ageYears! > 1 ? 's' : ''}',
              color: AppColors.pastelPeach,
            ),
          ),
        if (_profile!.ageYears == null)
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite_rounded,
              label: 'Statut',
              value: _profile!.isNeutered == true ? 'Stérilisé' : 'Info',
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
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
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
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
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
            style: TextStyle(
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

  // New info card design
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
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
          ...children,
        ],
      ),
    );
  }

  // Detail row with icon
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.pastelLavender.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Account card with special styling
  Widget _buildAccountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _appleUser != null
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
          color: _appleUser != null
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
                  color: _appleUser != null ? Colors.black : AppColors.pastelYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _appleUser != null ? Icons.apple : Icons.warning_amber_rounded,
                  color: _appleUser != null ? Colors.white : AppColors.textPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _appleUser != null ? 'Compte Apple' : 'Mode Invité',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_appleUser != null) ...[
            _buildDetailRow(Icons.check_circle_rounded, 'Statut', 'Connecté'),
            if (_appleUser!.email != null)
              _buildDetailRow(Icons.email_rounded, 'Email', _appleUser!.email!),
            if (_appleUser!.name != null)
              _buildDetailRow(Icons.person_rounded, 'Nom', _appleUser!.name!),
          ] else ...[
            _buildDetailRow(Icons.warning_rounded, 'Statut', 'Non connecté'),
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
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
                  color: AppColors.pastelLavender,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
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
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 6, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
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
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAnimalIcon(String type) {
    switch (type) {
      case 'dog':
        return Icons.pets;
      case 'cat':
        return Icons.pets;
      case 'bird':
        return Icons.flutter_dash;
      default:
        return Icons.pets;
    }
  }

  String _getAnimalEmoji(String type) {
    switch (type) {
      case 'dog':
        return '🐕';
      case 'cat':
        return '🐈';
      case 'bird':
        return '🦜';
      case 'rabbit':
        return '🐰';
      default:
        return '🐾';
    }
  }

  String _getAnimalTypeName(String type) {
    switch (type) {
      case 'dog':
        return 'Chien';
      case 'cat':
        return 'Chat';
      case 'bird':
        return 'Oiseau';
      case 'rabbit':
        return 'Lapin';
      default:
        return 'Autre';
    }
  }

  String _getFoodTypeName(String type) {
    switch (type) {
      case 'dry':
        return 'Croquettes';
      case 'wet':
        return 'Pâtée';
      case 'mixed':
        return 'Mixte';
      default:
        return type;
    }
  }
}

// Écran d'édition du profil
class ProfileEditScreen extends StatefulWidget {
  final AnimalProfile? profile;
  final String? userName;
  final VoidCallback onSaved;

  const ProfileEditScreen({
    super.key,
    this.profile,
    this.userName,
    required this.onSaved,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _userNameController;

  String _animalType = 'dog';
  bool? _isNeutered;
  String? _foodType;
  final List<String> _allergies = [];
  String? _preferredBrand;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.name ?? '');
    _breedController = TextEditingController(text: widget.profile?.breed ?? '');
    _ageController = TextEditingController(
      text: widget.profile?.ageYears?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.profile?.weightKg?.toString() ?? '',
    );
    _userNameController = TextEditingController(text: widget.userName ?? '');

    if (widget.profile != null) {
      _animalType = widget.profile!.animalType;
      _isNeutered = widget.profile!.isNeutered;
      _foodType = widget.profile!.foodType;
      _allergies.addAll(widget.profile!.allergies);
      _preferredBrand = widget.profile!.preferredBrand;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = AnimalProfile(
      name: _nameController.text,
      animalType: _animalType,
      breed: _breedController.text.isEmpty ? null : _breedController.text,
      ageYears: _ageController.text.isEmpty
          ? null
          : int.tryParse(_ageController.text),
      weightKg: _weightController.text.isEmpty
          ? null
          : double.tryParse(_weightController.text),
      isNeutered: _isNeutered,
      foodType: _foodType,
      allergies: _allergies,
      preferredBrand: _preferredBrand,
      healthGoals: const [],
    );

    await ProfileService.saveProfile(profile);

    if (_userNameController.text.isNotEmpty) {
      await ProfileService.saveUserName(_userNameController.text);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Profil sauvegardé'),
          backgroundColor: AppColors.scoreExcellent,
          behavior: SnackBarBehavior.floating,
        ),
      );

      widget.onSaved();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.profile == null ? 'Créer un profil' : 'Modifier le profil',
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Enregistrer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Nom de l'animal
            const Text(
              'Comment s\'appelle ton compagnon ? 🐾',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Ex: Milo, Luna, Rex...',
                prefixIcon: Icon(Icons.pets),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nom est obligatoire';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Type d'animal
            const Text(
              'Quel type d\'animal ?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAnimalTypeChip('dog', '🐕 Chien', AppColors.dogColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnimalTypeChip('cat', '🐈 Chat', AppColors.catColor),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Race (optionnel)
            const Text(
              'Race (optionnel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(
                hintText: 'Ex: Labrador, Persan...',
                prefixIcon: Icon(Icons.category),
              ),
            ),

            const SizedBox(height: 24),

            // Âge et Poids
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Âge (années)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Ex: 4',
                          prefixIcon: Icon(Icons.cake),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Poids (kg)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Ex: 20',
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stérilisé
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.medical_services_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Stérilisé(e)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isNeutered ?? false,
                    onChanged: (value) {
                      setState(() {
                        _isNeutered = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),

            // Type d'alimentation
            const Text(
              'Type d\'alimentation préféré',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                _buildFoodTypeChip('dry', '🦴 Croquettes'),
                _buildFoodTypeChip('wet', '🥫 Pâtée'),
                _buildFoodTypeChip('mixed', '🍽️ Mixte'),
              ],
            ),

            const SizedBox(height: 32),

            // Nom utilisateur
            const Text(
              'Ton prénom (optionnel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _userNameController,
              decoration: const InputDecoration(
                hintText: 'Ex: Sophie',
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 32),

            // Bouton sauvegarder
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.check, size: 22),
                label: const Text(
                  'Enregistrer le profil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalTypeChip(String type, String label, Color color) {
    final isSelected = _animalType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _animalType = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? color : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildFoodTypeChip(String type, String label) {
    final isSelected = _foodType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _foodType = isSelected ? null : type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
