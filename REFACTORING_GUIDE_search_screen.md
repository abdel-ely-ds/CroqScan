# 🔧 Refactoring Guide - search_screen_new.dart

**Current Size**: 987 lignes ❌  
**Target Size**: < 300 lignes ✅  
**Estimated Effort**: 2-3 heures

---

## 📊 File Analysis

The search screen contains:
- Search bar with TextField
- Filter panel with dropdowns
- Category/subcategory selectors  
- Animal type filter
- Results grid
- Empty states

---

## 🎯 Extraction Plan

### Widgets to Create in `lib/ui/widgets/search/`

```
lib/ui/widgets/search/
├── search_bar_widget.dart       (~100 lignes)
├── filter_panel.dart            (~200 lignes)
├── category_selector.dart       (~150 lignes)
├── results_grid.dart            (~200 lignes)
└── search_helpers.dart          (~50 lignes)
```

**Total extracted**: ~700 lignes  
**search_screen_new.dart result**: ~280 lignes ✅

---

## 📝 Extraction Steps

### 1. search_bar_widget.dart

Extract search TextField with:
- Text controller
- Search icon
- Clear button
- Debounced onChange

### 2. filter_panel.dart

Extract all filter dropdowns:
- Animal type selector
- Category selector
- Subcategory selector
- Reset/Apply buttons

### 3. category_selector.dart

Extract category selection logic:
- Category chips
- Subcategory chips
- Selection state

### 4. results_grid.dart

Extract results display:
- Product grid
- Loading indicator
- Empty state
- Error handling

### 5. search_helpers.dart

Extract helper functions:
- Pet type to color mapping
- Category data
- Filter validation

---

## ⚡ Quick Win

**Fastest approach** (1-2h):
Extract only the 2 biggest components:
- `filter_panel.dart` (~200 lignes)
- `results_grid.dart` (~200 lignes)

**Result**: 987 → ~580 lignes ⚠️ (still over, but better)

Then extract more if needed.

---

## 🎯 Expected Result

**Before**:
```
search_screen_new.dart: 987 lignes ❌
```

**After (Full Refactoring)**:
```
search_screen_new.dart: ~280 lignes ✅
lib/ui/widgets/search/
├── search_bar_widget.dart (100 lignes)
├── filter_panel.dart (200 lignes)
├── category_selector.dart (150 lignes)
├── results_grid.dart (200 lignes)
└── search_helpers.dart (50 lignes)
```

**Compliance**: Architecture 95% → 100% ✅

---

_See also: REFACTORING_GUIDE_profile_screen.md for profile refactoring_

