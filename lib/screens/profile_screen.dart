import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AnimalProfile? _profile;
  String? _userName;
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

    if (mounted) {
      setState(() {
        _profile = profile;
        _userName = userName;
        _isLoading = false;
      });
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
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _profile != null
                  ? _getAnimalIcon(_profile!.animalType)
                  : Icons.person,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _profile != null
                      ? 'Profil de ${_profile!.name} ${_getAnimalEmoji(_profile!.animalType)}'
                      : 'Mon Profil',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _profile != null
                      ? 'Informations de ton compagnon'
                      : 'Crée le profil de ton animal',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_profile != null)
            IconButton(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit, color: AppColors.primary),
              tooltip: 'Modifier',
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
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
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
            // Section informations animal
            _buildSection(
              title: 'Informations',
              icon: Icons.pets,
              children: [
                _buildInfoRow('Nom', _profile!.name),
                _buildInfoRow('Type', _getAnimalTypeName(_profile!.animalType)),
                if (_profile!.breed != null)
                  _buildInfoRow('Race', _profile!.breed!),
                if (_profile!.ageYears != null)
                  _buildInfoRow(
                    'Âge',
                    '${_profile!.ageYears} an${_profile!.ageYears! > 1 ? 's' : ''}',
                  ),
                if (_profile!.weightKg != null)
                  _buildInfoRow('Poids', '${_profile!.weightKg} kg'),
                if (_profile!.isNeutered != null)
                  _buildInfoRow(
                    'Stérilisé(e)',
                    _profile!.isNeutered! ? 'Oui' : 'Non',
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Section préférences
            if (_profile!.foodType != null ||
                _profile!.allergies.isNotEmpty ||
                _profile!.preferredBrand != null)
              _buildSection(
                title: 'Préférences alimentaires',
                icon: Icons.restaurant,
                children: [
                  if (_profile!.foodType != null)
                    _buildInfoRow(
                      'Type d\'alimentation',
                      _getFoodTypeName(_profile!.foodType!),
                    ),
                  if (_profile!.allergies.isNotEmpty)
                    _buildInfoRow('Allergies', _profile!.allergies.join(', ')),
                  if (_profile!.preferredBrand != null)
                    _buildInfoRow('Marque préférée', _profile!.preferredBrand!),
                  if (_profile!.healthGoals.isNotEmpty)
                    _buildInfoRow(
                      'Objectifs santé',
                      _profile!.healthGoals.join(', '),
                    ),
                ],
              ),

            const SizedBox(height: 16),

            // Section paramètres
            _buildSection(
              title: 'Paramètres',
              icon: Icons.settings,
              children: [
                _buildActionRow(
                  icon: Icons.info_outline,
                  title: 'À propos de PetScan',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'PetScan',
                      applicationVersion: '1.0.0 (MVP)',
                      applicationLegalese: '© 2025 PetScan',
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
                  icon: Icons.help_outline,
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
                _buildActionRow(
                  icon: Icons.privacy_tip_outlined,
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
              ],
            ),
          ],
        ),
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
        borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
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
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 24),
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAnimalTypeChip('dog', '🐕 Chien', AppColors.dogColor),
                _buildAnimalTypeChip('cat', '🐈 Chat', AppColors.catColor),
                _buildAnimalTypeChip('bird', '🦜 Oiseau', AppColors.birdColor),
                _buildAnimalTypeChip(
                  'rabbit',
                  '🐰 Lapin',
                  AppColors.otherPetColor,
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
