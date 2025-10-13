# CroqScan Configuration Guide 🚀

This guide will help you configure and launch your CroqScan application on Android and iOS.

## 📱 Android Configuration

### 1. Prerequisites Verification

- Android Studio installed
- Android SDK installed (minimum API 21)
- An Android emulator or physical device

### 2. Project Configuration

The project is already configured with:

- **Package name**: `com.croqscan.app`
- **Min SDK**: 21 (Android 5.0)
- **Compile SDK**: 34

### 3. Configured Permissions

✅ Camera access
✅ Storage access (read/write)
✅ Internet access

### 4. Launch Android Application

```bash
# Check available devices
flutter devices

# Launch the application
flutter run

# Or specify a device
flutter run -d <device-id>
```

### 5. Android Production Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

The APK will be available in: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🍎 iOS Configuration

### 1. Prerequisites Verification

- macOS with Xcode installed (version 14+)
- CocoaPods installed
- An Apple Developer account (for deployment on real device)

### 2. CocoaPods Installation (if necessary)

```bash
sudo gem install cocoapods
```

### 3. Pods Configuration

```bash
cd ios
pod install
cd ..
```

### 4. Configured Permissions

✅ Camera access (`NSCameraUsageDescription`)
✅ Photo gallery access (`NSPhotoLibraryUsageDescription`)
✅ Add photos (`NSPhotoLibraryAddUsageDescription`)

### 5. Configuration in Xcode

1. Open the project in Xcode:

```bash
open ios/Runner.xcworkspace
```

2. In Xcode:
   - Select the "Runner" project in the navigator
   - Go to "Signing & Capabilities"
   - Select your development team
   - Change the "Bundle Identifier" if necessary (currently: `com.croqscan.app`)

### 6. Launch iOS Application

```bash
# Check available devices
flutter devices

# Launch on iOS simulator
flutter run

# Or specify a device
flutter run -d <device-id>
```

### 7. iOS Production Build

```bash
# Build for iOS
flutter build ios --release

# Build IPA for distribution
flutter build ipa --release
```

---

## 🔧 Dependencies Installation

Before launching the application, install all dependencies:

```bash
flutter pub get
```

### Installed Dependencies:

- `camera`: Native camera access
- `image_picker`: Image selection
- `permission_handler`: Permission management
- `qr_code_scanner`: QR code scanner
- `mobile_scanner`: Modern code scanner
- `path_provider`: System directory access
- `path`: Path manipulation

---

## 🐛 Troubleshooting

### Problem: "Flutter command not found"

**Solution**: Make sure Flutter is in your PATH

```bash
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"
```

### Problem: Android build errors

**Solution**: Clean the build

```bash
flutter clean
flutter pub get
flutter run
```

### Problem: CocoaPods iOS errors

**Solution**: Reinstall pods

```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Problem: Permissions denied on iOS

**Solution**:

1. Uninstall the app from simulator/device
2. Relaunch with `flutter run`
3. Accept permissions when requested

### Problem: Permissions denied on Android

**Solution**:

1. Go to Settings > Apps > CroqScan > Permissions
2. Enable camera and storage manually

---

## 🎨 Customization

### Change Application Icon

1. Replace icons in:
   - `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Change Application Name

- **Android**: Modify `android:label` in `android/app/src/main/AndroidManifest.xml`
- **iOS**: Modify `CFBundleDisplayName` in `ios/Runner/Info.plist`

### Change Theme Colors

Modify `lib/main.dart`, lines 17-18 for light theme and lines 28-29 for dark theme.

---

## 📊 Testing

### Run Tests

```bash
flutter test
```

### Analyze Code

```bash
flutter analyze
```

---

## 🚀 Deployment

### Google Play Store (Android)

1. Configure application signing
2. Create an App Bundle: `flutter build appbundle --release`
3. Upload to Google Play Console

### Apple App Store (iOS)

1. Archive in Xcode: Product > Archive
2. Distribute via App Store Connect
3. Submit for review

---

## 📝 Launch Checklist

- [ ] `flutter pub get` executed successfully
- [ ] No errors with `flutter analyze`
- [ ] Tests pass: `flutter test`
- [ ] Application launches on Android
- [ ] Application launches on iOS
- [ ] Camera permissions work
- [ ] Gallery permissions work
- [ ] Application icon configured
- [ ] Application name configured
- [ ] Signing configured for production

---

## 💡 Useful Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Packages](https://pub.dev/)
- [Android Deployment](https://docs.flutter.dev/deployment/android)
- [iOS Deployment](https://docs.flutter.dev/deployment/ios)

---

Need help? Check the documentation or open an issue on GitHub! 🎉
