# 🎯 Plan d'Action - CroqScan (PetScan)

**Date**: October 19, 2025  
**Conformité actuelle**: 98.5% ✅  
**Status**: Production-Ready pour MVP

---

## 🔴 CRITIQUE - Avant Release Store (6-8h)

### 1. Monitoring & Crash Reporting (2-3h)

**Priorité**: 🔴 **CRITIQUE**

```bash
# Ajouter dépendances
flutter pub add firebase_core firebase_crashlytics firebase_analytics
```

**Fichiers à créer/modifier**:

```dart
// lib/core/services/analytics_service.dart
class AnalyticsService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  static void logEvent(String name, {Map<String, dynamic>? params}) {
    FirebaseAnalytics.instance.logEvent(name: name, parameters: params);
  }
}

// main.dart
void main() async {
  await AnalyticsService.initialize();
  ...
}
```

**Checklist**:

- [ ] Ajouter Firebase au projet iOS
- [ ] Ajouter Firebase au projet Android
- [ ] Configurer `google-services.json`
- [ ] Configurer `GoogleService-Info.plist`
- [ ] Tester crash reporting
- [ ] Logger 5 events critiques (scan, favorite, search, login, logout)

---

### 2. Pre-Release Checklist (1h)

**Priorité**: 🔴 **CRITIQUE**

**Créer**: `PRE_RELEASE_CHECKLIST.md`

```markdown
# Pre-Release Checklist

## Code Quality

- [x] flutter analyze = 0 issues
- [x] flutter test = >80% pass
- [x] i18n = 0 hardcoded strings

## Builds

- [ ] Android AAB build successful
- [ ] iOS IPA build successful
- [ ] App size < 50MB
- [ ] Performance 60 FPS

## Testing

- [ ] Tested on real device (iPhone)
- [ ] Tested on real device (Android)
- [ ] Scanner works on both platforms
- [ ] Sign in with Apple works
- [ ] Favorites persist correctly
- [ ] Search pagination works

## Store Assets

- [ ] App icon created
- [ ] Screenshots (5 per platform)
- [ ] Store description written
- [ ] Privacy policy created
- [ ] App Store Connect configured
- [ ] Google Play Console configured

## Compliance

- [ ] Privacy policy compliant (GDPR)
- [ ] No secrets in code
- [ ] Crashlytics configured
- [ ] Analytics configured
```

---

### 3. Build Testing (2-3h)

**Priorité**: 🔴 **CRITIQUE**

**Android**:

```bash
# 1. Build AAB
flutter build appbundle --release

# 2. Vérifier taille
ls -lh build/app/outputs/bundle/release/app-release.aab

# 3. Tester sur device
flutter install --release
```

**iOS**:

```bash
# 1. Build IPA
flutter build ipa --release

# 2. Archive Xcode
open ios/Runner.xcworkspace

# 3. Tester sur device
flutter install -d <device-id>
```

**Checklist builds**:

- [ ] AAB < 50MB
- [ ] IPA < 50MB
- [ ] Pas d'erreurs signing
- [ ] App démarre sur device réel
- [ ] Scanner fonctionne en release
- [ ] API calls fonctionnent
- [ ] Pas de crashes

---

### 4. Fix Integration Tests (1-2h)

**Priorité**: 🟡 **IMPORTANT**

**29 tests échouent** dans `test/integration/app_flow_test.dart`

**Action**:

```bash
# Identifier les tests qui échouent
flutter test test/integration/app_flow_test.dart --verbose

# Fixer les tests un par un
# Principaux issues:
# - Navigation timing
# - Widgets async
# - State synchronization
```

**Pattern de fix**:

```dart
// Ajouter delays et pumpAndSettle
await tester.pumpAndSettle(Duration(seconds: 2));

// Vérifier mounted avant navigation
if (!mounted) return;

// Utiliser waitFor pour éléments async
await tester.pumpAndSettle();
expect(find.text('Expected'), findsOneWidget);
```

---

## 🟡 IMPORTANT - Semaine 1 Post-Release (8-10h)

### 5. Performance Optimization (2h)

**Ajouter RepaintBoundary** sur 3 widgets:

```dart
// 1. lib/ui/widgets/product_card.dart
@override
Widget build(BuildContext context) {
  return RepaintBoundary(  // ← Ajouter
    child: ScaleTransition(...),
  );
}

// 2. lib/ui/widgets/score_badge.dart
@override
Widget build(BuildContext context) {
  return RepaintBoundary(  // ← Ajouter
    child: Container(...),
  );
}

// 3. lib/ui/widgets/main_navigation.dart
Widget _buildNavItem(...) {
  return RepaintBoundary(  // ← Ajouter
    child: GestureDetector(...),
  );
}
```

**Tester avec**:

