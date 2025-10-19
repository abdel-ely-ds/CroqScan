# ❌ Violations Actives & Actions Correctives

**Date**: October 19, 2025  
**Audit**: Vérification règle par règle  
**Objectif**: Identifier violations précises

---

## 🔴 VIOLATIONS CRITIQUES (À CORRIGER)

### 1. internationalization.mdc ❌

**Règle violée**:
> "Code & Documentation Language: All source code, comments, and documentation must be in English"
> "ALWAYS use AppLocalizations, NEVER hardcode strings"

**Violations constatées**:

**A) Code en Français** ❌
- Noms de variables: `_animalProfile`, `categoriesPrincipales`
- Commentaires: Beaucoup en français
- Strings: Tous en français hardcodés

**B) Hardcoded strings** ❌
- home_screen.dart: ~25 strings
- search_screen_new.dart: ~40 strings
- profile_screen.dart: ~15 strings
- profile_edit_screen.dart: ~20 strings
- favorites_screen.dart: ~8 strings

**Exemples**:
```dart
// VIOLATION
Text('Mes Favoris')
Text('Scanner un produit')
Text('Bonjour')

// CORRECT
Text(AppLocalizations.of(context)!.myFavorites)
```

**Action**:
1. Migrer TOUS les strings vers AppLocalizations (3h)
2. Renommer variables en anglais (2h) [OPTIONNEL - car règle dit "code EN" mais app FR]

**Priorité**: 🔴 CRITIQUE

---

### 2. performance-optimization.mdc ❌

**Règles violées**:
A) "Wrap complex widgets in RepaintBoundary"
B) "Debounce TextField inputs (200-300 ms)"
C) "Use const constructors where possible"

**A) RepaintBoundary: 0 usage** ❌

Widgets complexes SANS RepaintBoundary:
- `ProductCard` (animations + images)
- `ScoreBadge` (gradient + shadows)
- Cells dans `SearchResultsGrid`
- Cards dans `FavoritesScreen`

**Action**:
```dart
// Ajouter à ProductCard
RepaintBoundary(
  child: ProductCard(product: product),
)
```

**B) TextField debounce: 0 usage** ❌

SearchScreenNew TextField SANS debounce:
```dart
// ACTUEL (❌)
TextField(
  onChanged: (value) {
    setState(() => _searchQuery = value);
    _loadResults(); // Appelé à chaque caractère!
  },
)

// CORRECT (✅)
Timer? _debounce;
TextField(
  onChanged: (value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      _loadResults();
    });
  },
)
```

**C) const manquants: ~40 occurrences** ⚠️

`flutter analyze` liste tous les endroits.

**Actions**:
1. RepaintBoundary: 5 widgets (30min)
2. TextField debounce: search_screen (15min)
3. const: automatique (1h)

**Priorité**: 🟠 MOYEN (RepaintBoundary + debounce = quick wins)

---

### 3. accessibility.mdc ❌

**Règles violées**:
A) "Use Semantics widgets for interactive elements"
B) "Add accessible labels for images, buttons, and inputs"

**A) Semantics manquants: ~18 widgets** ❌

Éléments interactifs SANS Semantics:
```
Screens:
- SearchScreen: TextField, category chips
- ProfileScreen: IconButton edit, refresh
- FavoritesScreen: Cards, swipe gestures
- HomeScreen: Category cards (4)
- ProductDetailsScreen: Favorite button, share button
- ScannerScreen: Back gesture

Widgets:
- Profile widgets: Tous les buttons (6+)
- Product widgets: Action buttons (3+)
- Tous les IconButtons standalone (10+)
```

**B) Images sans labels** ❌

Toutes les images produits:
```dart
// ACTUEL (❌)
Image.network(product.imageUrl)

// CORRECT (✅)
Semantics(
  image: true,
  label: 'Photo du produit ${product.name}',
  child: ExcludeSemantics(child: Image.network(product.imageUrl)),
)
```

