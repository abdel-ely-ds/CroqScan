# Cursor Rules for Konvert Flutter App

This directory contains modular Cursor rules in `.mdc` format for the Konvert project.

## 📁 Rule Files (18 optimized rules)

### 🔴 Always Applied (alwaysApply: true) - 11 rules

These rules are **always included** in the model context:

1. **dart-null-safety.mdc** (49 lines)

   - Null safety, code quality, linting
   - Error handling & logging
   - Security best practices
   - Golden testing
   - `globs: ["**/*.dart"]`

2. **widget-lifecycle-safety.mdc** (59 lines) 🚨 **CRITICAL**

   - NEVER access BuildContext in dispose()
   - Safe provider reference patterns
   - Memory leak prevention
   - `globs: ["lib/screens/**/*.dart", "lib/widgets/**/*.dart"]`

3. **internationalization.mdc** (53 lines) 🌍

   - NEVER hardcode user-facing text
   - EN/FR support required
   - ARB files management
   - `globs: ["lib/**/*.dart", "lib/l10n/**/*.arb"]`

4. **ui-design-system.mdc** (46 lines)

   - Design system & theming
   - Responsive UI patterns
   - `globs: ["lib/ui/**/*.dart", "lib/screens/**/*.dart", "lib/widgets/**/*.dart"]`

5. **accessibility.mdc** (39 lines)

   - WCAG AA compliance
   - Semantics & a11y testing
   - 48x48 dp touch targets
   - `globs: ["lib/screens/**/*.dart", "lib/widgets/**/*.dart"]`

6. **testing-strategy.mdc** (63 lines)

   - Unit/Widget/Integration/Lifecycle tests
   - External SDK mocking strategy
   - Golden testing
   - `globs: ["test/**/*.dart", "lib/**/*.dart"]`

7. **data-storage.mdc** (49 lines)

   - Models & serialization
   - Local storage & networking
   - Assets & dependencies management
   - `globs: ["lib/core/models/**/*.dart", "lib/core/services/**/*.dart", "lib/core/repositories/**/*.dart", "pubspec.yaml", "assets/**/*"]`

8. **app-initialization.mdc** (52 lines)

   - AppInitializer pattern
   - Monitoring & analytics
   - Service orchestration
   - `globs: ["lib/main.dart", "lib/core/services/**/*.dart"]`

9. **documentation-standards.mdc** (60 lines)

   - MD file minimalism
   - Essential docs only
   - Developer experience guidelines
   - `globs: ["**/*.md", "docs/**/*"]`

10. **release-checklist.mdc** (32 lines)

    - Pre-release checklist
    - Build & packaging
    - Testing requirements
    - `globs: ["android/**/*", "ios/**/*", "pubspec.yaml"]`

11. **meta-rules.mdc** (21 lines)
    - Auto-improvement of cursor rules
    - Self-documenting standards
    - `globs: []` (always applied)

### 🔵 Auto-Attached (globs-based, alwaysApply: false) - 7 rules

These rules are included **when files matching their glob patterns are referenced**:

12. **flutter-architecture.mdc** (66 lines)

    - Project structure
    - Architecture patterns (Clean, MVVM)
    - Layer separation examples
    - `globs: ["lib/**/*.dart"]`

13. **performance-optimization.mdc** (48 lines)

    - Performance best practices
    - Widget optimization
    - Automated performance tests
    - `globs: ["lib/**/*.dart"]`

14. **animations.mdc** (88 lines) ⭐ NEW

    - Implicit vs explicit animations
    - AnimationController patterns
    - Accessibility (reduced motion)
    - Concrete examples
    - `globs: ["lib/screens/**/*.dart", "lib/widgets/**/*.dart"]`

15. **forms-input.mdc** (138 lines) ⭐ NEW

    - Controller disposal patterns
    - Form validation with examples
    - Debounce implementation
    - Focus navigation
    - `globs: ["lib/screens/**/*.dart", "lib/widgets/**/*.dart"]`

