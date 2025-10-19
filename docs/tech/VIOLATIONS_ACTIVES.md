# ❌ Violations Actives des Cursor Rules

**Date**: October 19, 2025  
**Audit**: Vérification systématique  
**Objectif**: Identifier TOUTES les non-conformités

---

## 🔴 VIOLATIONS CRITIQUES

### 1. internationalization.mdc - VIOLATION ACTIVE ❌

**Règle**:

> "ALWAYS use AppLocalizations, NEVER hardcode strings"

**Violation**:

```bash
# Hardcoded strings dans screens
lib/ui/screens/home_screen.dart: ~30 strings hardcodés
lib/ui/screens/search_screen_new.dart: ~50 strings hardcodés
lib/ui/screens/profile_screen.dart: ~20 strings hardcodés
lib/ui/screens/profile_edit_screen.dart: ~25 strings hardcodés
lib/ui/screens/product_details_screen.dart: ~15 strings hardcodés
lib/ui/screens/favorites_screen.dart: ~10 strings hardcodés
```

**Preuve**:

- `Text('Mes Favoris')` au lieu de `Text(l10n.myFavorites)`
- `Text('Scanner un produit')` hardcodé
- Etc.

**Impact**: 🔴 CRITIQUE - Violation directe règle "ALWAYS"

**Action requise**: Migrer TOUS les strings vers AppLocalizations

**Effort**: 3-4h

---

### 2. performance-optimization.mdc - VIOLATION ACTIVE ❌

**Règle**:

> "Use RepaintBoundary for complex widgets"

**Violation**:

```bash
# RepaintBoundary usage: 0 occurrences
grep -r "RepaintBoundary" lib/ → 0 résultats
```

**Widgets complexes sans RepaintBoundary**:

- ProductCard (animations + images)
- ScoreBadge (gradient + shadow)
- MainNavigation (bottom bar)
- Product details cards

**Impact**: 🟠 MOYEN - Performance suboptimale

**Action requise**: Ajouter RepaintBoundary sur 5-10 widgets

**Effort**: 30min

---

### 3. performance-optimization.mdc - VIOLATION ACTIVE ❌

**Règle**:

> "Debounce TextField inputs (200-300 ms)"

**Violation**:

```bash
# Debounce usage: 0 occurrences
grep -r "Timer\|debounce" lib/ → 0 résultats
```

**TextFields sans debounce**:

- SearchScreenNew: TextField de recherche (high-frequency)
- ProfileEditScreen: Form fields

**Impact**: 🟠 MOYEN - Lag potentiel sur recherche

**Action requise**: Debounce search TextField

**Effort**: 15min

---

### 4. accessibility.mdc - VIOLATION PARTIELLE ⚠️

**Règle**:

> "Use Semantics widgets for interactive elements"

**Violation**:

```bash
# Semantics usage: 2 occurrences (MainNavigation, ProductCard)
# Widgets interactifs sans Semantics: ~20+
```

**Éléments sans Semantics**:

- ProfileScreen: Edit/Refresh IconButtons
- FavoritesScreen: Product items
- HomeScreen: Category cards
- SearchScreen: TextField, filters
- ProductDetailsScreen: Favorite button, share button
- Tous les autres IconButtons

**Impact**: 🟠 MOYEN - Non conforme WCAG AA

**Action requise**: Ajouter Semantics aux 20+ widgets

**Effort**: 1-2h

---

### 5. performance-optimization.mdc - VIOLATION ACTIVE ❌

**Règle**:

> "Use const constructors where possible"

**Violation**:

```bash
# Flutter analyze montre ~40 prefer_const_constructors warnings
```

**Exemples**:

```dart
// lib/ui/screens/home_screen.dart
SizedBox(height: 16)  // Devrait être const
Text('...', style: TextStyle(...))  // Devrait être const
```

**Impact**: 🟡 FAIBLE - Performance mineure

**Action requise**: Ajouter const à ~40 widgets

**Effort**: 1h (automatisable)

---

## 🟠 VIOLATIONS MOYENNES

### 6. testing-strategy.mdc - NON SATISFAIT ⚠️

**Règle**:

> "Maintain at least 80% coverage for core modules"

**État actuel**: 65% coverage

**Modules sous 80%**:

- search_screen_new.dart: ~10% (987 lignes non testées)
- profile_edit_screen.dart: ~20%
- product_details_screen.dart: ~30%
- Widgets profile: ~40%
- Widgets product_details: ~50%

**Impact**: 🟠 MOYEN - Tests insuffisants

**Action requise**: Créer 15-20 tests additionnels

**Effort**: 3-4h

---

### 7. accessibility.mdc - NON SATISFAIT ⚠️

