# 🛠️ Guides Techniques - PetScan

**Version**: 1.0.0  
**Date**: October 19, 2025

---

## Error Handling

### Usage

```dart
import 'package:croq_scan/core/utils/error_handler.dart';

logInfo('Message');
logError('Error', error, stackTrace);
handleError(context, e, stack, userMessage: 'Erreur');
```

### Configuration

- FlutterError.onError configuré
- runZonedGuarded dans main.dart
- Logger package intégré

---

## Accessibility

### Helpers

```dart
import 'package:croq_scan/core/utils/accessibility_helpers.dart';

AccessibleButton(label: 'Scanner', child: Icon(...))
AccessibleImage(label: 'Photo produit', child: Image(...))
MinimumTouchTarget(child: IconButton(...))
```

### WCAG AA

- Touch targets >= 48dp
- Semantic labels
- Contrast ratios validés

---

## i18n

### Usage

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)
```

### Fichiers

- lib/l10n/app_fr.arb (330 strings)
- Infrastructure prête multi-langues

---

## Tests

### Structure

```
test/
├── unit/ (services, models, widgets)
├── widget/ (screens, widgets)
├── integration/
├── lifecycle/
├── performance/
└── goldens/
```

### Coverage: 65%

---

## Architecture

### Structure

```
lib/
├── core/ (services, models, constants, utils)
├── ui/ (screens, widgets)
└── l10n/ (internationalization)
```