16. **state-restoration.mdc** (132 lines) ⭐ NEW

    - Keys best practices (ValueKey, ObjectKey, UniqueKey)
    - RestorationMixin pattern
    - Persist user preferences
    - When to use keys
    - `globs: ["lib/screens/**/*.dart", "lib/widgets/**/*.dart"]`

17. **state-management.mdc** (164 lines) ⭐ NEW

    - Provider/Riverpod/Bloc patterns
    - Selector vs Consumer
    - Async state management
    - Testing providers
    - `globs: ["lib/providers/**/*.dart", "lib/core/**/*.dart"]`

18. **dependency-injection.mdc** (159 lines) ⭐ NEW
    - get_it service locator
    - Provider DI patterns
    - Interface injection
    - Environment-based DI
    - `globs: ["lib/core/**/*.dart", "lib/main.dart"]`

## 📊 Improvements Made

### Before Optimization

- 13 files (some too broad)
- Lack of concrete examples
- Multiple topics in single files

### After Optimization

- 18 files (focused & composable)
- **+5 new rules** with detailed examples
- Single responsibility per rule
- All rules < 200 lines (well under 500 limit)

### New Rules Added ⭐

All new rules follow best practices:

- ✅ **Focused** - Single responsibility
- ✅ **Actionable** - Concrete code examples
- ✅ **Scoped** - Specific globs patterns
- ✅ **Clear** - Like internal documentation
- ✅ **Composable** - Can be referenced with @

## 🎯 Usage

### Automatic

Rules are automatically applied based on:

1. **Always rules** (11) - Included in every context
2. **Auto-attached rules** (7) - Included when working on matching files

### Manual Invocation

Reference specific rules using `@ruleName`:

```
@animations - For animation best practices
@forms-input - For forms and validation
@state-restoration - For keys and state persistence
@state-management - For Provider/Riverpod patterns
@dependency-injection - For DI setup
@flutter-architecture - For project structure
@widget-lifecycle-safety - For lifecycle safety
```

## 🔑 Key Rules to Remember

### 🚨 Critical: Widget Lifecycle Safety

**NEVER access BuildContext in dispose() method**

```dart
class _MyWidgetState extends State<MyWidget> {
  MyProvider? _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = context.read<MyProvider>();
      _provider!.addListener(_onChanged);
    });
  }

  @override
  void dispose() {
    _provider?.removeListener(_onChanged);
    _provider = null;
    super.dispose();
  }
}
```

### 🌍 Internationalization

**NEVER hardcode user-facing text**

```dart
// ❌ BAD
Text('No history')

// ✅ GOOD
Text(l10n.historyEmpty)
```

Find violations:

```bash
grep -r "Text\('[^']" lib/
```

### 🧪 Testing External SDKs

**Test your code, not third-party SDKs**

Use mocks for AdMob, Firebase, etc. Focus on app logic, not SDK implementation.

## 📈 Rule Statistics

- **Total rules**: 18 (optimized from 13)
- **Always applied**: 11 (critical rules)
- **Auto-attached**: 7 (contextual rules)
- **New rules added**: 5 (with detailed examples)
- **Average lines per rule**: ~70 lines
- **Largest rule**: 164 lines (state-management.mdc)
- **All rules**: < 200 lines (well under 500 limit)

## 🎓 Best Practices Applied

✅ **Focused** - Each rule has single responsibility  
✅ **Actionable** - Concrete code examples in all new rules  
✅ **Scoped** - Specific glob patterns for targeted application  
✅ **Clear** - Written like internal documentation  
✅ **Composable** - Rules can reference each other with @  
✅ **Under 500 lines** - All rules < 200 lines  
✅ **Examples** - Real-world code patterns included

## 📚 Documentation

For detailed information about each rule, open the corresponding `.mdc` file.

## 🔄 Maintenance

- Rules are synced with `.cursorrules` in project root
- New best practices are added based on lessons learned
- Each bug/issue should result in a new rule to prevent recurrence
- Auto-improvement via `meta-rules.mdc`

## Version

Last updated: v2.1.4 (2025-10-19)  
Format: MDC (Markdown with Metadata)  
Total rules: 18 (optimized from 13)  
Cursor-compatible: ✅  
Coverage: 100% of .cursorrules  
Best practices: ✅ All followed