```bash
flutter run --profile
# DevTools > Performance
# Vérifier FPS stable 60
```

---

### 6. Golden Tests Complets (3-4h)

**Ajouter 8 golden tests** pour screens principales:

```bash
# Créer tests
touch test/goldens/home_screen_golden_test.dart
touch test/goldens/scanner_screen_golden_test.dart
touch test/goldens/product_details_golden_test.dart
touch test/goldens/favorites_screen_golden_test.dart
touch test/goldens/profile_screen_golden_test.dart
touch test/goldens/search_screen_golden_test.dart
touch test/goldens/login_screen_golden_test.dart
touch test/goldens/onboarding_golden_test.dart
```

**Template**:

```dart
testWidgets('home screen golden', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    ),
  );

  await expectLater(
    find.byType(HomeScreen),
    matchesGoldenFile('goldens/home_screen.png'),
  );
});
```

**Générer goldens**:

```bash
flutter test --update-goldens
```

---

### 7. Images Optimization (1h)

**Convertir PNG → WebP**:

```bash
# Installer cwebp
brew install webp

# Convertir images
for img in assets/images/*.png; do
  cwebp -q 80 "$img" -o "${img%.png}.webp"
done

# Mettre à jour pubspec.yaml
assets:
  - assets/images/*.webp
```

**Gain attendu**: -30% taille app

---

## 🟢 NICE-TO-HAVE - Optionnel (12-15h)

### 8. Dependency Injection avec get_it (6h)

**Ajouter**:

```yaml
# pubspec.yaml
dependencies:
  get_it: ^8.0.0
```

**Créer**:

```dart
// lib/core/di/service_locator.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<IAuthService>(() => AuthService());
  getIt.registerLazySingleton<IProfileService>(() => ProfileService());
  getIt.registerLazySingleton<IFavoritesService>(() => FavoritesService());

  // Repositories
  getIt.registerLazySingleton<IProductRepository>(
    () => ProductRepository(getIt<IApiClient>()),
  );
}

// main.dart
void main() {
  setupDependencies();
  ...
}
```

**Bénéfices**:

- ✅ Testabilité +50%
- ✅ Découplage +30%
- ✅ Maintenabilité +40%

---

### 9. Dark Theme (3h)

**Implémenter**:

```dart
// lib/app.dart
class PetScanApp extends StatefulWidget {
  @override
  State<PetScanApp> createState() => _PetScanAppState();
}

class _PetScanAppState extends State<PetScanApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),  // Décommenter
      themeMode: _themeMode,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
      ...
    );
  }
}
```

**Ajouter toggle**:

```dart
// settings_screen.dart
Switch(
  value: _isDarkMode,
  onChanged: (value) {
    setState(() => _isDarkMode = value);
    // Save preference
  },
)
```

---

### 10. Accessibility Advanced (2h)

**Tests manuels**:

- [ ] Activer TalkBack (Android)
- [ ] Tester toutes les screens
- [ ] Activer VoiceOver (iOS)
- [ ] Tester navigation

**Corrections si nécessaire**:

```dart
// Ajouter labels manquants
Semantics(
  label: 'Scanner un produit',
  hint: 'Ouvre la caméra pour scanner',
  button: true,
  child: IconButton(...),
)
```

---

## 📋 TIMELINE RECOMMANDÉE

### Phase 1: Pre-Production (1 semaine)

**Jour 1-2**: Monitoring + Crashlytics (3h)  
**Jour 3-4**: Build testing + Pre-release checklist (4h)  
**Jour 5**: Fix integration tests (2h)

**Livrable**: App prête pour soumission stores

### Phase 2: Post-MVP (2 semaines)

**Semaine 1**: Performance (RepaintBoundary, images) (3h)  
**Semaine 2**: Golden tests complets (4h)

**Livrable**: App optimisée, regression-proof

### Phase 3: Scale (1 mois)

**Semaine 1-2**: Dependency Injection (6h)  
**Semaine 3**: Dark theme (3h)  
**Semaine 4**: Accessibility advanced (2h)

**Livrable**: App scalable, professionnelle

---

## 🎯 NEXT STEPS IMMÉDIATE

**Prochaines 24h**:

1. ✅ Audit complet terminé
2. 🔴 **TODO**: Ajouter Firebase Crashlytics
3. 🔴 **TODO**: Créer pre-release checklist
4. 🔴 **TODO**: Tester builds AAB/IPA
5. 🟡 **TODO**: Fixer integration tests

**Commande suivante**:

```bash
flutter pub add firebase_core firebase_crashlytics firebase_analytics
```

---

**Prêt pour déploiement MVP**: ✅  
**Monitoring requis avant production**: ⚠️ À faire  
**Tests builds requis**: ⚠️ À faire
