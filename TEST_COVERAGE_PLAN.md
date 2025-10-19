# 🎯 PLAN COMPLET POUR 100% COVERAGE

## 📊 ÉTAT ACTUEL

Tests: 30 passent / 56 total = 54% de réussite
Fichiers testés: 9
Fichiers source: 41
**Coverage actuel: ~25%**

## 📋 FICHIERS À TESTER

### ✅ Services testés (4/6):
- [x] auth_service_test.dart
- [x] favorites_service_test.dart  
- [x] profile_service_test.dart
- [x] scan_history_service_test.dart
- [ ] openpetfoodfacts_service.dart
- [ ] search_parsing_service.dart (nouveau)

### ✅ Models testés (1/1):
- [x] product_test.dart
- [x] product_health_score_test.dart

### ⚠️ Widgets testés (1/20):
- [x] product_card_test.dart
- [ ] score_badge.dart
- [ ] main_navigation.dart
- [ ] products_provider.dart
- [ ] profile/* (8 widgets)
- [ ] product_details/* (6 widgets)
- [ ] search/* (2 widgets)

### ⚠️ Screens testés (2/10):
- [x] home_screen_test.dart
- [x] product_details_screen_test.dart
- [ ] profile_screen.dart (nouveau refactorisé)
- [ ] profile_edit_screen.dart (nouveau)
- [ ] search_screen_new.dart
- [ ] scanner_screen.dart
- [ ] favorites_screen.dart
- [ ] login_screen.dart
- [ ] splash_screen.dart
- [ ] pet_onboarding_screen.dart

### Core (2):
- [ ] app.dart
- [ ] app_initializer.dart

## 🎯 STRATÉGIE

### Phase 1: Corriger tests cassés (1h)
- Corriger auth_service_test.dart (const errors)
- Corriger widget tests (expectations)

### Phase 2: Services critiques (30min)
- openpetfoodfacts_service_test.dart
- (search_parsing_service optionnel)

### Phase 3: Widgets nouveaux (2h)
- Tests pour profile/* (8 widgets)
- Tests pour product_details/* (6 widgets)
- Tests pour search/* (2 widgets)

### Phase 4: Screens manquants (1h)
- profile_screen_test.dart
- scanner_screen_test.dart
- favorites_screen_test.dart
- login_screen_test.dart

### Phase 5: Coverage finale (30min)
- Vérifier coverage report
- Combler les trous

## ⏱️ TOTAL: 5-6 heures