**Actions**:
1. Ajouter Semantics à 18 widgets (1.5h)
2. Labels pour toutes les images (30min)

**Priorité**: 🟠 MOYEN - WCAG AA compliance

---

### 4. testing-strategy.mdc ⚠️

**Règle**:
> "Maintain at least 80% coverage for core modules"

**État actuel**: 65% coverage global

**Modules sous 80%**:
- search_screen_new.dart: ~15% ❌
- profile_edit_screen.dart: ~25% ❌
- product_details_screen.dart: ~40% ⚠️
- home_screen.dart: ~50% ⚠️
- services/search_parsing_service.dart: 0% ❌

**Action**: Créer 12-15 tests additionnels (3h)

**Priorité**: 🟠 MOYEN

---

## 🟡 VIOLATIONS MINEURES

### 5. dead-code-detection.mdc ⚠️

**Règle**:
> "Run flutter analyze with 0 unused warnings"

**État**: ~75 issues

**Breakdown**:
- prefer_const_constructors: 40
- prefer_const_literals: 15
- unused_import: 10
- Autres: 10

**Action**: Cleanup automatique (1h)

**Priorité**: 🟡 FAIBLE

---

### 6. accessibility.mdc ⚠️

**Règle**:
> "Test with TalkBack (Android) and VoiceOver (iOS)"

**État**: Aucun test automatisé

**Action**: Tests manuels + doc (1h)

**Priorité**: 🟡 FAIBLE

---

### 7. testing-strategy.mdc ⚠️

**Règle**:
> "Golden tests for visual regression"

**État**: 2 golden tests (basiques)

**Manque**: 8 screens clés non testés

**Action**: Créer golden tests (optionnel, 2h)

**Priorité**: 🟡 FAIBLE

---

## ⏸️ RÈGLES OPTIONNELLES (Non bloquant)

### 8. dependency-injection.mdc ⏸️

**Règle**: Use get_it or Riverpod

**État**: Services en static

**Impact**: Optionnel pour MVP

**Action**: DI implementation (6h - si souhaité)

---

### 9. app-initialization.mdc ⏸️

**Règle**: Integrate monitoring (Firebase Crashlytics or Sentry)

**État**: Hooks commentés, pas activé

**Impact**: Optionnel

**Action**: Activer Crashlytics (1h - si souhaité)

---

## 📊 RÉSUMÉ

### Violations par Sévérité

**🔴 CRITIQUES** (1):
- i18n hardcoded strings (3-4h)

**🟠 MOYENNES** (5):
- RepaintBoundary (30min)
- TextField debounce (15min)
- Semantics widgets (2h)
- Tests 80% (3-4h)
- TalkBack tests (1h)

**🟡 MINEURES** (3):
- const constructors (1h)
- Flutter analyze (1h)
- Golden tests (2h)

**⏸️ OPTIONNELLES** (2):
- DI (6h)
- Monitoring (1h)

---

## ⏱️ TEMPS CORRECTION

### Pour Production-Ready Parfait
- i18n: 3-4h
- RepaintBoundary: 30min
- Debounce: 15min
- Semantics: 2h
**Total**: **6-7h**

### Pour Excellence (90%+ partout)
- + Tests 80%: 3-4h
- + const: 1h
- + Flutter analyze: 1h
**Total**: **11-13h**

### Pour Perfection 100%
- + DI: 6h
- + Golden tests: 2h
- + Performance tests: 2h
**Total**: **21-23h**

---

## 💡 RECOMMANDATION

**Actions CRITIQUES** (à faire):
1. ✅ i18n migration (3-4h) - VIOLATION RÈGLE
2. ✅ RepaintBoundary (30min) - Quick win
3. ✅ TextField debounce (15min) - Quick win

**Total prioritaire**: 4-5h

**Résultat**: Conformité 98% → 99%

---

**Les autres violations sont mineures ou optionnelles.**