**Règle**:

> "Test with TalkBack (Android) and VoiceOver (iOS)"

**État actuel**: Aucun test TalkBack/VoiceOver

**Impact**: 🟠 MOYEN - Accessibility non validée

**Action requise**: Tests manuels ou automatisés

**Effort**: 1h

---

### 8. dead-code-detection.mdc - VIOLATION MINEURE ⚠️

**Règle**:

> "Run flutter analyze with 0 unused warnings"

**État actuel**: ~75 issues

**Issues**:

- unused_import: ~10
- prefer_const_constructors: ~40
- prefer_const_literals: ~15
- Autres: ~10

**Impact**: 🟡 FAIBLE - Dette technique

**Action requise**: Cleanup flutter analyze

**Effort**: 1h

---

## 🟡 VIOLATIONS MINEURES

### 9. performance-optimization.mdc - NON SATISFAIT ⚠️

**Règle**:

> "Generate performance tests using WidgetTester"

**État actuel**: 1 fichier performance test (basique)

**Manque**:

- Tests FPS pour ProductCard
- Tests rebuild count
- Tests scroll performance
- Tests memory leaks

**Impact**: 🟡 FAIBLE - Monitoring manquant

**Action requise**: Créer tests performance complets

**Effort**: 2h

---

### 10. dependency-injection.mdc - NON SATISFAIT ⏸️

**Règle**:

> "Use get_it or Riverpod"

**État actuel**: Aucun DI, services en static

**Impact**: 🟡 FAIBLE - Optionnel pour MVP

**Action requise**: Implémenter DI (si souhaité)

**Effort**: 6h

---

## ✅ RÈGLES 100% SATISFAITES

1. ✅ error-handling: FlutterError + Logger 100%
2. ✅ documentation-standards: MD consolidés conforme
3. ✅ null-safety: 100% null-safe
4. ✅ widget-lifecycle-safety: Aucune violation
5. ✅ meta-rules: Auto-amélioration possible
6. ✅ flutter-architecture: < 300L sauf exception
7. ✅ app-initialization: AppInitializer en place

---

## 📋 RÉSUMÉ VIOLATIONS

| #   | Règle             | Violation             | Sévérité     | Effort |
| --- | ----------------- | --------------------- | ------------ | ------ |
| 1   | **i18n**          | Hardcoded strings     | 🔴 CRITIQUE  | 3-4h   |
| 2   | **Performance**   | No RepaintBoundary    | 🟠 MOYEN     | 30min  |
| 3   | **Performance**   | No TextField debounce | 🟠 MOYEN     | 15min  |
| 4   | **Accessibility** | Semantics partiels    | 🟠 MOYEN     | 1-2h   |
| 5   | **Performance**   | const manquants (~40) | 🟡 FAIBLE    | 1h     |
| 6   | **Testing**       | Coverage 65% vs 80%   | 🟠 MOYEN     | 3-4h   |
| 7   | **Accessibility** | No TalkBack tests     | 🟠 MOYEN     | 1h     |
| 8   | **Dead Code**     | ~75 flutter analyze   | 🟡 FAIBLE    | 1h     |
| 9   | **Performance**   | No perf tests         | 🟡 FAIBLE    | 2h     |
| 10  | **DI**            | No get_it             | 🟡 OPTIONNEL | 6h     |

---

## ⏱️ TEMPS POUR CORRIGER

### Violations Critiques (🔴)

- i18n migration: 3-4h

### Violations Moyennes (🟠)

- RepaintBoundary: 30min
- TextField debounce: 15min
- Semantics: 1-2h
- Tests 80%: 3-4h
- TalkBack tests: 1h

**Total moyen**: 6-8h

### Violations Mineures (🟡)

- const: 1h
- Flutter analyze: 1h
- Performance tests: 2h

**Total mineur**: 4h

### Optionnel

- DI: 6h

**TOTAL pour corriger tout**: 16-20h

---

## 💡 PRIORISATION

### 🔴 À CORRIGER ABSOLUMENT

1. **i18n migration** (3-4h) - Violation règle "ALWAYS"

### 🟠 À CORRIGER FORTEMENT RECOMMANDÉ

2. **RepaintBoundary** (30min) - Quick win
3. **TextField debounce** (15min) - Quick win
4. **Semantics** (1-2h) - WCAG AA
5. **Tests 80%** (3-4h) - Standard qualité

### 🟡 Nice-to-have

6. **const** (1h)
7. **Flutter analyze** (1h)
8. **Performance tests** (2h)

### ⏸️ Optionnel

9. **DI** (6h)

---

**Je vais maintenant créer un plan d'action PRÉCIS pour chaque violation...**
