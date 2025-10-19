# 🏗️ PetScan Architecture

## Overview

PetScan follows **Clean Architecture** principles with a clear separation between UI, domain logic, and data access layers.

## Architecture Layers

### 1. Presentation Layer (UI)

**Location**: `lib/ui/`

Responsible for displaying data and handling user interactions.

- **screens/** - Full-screen pages
- **widgets/** - Reusable UI components
- **themes/** - App themes and styling

**Dependencies**: Can only depend on Core layer (services, models)

### 2. Domain Layer (Business Logic)

**Location**: `lib/core/services/`

Contains business rules and orchestrates data flow.

- `openpetfoodfacts_service.dart` - API communication
- `favorites_service.dart` - Favorite management logic
- `scan_history_service.dart` - Scan tracking
- `profile_service.dart` - Pet profile management
- `auth_service.dart` - Authentication logic

**Dependencies**: Can depend on models and repositories

### 3. Data Layer

**Location**: `lib/core/models/`

Data models and persistence.

- `product.dart` - Product entity
- `profile_service.dart` - Contains AnimalProfile model

**Current storage**:

- SharedPreferences - Favorites, history, profiles
- FlutterSecureStorage - Apple credentials (iOS Keychain)

## Data Flow

```
User Action (UI)
    ↓
Screen/Widget
    ↓
Service (Business Logic)
    ↓
API Call or Local Storage
    ↓
Model parsing
    ↓
Update UI (setState or Provider)
```

### Example: Scanning a Product

```
1. ScannerScreen (UI)
   ↓
2. onBarcodeDetected()
   ↓
3. OpenPetFoodFactsService.fetchProductByBarcode()
   ↓
4. HTTP GET to API
   ↓
5. Parse response → Product model
   ↓
6. ScanHistoryService.addToHistory()
   ↓
7. Navigate to ProductDetailsScreen with Product
```

## State Management

**Current**: StatefulWidget + setState

**Future consideration**: Provider or Riverpod for complex state

### State Locations

| State            | Where                | Why               |
| ---------------- | -------------------- | ----------------- |
| Authentication   | AuthService + Splash | Global, persisted |
| Favorites        | FavoritesService     | Global, persisted |
| Scan History     | ScanHistoryService   | Global, persisted |
| Pet Profile      | ProfileService       | Global, persisted |
| Search Results   | SearchScreen (local) | Ephemeral         |
| Navigation Index | MainNavigation       | Local to widget   |

## Navigation Structure

### Bottom Navigation (MainNavigation)

- Home (index 0)
- Search (index 1)
- Scanner (separate route, fullscreen)
- Favorites (index 2)
- Profile (index 3)

**Note**: Scanner is NOT in IndexedStack to prevent background camera activity.

### Screen Routes

```
SplashScreen (initial)
  ├─ LoginScreen (if not authenticated)
  └─ MainNavigation (if authenticated or guest)
      ├─ HomeScreen
      ├─ SearchScreenNew
      ├─ FavoritesScreen
      └─ ProfileScreen
          └─ ProfileEditScreen (modal)

Scanner → ProductDetailsScreen (pushReplacement)
```

## API Integration

### OpenPetFoodFacts API

**Endpoints used**:

- `GET /api/v2/product/{barcode}.json` - Single product
- `GET /api/v2/search?...` - Search products

**Response parsing**: See `OpenPetFoodFactsService._parseProduct()`

**Health score calculation**: Based on:

- Protein content
- Fat content
- Presence of problematic ingredients
- Organic/bio labels

## Local Storage

### SharedPreferences

| Key                  | Type         | Content                   |
| -------------------- | ------------ | ------------------------- |
| `favorites_barcodes` | List<String> | Favorite product barcodes |
| `scan_history`       | List<String> | JSON-encoded scan entries |
| `animal_profile`     | String       | JSON-encoded pet profile  |
| `user_name`          | String       | User's name               |

### FlutterSecureStorage (iOS Keychain)

| Key                    | Content                     |
| ---------------------- | --------------------------- |
| `apple_user_id`        | Apple ID user identifier    |
| `apple_identity_token` | JWT token                   |
| `apple_email`          | User email (if provided)    |
| `apple_name`           | User name (first auth only) |
| `is_logged_in`         | Boolean flag                |

## Authentication Flow

### Guest Mode

1. Splash → Login
2. "Continue without account"
3. MainNavigation (all features available)
4. Can log in later from Profile

### Apple Sign In

1. Splash → Login
2. "Continue with Apple"
3. Apple modal → Face ID/Touch ID
4. Credentials saved to Keychain
5. MainNavigation
6. Auto-login on next launch

## Performance Optimizations

Current:

- ✅ ListView.builder for lists
- ✅ Cached network images
- ✅ Const constructors (partial)
- ✅ Scanner disposed properly
- ✅ IndexedStack for tab navigation (except Scanner)

To implement:

- ⏳ RepaintBoundary for complex widgets
- ⏳ Debounced search input
- ⏳ Image caching strategy
- ⏳ Compute() for JSON parsing

## Security

### Data Protection

- ✅ Apple credentials in iOS Keychain
- ✅ No API keys (public API)
- ✅ HTTPS only
- ✅ Input sanitization (basic)

### To improve:

- ⏳ Obfuscation for release builds
- ⏳ Certificate pinning for API
- ⏳ Rate limiting on API calls

## Future Enhancements

### v1.1 (Near term)

- Localization (EN/FR)
- Dependency injection (get_it)
- File size optimization (<300 lines)

### v2.0 (Mid term)

- Backend API for cloud sync
- Multi-pet profiles
- Dark theme
- Product comparison feature
- Recommendations based on pet profile

### v3.0 (Long term)

- Android support
- Offline mode with local database
- Push notifications
- Community features (ratings, reviews)

## Testing Strategy

### Current Coverage

- ✅ Basic smoke test
- ⏳ Unit tests for services
- ⏳ Widget tests for screens
- ⏳ Integration tests for full flows

### Planned Tests

- Service layer (80% coverage target)
- Widget tests for all screens
- Golden tests for visual regression
- Performance benchmarks

## Dependencies Graph

```
UI Layer
  ↓ depends on
Services Layer
  ↓ depends on
Models Layer
  ↓ depends on
External APIs / Storage
```

**No circular dependencies allowed.**

## Error Handling

### Global Error Handling

- FlutterError.onError (to implement)
- Crash reporting (future: Sentry/Crashlytics)

### API Errors

- Network errors → Show error message
- 404 Not Found → "Product not in database"
- Timeout → Retry logic

### Storage Errors

- Corrupted data → Auto-cleanup
- Permission denied → Graceful fallback

## Logs & Debugging

Current logging:

- `print()` statements (development only)
- Console emojis for visual clarity (🍏 ✅ ❌ ⚠️)

Future:

- Logger package with levels
- Crashlytics integration
- Debug/Release mode separation

---

**Document Version**: 1.0  
**Last Updated**: October 2025  
**Author**: PetScan Team
