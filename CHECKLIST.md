# ✅ CroqScan Configuration Checklist

Use this checklist to verify that everything is properly configured.

## 📋 Before Starting

### Development Environment

- [ ] Flutter SDK installed and in PATH
  ```bash
  flutter --version
  ```
- [ ] Editor installed (VS Code / Android Studio / Xcode)
- [ ] Git configured
  ```bash
  git --version
  ```

### For Android

- [ ] Android Studio installed
- [ ] Android SDK installed
- [ ] At least one Android emulator created OR device connected
  ```bash
  flutter devices
  ```
- [ ] Android licenses accepted
  ```bash
  flutter doctor --android-licenses
  ```

### For iOS (macOS only)

- [ ] Xcode installed (version 14+)
- [ ] Xcode command line tools installed
  ```bash
  xcode-select --install
  ```
- [ ] CocoaPods installed
  ```bash
  pod --version
  ```
- [ ] iOS Simulator available
  ```bash
  flutter devices
  ```

---

## 🔍 Installation Verification

### 1. Check Flutter Doctor

```bash
flutter doctor -v
```

**Expected result:** All items should be ✓ (or ⚠ acceptable)

- [ ] Flutter installed ✓
- [ ] Android toolchain ✓
- [ ] Xcode (on macOS) ✓
- [ ] Android Studio / VS Code ✓
- [ ] Connected devices ✓

---

## 📦 Dependencies Installation

### 2. Install Flutter Packages

```bash
cd /Users/Marc-Enzo\ Bonnafon/programming/perso/CroqScan
flutter pub get
```

**Verifications:**

- [ ] Command executed without error
- [ ] File `pubspec.lock` created/updated
- [ ] Folder `.dart_tool/` created
- [ ] No dependency conflicts

### 3. Analyze Code

```bash
flutter analyze
```

**Expected result:** No errors

- [ ] Analysis completed without error
- [ ] No blocking warnings

---

## 🤖 Android Configuration

### 4. Verify Android Files

#### AndroidManifest.xml

- [ ] File exists: `android/app/src/main/AndroidManifest.xml`
- [ ] Permissions present:
  - [ ] `CAMERA`
  - [ ] `INTERNET`
  - [ ] `READ_EXTERNAL_STORAGE`
  - [ ] `WRITE_EXTERNAL_STORAGE`

#### build.gradle.kts

- [ ] File exists: `android/app/build.gradle.kts`
- [ ] `applicationId = "com.croqscan.app"`
- [ ] `minSdk = 21`
- [ ] `namespace = "com.croqscan.app"`

#### MainActivity.kt

- [ ] File exists: `android/app/src/main/kotlin/com/croqscan/app/MainActivity.kt`
- [ ] Correct package: `package com.croqscan.app`

### 5. Android Build (Test)

```bash
flutter build apk --debug
```

**Verifications:**

- [ ] Build completed without error
- [ ] APK generated in `build/app/outputs/flutter-apk/`
- [ ] Reasonable APK size (< 50MB for debug)

---

## 🍎 iOS Configuration

### 6. Verify iOS Files

#### Info.plist

- [ ] File exists: `ios/Runner/Info.plist`
- [ ] Permission descriptions present:
  - [ ] `NSCameraUsageDescription`
  - [ ] `NSPhotoLibraryUsageDescription`
  - [ ] `NSPhotoLibraryAddUsageDescription`

### 7. Install CocoaPods (macOS)

```bash
cd ios
pod install
cd ..
```

**Verifications:**

- [ ] Command executed without error
- [ ] File `ios/Podfile.lock` created
- [ ] Folder `ios/Pods/` created
- [ ] File `ios/Runner.xcworkspace` present

### 8. iOS Build (Test - macOS only)

```bash
flutter build ios --debug --no-codesign
```

**Verifications:**

- [ ] Build completed without error
- [ ] No signing errors (in debug mode)

---

## 🎨 Application Configuration

### 9. Verify Assets

- [ ] Folder `assets/images/` exists
- [ ] Folder `assets/icons/` exists
- [ ] Assets declared in `pubspec.yaml`

### 10. Verify Main Code

- [ ] File `lib/main.dart` exists
- [ ] Correct imports at top of file
- [ ] Class `CroqScanApp` present
- [ ] Class `HomePage` present
- [ ] No syntax errors

