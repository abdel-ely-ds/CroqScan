import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/profile_service.dart';
import '../widgets/main_navigation.dart';

class PetOnboardingScreen extends StatefulWidget {
  const PetOnboardingScreen({super.key});

  @override
  State<PetOnboardingScreen> createState() => _PetOnboardingScreenState();
}

class _PetOnboardingScreenState extends State<PetOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = 'cat'; // Default to cat
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Create basic profile
    final profile = AnimalProfile(
      name: _nameController.text.trim(),
      animalType: _selectedType,
      breed: null,
      ageYears: null,
      weightKg: null,
      isNeutered: null,
      foodType: null,
      allergies: const [],
      preferredBrand: null,
      healthGoals: const [],
    );

    await ProfileService.saveProfile(profile);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to main app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
      );
    }
  }

  void _skip() {
    // Skip profile creation and go to main app
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Header
                const Text(
                  'Bienvenue ! 🎉',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Parle-nous de ton compagnon',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // Pet illustration
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: AppColors.pastelLavender,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    _selectedType == 'dog' ? '🐕' : '🐱',
                    style: const TextStyle(fontSize: 80),
                  ),
                ),

                const SizedBox(height: 60),

                // Pet name input
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom de ton animal',
                    hintText: 'Ex: Milo, Luna, Felix...',
                    prefixIcon: const Icon(Icons.pets, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Entre le nom de ton animal';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Pet type selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Type d\'animal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTypeCard(
                        type: 'cat',
                        emoji: '🐱',
                        label: 'Chat',
                        color: AppColors.pastelLavender,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTypeCard(
                        type: 'dog',
                        emoji: '🐕',
                        label: 'Chien',
                        color: AppColors.pastelPeach,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Continuer',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Skip button
                TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Passer cette étape',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required String type,
    required String emoji,
    required String label,
    required Color color,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

