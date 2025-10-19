# Golden Tests - CroqScan

## 🎯 Quick Start

```bash
# Run all golden tests
./scripts/golden_tests.sh run

# Update golden images (after intentional UI changes)
./scripts/golden_tests.sh update

# View changes
./scripts/golden_tests.sh diff
```

**Status**: ✅ 32/35 tests passing (91%) | 52 images generated

---

## Overview

Golden tests (screenshot tests) automatically detect visual regressions by comparing UI rendering with reference images.

**What's covered**:

- All main screens (Splash, Home, Scanner, Favorites, Profile, Login, PetOnboarding)
- All key widgets (ProductCard, HealthScoreCard, NutritionalValues, Ingredients)
- Light & dark modes
- Different screen sizes (phone, tablet)
- Various data states

---

## Structure

```
test/goldens/
├── golden_test_helper.dart       # Shared utilities
├── all_golden_tests.dart         # Master test file (32 active tests)
│
├── screens/                      # Screen tests (12 tests)
│   ├── images/                   # 23 golden images
│   └── *_golden_test.dart
│
└── widgets/                      # Widget tests (23 tests)
    ├── images/                   # 29 golden images
    └── *_golden_test.dart
```

---

## Running Tests

### Using Helper Script (Recommended)

```bash
./scripts/golden_tests.sh run          # Run all tests
./scripts/golden_tests.sh update       # Update images
./scripts/golden_tests.sh diff         # View changes
./scripts/golden_tests.sh run-screens  # Screens only
./scripts/golden_tests.sh run-widgets  # Widgets only
```

### Manual Commands

```bash
# Run all tests
flutter test test/goldens/all_golden_tests.dart

# Update all golden images
flutter test --update-goldens test/goldens/all_golden_tests.dart

# Run specific test
flutter test test/goldens/widgets/product_card_golden_test.dart
```

---

## Workflow

### 1. Before UI Changes

```bash
./scripts/golden_tests.sh run  # Establish baseline
```

### 2. Make UI Changes

Edit your Flutter code

### 3. Check for Regressions

```bash
./scripts/golden_tests.sh run  # Tests will fail if UI changed
```

### 4. Review Changes

```bash
./scripts/golden_tests.sh diff  # See what changed
```

### 5. Update if Intentional

```bash
./scripts/golden_tests.sh update  # Accept UI changes
```

### 6. Verify

```bash
./scripts/golden_tests.sh run  # Should pass again
```

---

## Complex Cases

Some widgets require special handling:

| Issue                | Solution           | Example                                  |
| -------------------- | ------------------ | ---------------------------------------- |
| 📷 Camera/Hardware   | Mock the view      | `scanner_screen_mocked_golden_test.dart` |
| 💾 SharedPreferences | Global mock        | `GoldenTestHelper.initMocks()`           |
| ⏱️ Async/Timers      | Use static version | `splash_screen_static_golden_test.dart`  |
| 📱 Overflow          | Test by sections   | `login_screen_sections_golden_test.dart` |

**See [COMPLEX_CASES_GUIDE.md](./COMPLEX_CASES_GUIDE.md) for detailed solutions**

---

## Adding New Tests

See [CONTRIBUTING.md](./CONTRIBUTING.md) for step-by-step guide.

Quick template:

```dart
import 'package:flutter_test/flutter_test.dart';
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
    await GoldenTestHelper.initMocks(); // If needs SharedPreferences
  });

  testWidgets('MyWidget golden test', (tester) async {
    await tester.binding.setSurfaceSize(GoldenTestHelper.phoneSize);

    await tester.pumpWidget(
      GoldenTestHelper.wrapWithApp(const MyWidget()),
    );

    await tester.pump();

    await expectLater(
      find.byType(MyWidget),
      matchesGoldenFile('images/my_widget.png'),
    );
  });
}
```

---

## Common Issues

### "Could not be compared against non-existent file"

Generate golden files first:

```bash
flutter test --update-goldens test/goldens/your_test.dart
```

### "MissingPluginException: SharedPreferences"

Add to your test's `setUpAll`:

```dart
await GoldenTestHelper.initMocks();
```

### "pumpAndSettle timed out"

Use `pump()` instead:

```dart
await tester.pump(const Duration(seconds: 1));
```

### "RenderFlex overflowed"

Options:

1. Increase surface size
2. Test by sections
3. Fix the widget design

---

## CI Integration

```yaml
# .github/workflows/flutter.yml
- name: Run golden tests
  run: flutter test test/goldens/all_golden_tests.dart

- name: Check for golden changes
  run: |
    if git diff --name-only | grep -q "test/goldens.*\.png"; then
      echo "⚠️  Golden files changed - review required"
      exit 1
    fi
```

---

## Best Practices

### ✅ DO

- Run tests before committing UI changes
- Review visual diffs carefully
- Update goldens only when changes are intentional
- Test both light and dark modes
- Use the helper script for consistency

### ❌ DON'T

- Update goldens blindly without reviewing
- Ignore failing golden tests
- Commit broken golden tests
- Test external SDK functionality (mock instead)

---

## Additional Documentation

- **[COMPLEX_CASES_GUIDE.md](./COMPLEX_CASES_GUIDE.md)** - Handling camera, overflow, animations
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** - How to add new tests
- **[Flutter Golden Tests Docs](https://flutter.dev/docs/testing/integration-tests)** - Official documentation

---

**Last updated**: October 2025  
**Status**: ✅ Operational (32/35 tests passing)
