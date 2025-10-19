# 🔧 Refactoring Guide - profile_screen.dart

**Current Size**: 1598 lignes ❌  
**Target Size**: < 300 lignes ✅  
**Estimated Effort**: 4-6 heures

---

## 📊 Analyse du Fichier

### Méthodes à Extraire (14 widgets)

1. `_buildHeader()` - Ligne 210
2. `_buildEmptyState()` - Ligne 278
3. `_buildProfileContent()` - Ligne 391
4. `_buildPetHero()` - Ligne 605
5. `_buildStatsGrid()` - Ligne 690
6. `_buildStatCard()` - Ligne 727
7. `_buildInfoCard()` - Ligne 783
8. `_buildDetailRow()` - Ligne 826
9. `_buildAccountCard()` - Ligne 870
10. `_buildSection()` - Ligne 960
11. `_buildInfoRow()` - Ligne 1009
12. `_buildActionRow()` - Ligne 1046
13. `_buildAnimalTypeChip()` - Ligne 1535
14. `_buildFoodTypeChip()` - Ligne 1566

---

## 🎯 Plan d'Extraction

### Widgets à Créer dans `lib/ui/widgets/profile/`

```
lib/ui/widgets/profile/
├── profile_header.dart          (~70 lignes)
├── empty_profile_state.dart     (~115 lignes)
├── pet_hero_card.dart           (~85 lignes)
├── stats_grid_card.dart         (~60 lignes)
├── animal_info_card.dart        (~100 lignes)
├── account_card.dart            (~90 lignes)
├── profile_section.dart         (~50 lignes)
└── profile_helpers.dart         (~60 lignes) - Chips & rows
```

**Total widgets**: ~630 lignes réutilisables  
**profile_screen.dart résultant**: ~250 lignes ✅

---

## 📝 Extraction Priority

### Phase 1: Gros Composants (HIGH)
1. **pet_hero_card.dart** - _buildPetHero() + _buildStatsGrid() (~150 lignes)
2. **account_card.dart** - _buildAccountCard() (~90 lignes)
3. **empty_profile_state.dart** - _buildEmptyState() (~115 lignes)

**Réduction après Phase 1**: 1598 → ~1240 lignes

### Phase 2: Composants Moyens (MEDIUM)
4. **animal_info_card.dart** - _buildInfoCard() (~100 lignes)
5. **profile_section.dart** - _buildSection() (~50 lignes)
6. **profile_header.dart** - _buildHeader() (~70 lignes)

**Réduction après Phase 2**: ~1240 → ~1020 lignes

### Phase 3: Petits Composants (LOW)
7. **profile_helpers.dart** - Chips, rows, helpers (~200 lignes)

**Réduction finale**: ~1020 → ~250 lignes ✅

---

## 🔨 Example: pet_hero_card.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/profile_service.dart';

/// Widget displaying the pet hero section with stats
class PetHeroCard extends StatelessWidget {
  final AnimalProfile profile;

  const PetHeroCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDog = profile.animalType == 'dog';
    final heroColor = isDog ? AppColors.dogColor : AppColors.catColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            heroColor.withValues(alpha: 0.15),
            heroColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: heroColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Pet icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: heroColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDog ? Icons.pets : Icons.pets,
              size: 40,
              color: heroColor,
            ),
          ),
          const SizedBox(height: 16),
          // Pet name
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Pet type
          Text(
            _getAnimalTypeName(profile.animalType),
            style: TextStyle(color: heroColor),
          ),
          const SizedBox(height: 24),
          // Stats grid here...
        ],
      ),
    );
  }

  String _getAnimalTypeName(String type) {
    switch (type) {
      case 'dog': return 'Chien';
      case 'cat': return 'Chat';
      default: return 'Animal';
    }
  }
}
```

---

## ⚡ Quick Refactoring Steps

1. **Create widget file**:
   ```bash
   touch lib/ui/widgets/profile/pet_hero_card.dart
   ```

2. **Copy method** from profile_screen.dart

3. **Convert to widget**:
   - Change return type to `Widget build()`
   - Add required parameters
   - Extract dependencies

4. **Import in profile_screen.dart**:
   ```dart
   import '../widgets/profile/pet_hero_card.dart';
   ```

5. **Replace usage**:
   ```dart
   // Before:
   _buildPetHero()
   
   // After:
   PetHeroCard(profile: _profile!)
   ```

6. **Delete old method**

7. **Test**:
   ```bash
   flutter run
   ```

---

## 📋 Checklist

- [ ] Extract pet_hero_card.dart
- [ ] Extract account_card.dart
- [ ] Extract empty_profile_state.dart
- [ ] Extract animal_info_card.dart
- [ ] Extract profile_section.dart
- [ ] Extract profile_header.dart
- [ ] Extract profile_helpers.dart
- [ ] Update imports
- [ ] Test all functionalities
- [ ] Verify < 300 lines

---

## 🎯 Expected Result

**Before**:
```
profile_screen.dart: 1598 lignes ❌
```

**After**:
```
profile_screen.dart: ~250 lignes ✅
lib/ui/widgets/profile/
├── pet_hero_card.dart (150 lignes)
├── account_card.dart (90 lignes)
├── empty_profile_state.dart (115 lignes)
├── animal_info_card.dart (100 lignes)
├── profile_section.dart (50 lignes)
├── profile_header.dart (70 lignes)
└── profile_helpers.dart (60 lignes)
```

**Compliance**: Architecture 95% → 98% ✅

---

_See also: REFACTORING_GUIDE_search_screen.md for search screen refactoring_

