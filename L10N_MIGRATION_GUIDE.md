# i18n Migration Guide - PetScan

## 🎯 Objective

Migrate all hardcoded French strings to use ARB-based localization for easy future language expansion.

## 📋 Current Status

- ✅ Infrastructure setup (pubspec.yaml, l10n.yaml)
- ✅ app_fr.arb created with ~80 keys
- ✅ app.dart configured with AppLocalizations
- ⚠️ Screens still use hardcoded strings (to migrate)

## 🚀 How to Migrate a Screen

### Step 1: Import AppLocalizations

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### Step 2: Get l10n instance in build()

```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Text(l10n.appTitle); // Instead of Text('PetScan')
}
```

### Step 3: Replace hardcoded strings

**Before**:

```dart
Text('Ajouter aux favoris')
Text('Score Santé Global')
```

**After**:

```dart
Text(l10n.addToFavorites)
Text(l10n.globalHealthScore)
```

### Step 4: Add missing keys to app_fr.arb

If you need a new string, add it to `lib/l10n/app_fr.arb`:

```json
{
  "newKey": "Nouveau texte",
  "@newKey": {
    "description": "Description de la clé"
  }
}
```

Then run:

```bash
flutter pub get  # Regenerates AppLocalizations
```

## 📝 Migration Checklist

### Screens to Migrate (Priority Order)

- [ ] splash_screen.dart (1 string)
- [ ] login_screen.dart (~15 strings)
- [ ] home_screen.dart (~50 strings)
- [ ] favorites_screen.dart (~30 strings)
- [ ] product_details_screen.dart (~25 strings)
- [ ] profile_screen.dart (~40 strings)
- [ ] scanner_screen.dart (~10 strings)
- [ ] search_screen_new.dart (~20 strings)
- [ ] pet_onboarding_screen.dart (~20 strings)

### Widgets to Migrate

- [ ] main_navigation.dart (~10 strings)
- [ ] product_card.dart (~5 strings)
- [ ] product_details/\*.dart (~20 strings total)

## 🔍 Finding Hardcoded Strings

```bash
# Find all hardcoded Text widgets
grep -rn "Text('" lib/ui/screens/ | grep -v AppLocalizations

# Count remaining hardcoded strings
grep -r "Text('" lib/ui/ | grep -v AppLocalizations | wc -l
```

## 📦 Adding Strings with Parameters

**app_fr.arb**:

```json
{
  "welcomeUser": "Bonjour {userName} 👋",
  "@welcomeUser": {
    "description": "Message de bienvenue",
    "placeholders": {
      "userName": {
        "type": "String",
        "example": "Marc"
      }
    }
  },

  "productCount": "{count} produit(s)",
  "@productCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Usage**:

```dart
Text(l10n.welcomeUser('Marc'))
Text(l10n.productCount(5))
```

## 🎨 Example Migration: splash_screen.dart

**Before**:

```dart
const Text(
  'PetScan',
  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
)

const Text(
  'Analyse pour animaux',
  style: TextStyle(fontSize: 16),
)
```

**After**:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In build():
final l10n = AppLocalizations.of(context)!;

Text(
  l10n.appTitle,
  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
)

Text(
  l10n.welcomeDescription,
  style: const TextStyle(fontSize: 16),
)
```

**Add to app_fr.arb**:

```json
{
  "appTitle": "PetScan",
  "welcomeDescription": "Analyse pour animaux"
}
```

## ⚡ Quick Migration Tips

1. **Use helper extension** (optional):

   ```dart
   extension BuildContextL10n on BuildContext {
     AppLocalizations get l10n => AppLocalizations.of(this)!;
   }

   // Usage:
   Text(context.l10n.appTitle)
   ```

2. **Group related strings** in ARB:

   ```json
   {
     "homeTitle": "Accueil",
     "homeWelcome": "Bonjour",
     "homeRecentProducts": "Produits récents",
     ...
   }
   ```

3. **Use descriptive keys**:

   - ✅ `addToFavorites` (clear)
   - ❌ `btn1` (unclear)

4. **Test after each screen**:
   ```bash
   flutter run  # Verify UI still works
   ```

## 🧪 Testing l10n

```dart
testWidgets('Uses localization correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MyScreen(),
    ),
  );

  // Verify localized text appears
  expect(find.text('PetScan'), findsOneWidget);
});
```

## 📊 Progress Tracking

```bash
# Total strings to migrate: ~200
# Run this to see progress:
echo "Remaining: $(grep -r "Text('" lib/ui/ | grep -v AppLocalizations | wc -l)"
```

## 🎯 Estimated Effort

| Task          | Files         | Time     |
| ------------- | ------------- | -------- |
| Setup (DONE)  | -             | 1h ✅    |
| Splash screen | 1             | 10 min   |
| Login screen  | 1             | 30 min   |
| Home screen   | 1             | 1-2h     |
| Other screens | 6             | 3-4h     |
| Widgets       | 10            | 1-2h     |
| **Total**     | **~20 files** | **6-8h** |

## ✨ Benefits After Migration

1. **Easy to add English** - Just create app_en.arb and translate
2. **Centralized text** - All strings in one place
3. **Type-safe** - Compile-time checking
4. **Professional** - Standard Flutter practice
5. **Maintainable** - Easy to update text

## 🚀 When to Add English

Adding English in the future will be **easy** (~2-3 hours):

1. Copy `app_fr.arb` → `app_en.arb`
2. Translate strings
3. Add `Locale('en')` to supportedLocales
4. Add language switcher in profile
5. Done!

**No code changes needed** - that's the power of proper l10n! ✨
