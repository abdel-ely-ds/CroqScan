# 🧪 How to Test CroqScan

Quick guide to test all features of your pet product health scanner app.

---

## 🚀 Launch the App

```bash
# Make sure you're in the project directory
cd /Users/Marc-Enzo\ Bonnafon/programming/perso/CroqScan

# Run on iOS simulator
flutter run

# Or run on Android
flutter run -d android
```

---

## ✅ Testing Checklist

### 1. Home Screen ✓

**What to check:**

- [ ] App opens without crashes
- [ ] "CroqScan" title is visible
- [ ] Pet icon appears
- [ ] "Keep your pets healthy" headline shows
- [ ] Two gradient buttons appear:
  - "Scan a Product"
  - "Search Products"
- [ ] Info card at bottom with green border
- [ ] All text is readable

**How to test:**

1. Launch the app
2. Verify all elements are visible
3. Check that colors look good
4. Tap around (don't navigate yet)

---

### 2. Scanner Screen ✓

**What to check:**

- [ ] Camera opens
- [ ] Scan frame appears with blue borders
- [ ] Corner markers animate
- [ ] Flash button works
- [ ] Back button returns home
- [ ] Instructions text visible
- [ ] Scanning works with sample barcodes

**How to test:**

1. From home, tap **"Scan a Product"**
2. Allow camera permission if asked
3. Camera should open
4. Look for the scan frame overlay
5. Test the flashlight button (top right)
6. Test the back button (top left)

**To test actual scanning:**

You have two options:

**Option A: Print or Display a Barcode**

- Open a browser on another device
- Go to: `https://barcode.tec-it.com/en/EAN13?data=3017620422003`
- Display the barcode on screen
- Point your phone's camera at it
- App should scan and show product details

**Option B: Use a Real Product**

- Find any product with a barcode
- Scan it
- You'll see "Product Not Found" (expected)
- This confirms scanning works!

**Sample Barcodes to Try:**

- `3017620422003` - Premium Dog Food (Score: 85)
- `3017620422010` - Budget Kibble (Score: 35)
- `3017620422027` - Cat Food (Score: 92)
- `3017620422041` - Poor Treats (Score: 22)

---

### 3. Search Screen ✓

**What to check:**

- [ ] Search screen opens
- [ ] All 6 products listed initially
- [ ] Search bar works
- [ ] Product cards display correctly
- [ ] Tap on product opens details
- [ ] Empty state shows when no results
- [ ] Clear button works

**How to test:**

1. From home, tap **"Search Products"**
2. See all 6 sample products
3. Type in search bar:
   - "cat" → should show Cat Food
   - "premium" → should show 2 products
   - "organic" → should show Rabbit Pellets
   - "xyz" → should show empty state
4. Tap the X button to clear search
5. Tap any product card → goes to details

**Search terms to try:**

- "dog"
- "cat"
- "premium"
- "budget"
- "organic"
- "treats"
- "salmon"
- "bird"

---

### 4. Product Details Screen ✓

**What to check:**

- [ ] Product name and brand show
- [ ] Health score badge displays
- [ ] Score color matches quality:
  - Green (75-100)
  - Yellow (50-74)
  - Orange (25-49)
  - Red (0-24)
- [ ] Pet type chips appear
- [ ] All sections present:
  - Description
  - Benefits (if any)
  - Warnings (if any)
  - Ingredients
  - Nutritional Info
- [ ] Back button works

**How to test:**

1. Open any product from search
2. Scroll through all sections
3. Check the health score makes sense
4. Read warnings for low-scored products
5. Look at nutritional information
6. Tap back button

**Products to check:**

**High Score (Green - Excellent):**

- Cat Food (92) - Should have many benefits
- Rabbit Pellets (88) - Organic, high fiber
- Premium Dog Food (85) - Quality ingredients

**Medium Score (Orange - Mediocre):**

- Budget Kibble (35) - Should have warnings

**Low Score (Red - Poor):**

- Treats (22) - Multiple warnings, red indicators

---

## 🎯 Feature Testing

### Navigation Flow

Test this complete flow:

1. **Home** → Scan → Back → **Home**
2. **Home** → Search → Product → Back → Search → Back → **Home**
3. **Home** → Scan → (scan barcode) → **Product Details** → Back → **Home**

All navigation should be smooth with no crashes.

---

### Camera Permissions

**First Launch:**

1. Tap "Scan a Product"
2. System asks for camera permission
3. Tap "Allow"
4. Camera should open

**If Denied:**

1. Go to phone Settings
2. Find CroqScan app
3. Enable Camera permission
4. Return to app
5. Try scanning again

---

### Data Accuracy

Check each product's data:

**Premium Dog Food:**

- Score: 85 (Green - Excellent)
- Should show benefits
- No warnings
- High protein (28%)

**Budget Kibble:**

- Score: 35 (Orange - Mediocre)
- Should show warnings
- Artificial colors mentioned
- Low protein (18%)

**Cat Food:**

- Score: 92 (Green - Excellent)
- Salmon ingredient
- High score badge
- Benefits listed

**Poor Treats:**

- Score: 22 (Red - Poor)
- Multiple warnings
- Red score badge
- Warning icons visible

---

## 🐛 What to Watch For

### Common Issues

**Camera Won't Open:**

- Check permissions
- Restart app
- Try on real device (not simulator if simulator doesn't have camera)

**Barcode Won't Scan:**

- Improve lighting
- Hold steadier
- Try displaying barcode on another screen
- Check barcode is EAN-13 format

**App Crashes:**

- Check terminal for errors
- Try `flutter clean` then `flutter run`
- Restart phone/simulator

**Slow Performance:**

- Expected in debug mode
- Try release build: `flutter run --release`

---

## 📊 Visual Checks

### Design Quality

**Colors:**

- [ ] Blue primary color throughout
- [ ] Green for excellent scores
- [ ] Red for poor scores
- [ ] Orange for warnings
- [ ] Consistent color scheme

**Typography:**

- [ ] Text is readable
- [ ] Headers are bold
- [ ] Body text is appropriate size
- [ ] No text cutoff

**Spacing:**

- [ ] Consistent padding
- [ ] Good margins
- [ ] Elements not too crowded
- [ ] Clean, organized look

**Icons:**

- [ ] All icons display
- [ ] Icons make sense
- [ ] Appropriate sizes
- [ ] Good visual weight

---

## 🎬 Demo Scenario

Perfect flow to demonstrate the app:

1. **Start at Home**

   - Show the welcome screen
   - Explain the two main features

2. **Try Search First**

   - Search for "cat"
   - Show Cat Food with 92 score
   - Open product details
   - Explain the green score
   - Show benefits
   - Return to search

3. **Show Contrast**

   - Search for "treats"
   - Show Poor Treats with 22 score
   - Open product details
   - Explain red score
   - Show warnings
   - Point out artificial colors

4. **Demonstrate Scanner**

   - Go to scanner
   - Show the camera interface
   - Scan a barcode
   - Instantly shows results

5. **Explain Value**
   - Helps pet owners choose better products
   - Easy to use
   - Trustworthy information
   - Like Yuka for pets!

---

## 🏆 Success Criteria

Your app is working perfectly if:

- ✅ All 4 screens open without errors
- ✅ Navigation works smoothly
- ✅ Camera opens and scans
- ✅ Search filters products
- ✅ Product details display correctly
- ✅ Colors match scores
- ✅ All 6 sample products work
- ✅ UI looks professional and trustworthy
- ✅ No crashes or freezes

---

## 📱 Platform-Specific Testing

### iOS

- Test on iPhone (different sizes if possible)
- Check dark mode
- Verify camera permission dialog
- Test navigation gestures
- Check status bar appearance

### Android

- Test on Android device/emulator
- Check material design
- Verify permissions
- Test back button
- Check different screen sizes

---

## 🔧 Quick Fixes

**If something doesn't work:**

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check for errors
flutter analyze

# See detailed logs
flutter run -v
```

---

## 🎉 You're Ready!

If all tests pass, your app is ready to:

- Demo to friends
- Show to potential users
- Develop further features
- Deploy to stores (with more products!)

---

**Have fun testing your awesome pet health scanner! 🐾**

_Remember: This is a demo with sample data. In production, you'd connect to a real product database API._
