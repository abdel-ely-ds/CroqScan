# 🎨 GOLDEN TESTS SETUP - PetScan

**Status**: Infrastructure prête  
**Tests créés**: 0 (à créer)  
**Date**: October 19, 2025

---

## 📋 QU'EST-CE QUE LES GOLDEN TESTS?

Les golden tests capturent des screenshots de widgets et les comparent à des images de référence pour détecter les régressions visuelles.

---

## 🚀 SETUP

### Dépendances

```yaml
# pubspec.yaml (déjà inclus)
dev_dependencies:
  flutter_test:
    sdk: flutter
```

### Structure

```
test/
└── goldens/
    ├── golden_tests_setup.md (ce fichier)
    ├── home_screen_golden_test.dart (à créer)
    ├── product_card_golden_test.dart (à créer)
    └── images/
        ├── home_screen.png
        ├── product_card.png
        └── ...
```

---

## 📝 EXEMPLE GOLDEN TEST

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen golden test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    
    await tester.pumpAndSettle();
    
    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('goldens/images/home_screen.png'),
    );
  });
}
```

---

## 🎯 TESTS À CRÉER

### Priorité 1 - Screens
- [ ] home_screen_golden_test.dart
- [ ] search_screen_golden_test.dart
- [ ] product_details_golden_test.dart
- [ ] profile_screen_golden_test.dart
- [ ] favorites_screen_golden_test.dart

### Priorité 2 - Widgets
- [ ] product_card_golden_test.dart
- [ ] score_badge_golden_test.dart
- [ ] main_navigation_golden_test.dart

### Priorité 3 - Components
- [ ] health_score_card_golden_test.dart
- [ ] ingredients_card_golden_test.dart

---

## 🔧 COMMANDES

### Générer Golden Files

```bash
# Générer/update golden images
flutter test --update-goldens

# Tester avec goldens
flutter test test/goldens/
```

### Bonnes Pratiques

1. **Stabiliser**: Désactiver animations
2. **Device fixe**: Utiliser même device size
3. **Fonts**: Spécifier fonts explicitly
4. **Network**: Mock images (pas de network)

---

## 📊 COUVERTURE GOLDEN

**Actuel**: 0/10 screens  
**Objectif**: 10/10 screens clés  
**Effort**: 2-3 heures

---

## ⏱️ TEMPS ESTIMÉ

- Setup infrastructure: ✅ Fait
- Créer 5 golden tests screens: 1.5h
- Créer 3 golden tests widgets: 45min
- Créer 2 golden tests components: 30min

**Total**: 2-3h

---

**Infrastructure prête! Prochaine étape: Créer les tests.**


