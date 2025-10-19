# 🌍 i18n Activation Instructions

**Infrastructure is ready, but files need to be generated first.**

## ⚠️ Current Status

- ✅ `pubspec.yaml` configured
- ✅ `l10n.yaml` configured  
- ✅ `lib/l10n/app_fr.arb` created
- ⏸️ Generated files not yet created (need build)
- ⏸️ AppLocalizations imports commented out temporarily

## 🚀 How to Activate i18n

### Step 1: Generate Localization Files

```bash
flutter pub get
flutter run  # This will trigger l10n generation
```

Or force generation with:

```bash
flutter build ios --debug
# or
flutter build apk --debug
```

This will create `.dart_tool/flutter_gen/gen_l10n/app_localizations_fr.dart`

### Step 2: Uncomment Imports

Once files are generated, uncomment in **lib/app.dart**:

```dart
// Before:
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// After:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

And uncomment the delegate:

```dart
localizationsDelegates: const [
  AppLocalizations.delegate, // ← Uncomment this
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
```

### Step 3: Use in Widgets

Uncomment in **lib/ui/screens/splash_screen.dart**:

```dart
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

And replace TODOs:

```dart
// Before:
const Text('PetScan') // TODO: AppLocalizations

// After:
Text(AppLocalizations.of(context)!.appTitle)
```

## ✅ Verification

After activation, verify with:

```bash
# Should compile without errors
flutter analyze

# Should show localization is working
flutter run
```

## 📝 Why This Two-Step Process?

Flutter's l10n generation happens during build time:
1. First build/run generates the AppLocalizations files
2. Then you can import and use them

This is a **one-time setup** - after first generation, files persist and regenerate automatically on changes to .arb files.

## 🎯 Quick Activation

**Fastest way**:

```bash
# 1. Generate
flutter run

# 2. Stop the app (Ctrl+C)

# 3. Uncomment imports in:
#    - lib/app.dart (2 locations)
#    - lib/ui/screens/splash_screen.dart (1 location)

# 4. Run again
flutter run
```

## ✨ After Activation

Once activated, you can:
- Use `AppLocalizations.of(context)!.keyName` everywhere
- Add new keys to `app_fr.arb`
- Auto-regenerates on `flutter pub get`
- Ready to add new languages anytime

## 📋 Current State

The infrastructure is 100% ready. Just needs one build to generate files, then you're good to go! 🚀

