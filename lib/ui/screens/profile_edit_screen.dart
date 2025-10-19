import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/profile_service.dart';

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
  late TextEditingController _userNameController;
  String _selectedAnimalType = 'dog';
  String? _selectedBreed;
  int? _ageYears;
  int? _ageMonths;
  double? _weightKg;
  bool _isNeutered = false;
  String _selectedFoodType = 'croquettes';

  // Listes de races
  final Map<String, List<String>> _breeds = {
    'dog': [
      'Labrador',
      'Berger Allemand',
      'Golden Retriever',
      'Bouledogue Français',
      'Berger Australien',
      'Caniche',
      'Yorkshire',
      'Chihuahua',
      'Beagle',
      'Autre',
    ],
    'cat': [
      'Européen',
      'Persan',
      'Maine Coon',
      'Siamois',
      'British Shorthair',
      'Scottish Fold',
      'Bengal',
      'Sphynx',
      'Ragdoll',
      'Autre',
    ],
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.name ?? '');
    _userNameController = TextEditingController(text: widget.userName ?? '');

    if (widget.profile != null) {
      _selectedAnimalType = widget.profile!.animalType;
      _selectedBreed = widget.profile!.breed;
      _ageYears = widget.profile!.ageYears;
      _weightKg = widget.profile!.weightKg;
      _isNeutered = widget.profile!.isNeutered ?? false;
      _selectedFoodType = widget.profile!.foodType ?? 'croquettes';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    final profile = AnimalProfile(
      name: _nameController.text.trim(),
      animalType: _selectedAnimalType,
      breed: _selectedBreed,
      ageYears: _ageYears,
      weightKg: _weightKg,
      isNeutered: _isNeutered,
      foodType: _selectedFoodType,
    );

    await ProfileService.saveProfile(profile);

    // Sauvegarder le nom d'utilisateur si renseigné
    if (_userNameController.text.trim().isNotEmpty) {
      await ProfileService.saveUserName(_userNameController.text.trim());
    }

    widget.onSaved();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(l10n.profileSaved),
            ],
          ),
          backgroundColor: AppColors.scoreExcellent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          widget.profile == null ? 'Créer un profil' : 'Modifier le profil',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.check, color: AppColors.scoreExcellent),
            label: const Text(
              'Enregistrer',
              style: TextStyle(
                color: AppColors.scoreExcellent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Nom de l'utilisateur
            const Text(
              'Votre prénom',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                hintText: 'Ex: Marc',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nom de l'animal
            const Text(
              'Nom de votre animal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ex: Max, Luna, Simba...',
                prefixIcon: const Icon(Icons.pets),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Merci de renseigner un nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Type d'animal
            const Text(
              'Type d\'animal',
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
                  child: _buildAnimalTypeChip(
                    'dog',
                    '🐶 Chien',
                    AppColors.dogColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnimalTypeChip(
                    'cat',
                    '🐱 Chat',
                    AppColors.catColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Race
            const Text(
              'Race',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedBreed,
              decoration: InputDecoration(
                hintText: 'Sélectionner',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _breeds[_selectedAnimalType]!
                  .map(
                    (breed) =>
                        DropdownMenuItem(value: breed, child: Text(breed)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBreed = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Âge
            const Text(
              'Âge',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _ageYears,
                    decoration: InputDecoration(
                      hintText: 'Années',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: List.generate(21, (index) => index)
                        .map(
                          (age) => DropdownMenuItem(
                            value: age,
                            child: Text('$age an${age > 1 ? 's' : ''}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _ageYears = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _ageMonths,
                    decoration: InputDecoration(
                      hintText: 'Mois',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: List.generate(12, (index) => index)
                        .map(
                          (months) => DropdownMenuItem(
                            value: months,
                            child: Text('$months mois'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _ageMonths = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Poids
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
              initialValue: _weightKg?.toString() ?? '',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Ex: 12.5',
                suffixText: 'kg',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _weightKg = double.tryParse(value);
              },
            ),
            const SizedBox(height: 24),

            // Stérilisé
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.healing, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Stérilisé(e)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isNeutered,
                    onChanged: (value) {
                      setState(() {
                        _isNeutered = value;
                      });
                    },
                    activeThumbColor: AppColors.scoreExcellent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Type d'alimentation
            const Text(
              'Type d\'alimentation principal',
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
                _buildFoodTypeChip('croquettes', 'Croquettes'),
                _buildFoodTypeChip('patee', 'Pâtée'),
                _buildFoodTypeChip('mixte', 'Mixte'),
                _buildFoodTypeChip('barf', 'BARF'),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalTypeChip(String type, String label, Color color) {
    final isSelected = _selectedAnimalType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAnimalType = type;
          _selectedBreed = null; // Reset breed when changing animal type
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodTypeChip(String type, String label) {
    final isSelected = _selectedFoodType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFoodType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
