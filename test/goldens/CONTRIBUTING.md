# Contributing to Golden Tests

This guide explains how to add new golden tests to the project.

## When to Add Golden Tests

Add golden tests when:

- ✅ Creating a new screen
- ✅ Creating a new reusable widget
- ✅ Making significant UI changes
- ✅ Adding new UI states (themes, sizes)
- ✅ Implementing complex layouts

Don't add golden tests for:

- ❌ Simple text-only widgets
- ❌ Widgets that change frequently
- ❌ External library widgets (already tested)
- ❌ Internal utility widgets

## Step-by-Step Guide

### 1. Identify What to Test

Ask yourself:

- Is this a screen or a widget?
- What states does it have? (loading, error, empty, filled)
- Does it support dark mode?
- Is it responsive? (different screen sizes)

### 2. Create Test File

**For screens:**

```bash
touch test/goldens/screens/my_new_screen_golden_test.dart
```

**For widgets:**

```bash
touch test/goldens/widgets/my_new_widget_golden_test.dart
```

### 3. Write Test Code

Use this template:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/ui/screens/my_new_screen.dart'; // Adjust import
import '../golden_test_helper.dart';

void main() {
  setUpAll(() async {
    await GoldenTestHelper.loadFonts();
  });

  group('MyNewScreen golden tests', () {
    testWidgets('MyNewScreen - light mode', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const MyNewScreen(),
          themeMode: ThemeMode.light,
        ),
        surfaceSize: GoldenTestHelper.phoneSize,
      );

      await expectLater(
        find.byType(MyNewScreen),
        matchesGoldenFile('images/my_new_screen_light.png'),
      );
    });

    testWidgets('MyNewScreen - dark mode', (tester) async {
      await GoldenTestHelper.pumpAndSettle(
        tester,
        GoldenTestHelper.wrapWithApp(
          const MyNewScreen(),
          themeMode: ThemeMode.dark,
        ),
        surfaceSize: GoldenTestHelper.phoneSize,
      );

      await expectLater(
        find.byType(MyNewScreen),
        matchesGoldenFile('images/my_new_screen_dark.png'),
      );
    });
  });
}
```

### 4. Generate Golden Files

Run the test with update flag:

```bash
flutter test --update-goldens test/goldens/screens/my_new_screen_golden_test.dart
```

Or use the helper script:

```bash
./scripts/golden_tests.sh update
```

### 5. Verify Golden Files

Check that images were created:

```bash
ls -la test/goldens/screens/images/
# Should see: my_new_screen_light.png, my_new_screen_dark.png
```

Open the images to verify they look correct.

### 6. Run Tests Without Update

Verify tests pass:

```bash
flutter test test/goldens/screens/my_new_screen_golden_test.dart
```

### 7. Add to Master Test File

Edit `test/goldens/all_golden_tests.dart`:

```dart
import 'screens/my_new_screen_golden_test.dart' as my_new_screen;

void main() {
  // ... existing imports
  my_new_screen.main();
}
```

### 8. Update Inventory

Edit `TEST_INVENTORY.md` to add your tests:

```markdown
### MyNewScreen (2 tests)

- ✅ Light mode
- ✅ Dark mode
- **File**: `screens/my_new_screen_golden_test.dart`
```

### 9. Commit Changes

```bash
git add test/goldens/
git commit -m "Add golden tests for MyNewScreen"
```

## Testing Patterns

### Pattern 1: Simple Widget

```dart
testWidgets('Simple widget', (tester) async {
  await GoldenTestHelper.pumpAndSettle(
    tester,
    GoldenTestHelper.wrapWithApp(
      const Center(
        child: MyWidget(data: 'test'),
      ),
    ),
    surfaceSize: const Size(400, 300),
  );

  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('images/my_widget.png'),
  );
});
```

### Pattern 2: Widget with State

```dart
testWidgets('Widget with different states', (tester) async {
  // Test state 1
  await GoldenTestHelper.pumpAndSettle(
    tester,
    GoldenTestHelper.wrapWithApp(
      const MyWidget(score: 95),
    ),
  );

  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('images/my_widget_excellent.png'),
  );
});

testWidgets('Widget state 2', (tester) async {
  await GoldenTestHelper.pumpAndSettle(
    tester,
    GoldenTestHelper.wrapWithApp(
      const MyWidget(score: 45),
    ),
  );

  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('images/my_widget_poor.png'),
  );
});
```

### Pattern 3: Widget with Complex Data

```dart
testWidgets('Widget with product data', (tester) async {
  final product = Product(
    barcode: '123',
    name: 'Test Product',
    brand: 'Test Brand',
    // ... other fields
  );

  await GoldenTestHelper.pumpAndSettle(
    tester,
    GoldenTestHelper.wrapWithApp(
      MyWidget(product: product),
    ),
  );

  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('images/my_widget_with_product.png'),
  );
});
```

### Pattern 4: Responsive Widget

```dart
testWidgets('Widget on phone', (tester) async {
  await GoldenTestHelper.pumpAndSettle(
    tester,
    GoldenTestHelper.wrapWithApp(const MyWidget()),
    surfaceSize: GoldenTestHelper.phoneSize,
  );

  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('images/my_widget_phone.png'),
  );
});

