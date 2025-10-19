# Decision Log - PetScan Project

## Language Policy Decision (October 19, 2025)

### Decision

**The application will remain French-only. No multi-language support (internationalization/i18n) will be implemented.**

### Rationale

1. **Target Market**: The app targets French-speaking pet owners primarily
2. **Development Speed**: Removing i18n requirement significantly speeds up MVP development
3. **Maintenance Simplicity**: No need to maintain translations or localization infrastructure
4. **Code Clarity**: Direct French strings are more readable than l10n keys for French developers

### Impact Analysis

#### Positive Impacts ✅

- **Faster Development**: ~8-12 hours saved by not implementing i18n
- **Simpler Codebase**: No .arb files, no AppLocalizations complexity
- **Direct Updates**: Text changes don't require translation workflow
- **Production Ready**: App can ship immediately without waiting for i18n

#### Negative Impacts ⚠️

- **Limited Market**: Cannot easily expand to English-speaking markets
- **Refactoring Cost**: Adding i18n later would require ~12-15 hours of work
- **Hardcoded Strings**: ~200+ French strings in codebase

### Technical Implementation

#### What Changed

- `.cursor/rules/internationalization.mdc` → Updated to reflect French-only policy
- `lib/l10n/` directory → Not needed, removed
- Compliance reports → Updated to show 82% compliance (up from 71%)

#### What Stays the Same

- All code, comments, and documentation remain in **English**
- Git commits in English
- Variable/function/class names in English
- Only UI text is in French

### Reversal Plan (If Needed in Future)

If multi-language support becomes necessary:

**Estimated Effort**: 12-15 hours
**Steps**:

1. Add `flutter_localizations` and `intl` packages (30 min)
2. Create `lib/l10n/app_fr.arb` with all current strings (3h)
3. Create `lib/l10n/app_en.arb` with English translations (2h)
4. Configure `flutter gen-l10n` in `pubspec.yaml` (30 min)
5. Replace ~200 hardcoded strings with `AppLocalizations.of(context)!.key` (5-6h)
6. Add language selector in profile screen (1h)
7. Test both languages (1-2h)

### Compliance Status

**Before Decision**: 71% compliant (i18n was a critical blocker)
**After Decision**: 82% compliant (i18n requirement removed)

The app is now **production-ready** for the French market.

### Approval

- **Decided by**: Project Owner
- **Date**: October 19, 2025
- **Status**: ✅ Approved

### Related Documents

- `CURSOR_RULES_COMPLIANCE.md` - Updated compliance report
- `REFACTORING_STATUS.md` - Updated refactoring priorities
- `.cursor/rules/internationalization.mdc` - Updated language policy rule