---

## 🚀 Launch Tests

### 11. Launch on Emulator/Simulator

#### Android

```bash
# Start an emulator
flutter emulators --launch <emulator-id>

# Launch the app
flutter run
```

**Verifications:**

- [ ] App launches without crash
- [ ] Home screen displays
- [ ] Theme applied correctly
- [ ] Icon and title visible

#### iOS (macOS)

```bash
flutter run
```

**Verifications:**

- [ ] App launches without crash
- [ ] Home screen displays
- [ ] Theme applied correctly
- [ ] Icon and title visible

### 12. Test Permissions

- [ ] "Allow Camera" button visible (if permission not granted)
- [ ] Clicking button displays permission request
- [ ] Accepting permission hides the button
- [ ] "Scanner" and "Gallery" buttons appear after authorization
- [ ] Clicking buttons displays a SnackBar

### 13. Test Hot Reload

```bash
# While app is running, press 'r'
```

**Verifications:**

- [ ] Hot reload works instantly
- [ ] App state preserved
- [ ] Modifications visible

---

## 🔧 Advanced Verifications

### 14. Check Performance

- [ ] App starts in less than 3 seconds
- [ ] No visible lag in interface
- [ ] Smooth transitions
- [ ] Reasonable memory usage

### 15. Check Logs

```bash
flutter run -v
```

**Look for:**

- [ ] No red errors
- [ ] No critical warnings
- [ ] Permissions properly requested
- [ ] Plugins properly loaded

---

## 📱 Real Device Testing

### 16. Android - Physical Device

**Preparation:**

- [ ] Developer options enabled on device
- [ ] USB debugging enabled
- [ ] Device connected and authorized
  ```bash
  adb devices
  ```

**Tests:**

- [ ] Installation successful
- [ ] App launches
- [ ] Camera permissions requested
- [ ] Camera works (if implemented)

### 17. iOS - Physical Device (macOS)

**Preparation:**

- [ ] iOS device connected
- [ ] Developer certificate configured in Xcode
- [ ] Trusted device

**Tests:**

- [ ] Installation successful
- [ ] App launches
- [ ] Permissions requested
- [ ] No signing errors

---

## 📄 Documentation

### 18. Verify Documentation Files

- [ ] `README.md` - Up to date and complete
- [ ] `SETUP.md` - Detailed configuration guide
- [ ] `QUICK_START.md` - Quick start guide
- [ ] `CONFIGURATION_SUMMARY.md` - Configuration summary
- [ ] `CHECKLIST.md` - This file
- [ ] `assets/README.md` - Assets guide

---

## 🎯 Development Preparation

### 19. Project Structure

- [ ] `lib/` folder organized
- [ ] `assets/` folder ready
- [ ] Git configuration correct
- [ ] `.gitignore` configured

### 20. Development Tools

- [ ] Flutter extension installed in editor
- [ ] Dart SDK recognized
- [ ] Automatic formatting configured
- [ ] Linter configured

---

## ✨ Final Checklist

### Before starting development:

- [ ] ✅ All above sections completed
- [ ] ✅ No blocking errors
- [ ] ✅ App launches on at least one platform
- [ ] ✅ Documentation read
- [ ] ✅ Dev environment ready

### Essential commands memorized:

- [ ] `flutter run` - Launch app
- [ ] `flutter pub get` - Install dependencies
- [ ] `flutter clean` - Clean project
- [ ] `flutter doctor` - Check installation
- [ ] `flutter devices` - See devices

---

## 🚨 Troubleshooting

If a box isn't checked:

1. **Reread the documentation**: `SETUP.md` or `QUICK_START.md`
2. **Check errors**: `flutter doctor -v`
3. **Clean and retry**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
4. **Check logs**: `flutter run -v`
5. **Search the error**: Google or StackOverflow
6. **Ask for help**: GitHub Issue

---

## 🎊 Congratulations!

If all boxes are checked, your CroqScan environment is **100% operational**!

**You're ready to develop! 🚀**

### Suggested next steps:

1. Create a new Git branch
2. Implement the first feature
3. Test regularly
4. Commit often
5. Have fun coding! 😊

---

_Checklist version 1.0 - October 2025_