testWidgets('Widget on tablet', (tester) async {
  await GoldenTestHelper.pumpAndSettle(
    tester,
    GoldenTestHelper.wrapWithApp(const MyWidget()),
    surfaceSize: GoldenTestHelper.tabletSize,
  );

  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('images/my_widget_tablet.png'),
  );
});
```

### Pattern 5: Widget with Scrolling

```dart
testWidgets('Scrollable widget', (tester) async {
  await GoldenTestHelper.pumpAndSettle(
    tester,
    GoldenTestHelper.wrapWithApp(
      SingleChildScrollView(
        child: MyWidget(),
      ),
    ),
    surfaceSize: const Size(375, 800),
  );

  await expectLater(
    find.byType(SingleChildScrollView),
    matchesGoldenFile('images/my_widget_scrollable.png'),
  );
});
```

## Common Issues & Solutions

### Issue: "Golden file not found"

**Solution**: Generate golden files first

```bash
flutter test --update-goldens test/goldens/your_test.dart
```

### Issue: "Test fails after generation"

**Cause**: Platform differences or animation not settled

**Solution**:

1. Ensure `pumpAndSettle()` is called
2. Check that animations are disabled
3. Use fixed surface sizes

### Issue: "Golden looks different on CI"

**Cause**: Font rendering differences

**Solution**:

- Use `loadFonts()` in `setUpAll`
- Ensure consistent Flutter version
- Use Docker for consistent CI environment

### Issue: "Golden file is huge"

**Cause**: Surface size too large

**Solution**: Use appropriate size

```dart
// ❌ Bad: Too large
surfaceSize: const Size(4096, 4096)

// ✅ Good: Appropriate size
surfaceSize: GoldenTestHelper.phoneSize // 375x667
```

### Issue: "Multiple widgets in one test"

**Solution**: Test one widget per test

```dart
// ❌ Bad: Multiple expectations
testWidgets('Multiple widgets', (tester) async {
  // Testing Widget1
  await expectLater(find.byType(Widget1), ...);
  // Testing Widget2
  await expectLater(find.byType(Widget2), ...);
});

// ✅ Good: Separate tests
testWidgets('Widget1 test', (tester) async {
  await expectLater(find.byType(Widget1), ...);
});

testWidgets('Widget2 test', (tester) async {
  await expectLater(find.byType(Widget2), ...);
});
```

## Best Practices

### 1. Use Descriptive Names

```dart
// ❌ Bad
matchesGoldenFile('images/test1.png')

// ✅ Good
matchesGoldenFile('images/score_badge_excellent.png')
```

### 2. Group Related Tests

```dart
group('ScoreBadge - different scores', () {
  testWidgets('excellent', ...);
  testWidgets('good', ...);
  testWidgets('poor', ...);
});

group('ScoreBadge - dark mode', () {
  testWidgets('excellent dark', ...);
  testWidgets('poor dark', ...);
});
```

### 3. Test Edge Cases

```dart
testWidgets('Widget with empty data', ...);
testWidgets('Widget with max values', ...);
testWidgets('Widget with special characters', ...);
```

### 4. Keep Tests Independent

Each test should be self-contained and not depend on other tests.

```dart
// ✅ Good: Independent tests
testWidgets('Test A', (tester) async {
  final data = createTestData(); // Own data
  // Test A
});

testWidgets('Test B', (tester) async {
  final data = createTestData(); // Own data
  // Test B
});
```

### 5. Use Consistent Sizing

Prefer predefined sizes:

```dart
// ✅ Good
surfaceSize: GoldenTestHelper.phoneSize
surfaceSize: GoldenTestHelper.tabletSize

// Also acceptable for specific needs
surfaceSize: const Size(400, 600)
```

## Review Checklist

Before submitting golden tests, verify:

- [ ] Tests are in correct directory (screens/ or widgets/)
- [ ] Golden images are generated and look correct
- [ ] Tests pass without `--update-goldens`
- [ ] Both light and dark modes tested (when applicable)
- [ ] Test names are descriptive
- [ ] Added to `all_golden_tests.dart`
- [ ] Updated `TEST_INVENTORY.md`
- [ ] No linter errors
- [ ] Golden images are reasonably sized (<100KB each)

## Getting Help

If you're stuck:

1. Check [TESTING_GUIDE.md](./TESTING_GUIDE.md) for detailed documentation
2. Look at existing tests for examples
3. Review [TEST_INVENTORY.md](./TEST_INVENTORY.md) for test patterns
4. Ask team members

---

**Happy Testing! 🧪**
