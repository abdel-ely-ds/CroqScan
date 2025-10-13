# 🚀 CroqScan Quick Start

Ultra-fast guide to launch your application in minutes!

## ⚡ Express Installation (3 steps)

### 1️⃣ Install dependencies

```bash
flutter pub get
```

### 2️⃣ Launch the application

```bash
flutter run
```

### 3️⃣ That's it! 🎉

---

## 📱 Essential Commands

### Development

```bash
# Launch the app
flutter run

# Launch in verbose debug mode
flutter run -v

# Hot reload (in the terminal while app is running)
# Press 'r'

# Hot restart (in the terminal)
# Press 'R'
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release
```

### Maintenance

```bash
# Clean the project
flutter clean

# Analyze the code
flutter analyze

# Run tests
flutter test

# See connected devices
flutter devices
```

---

## 🔍 Select a Specific Device

```bash
# List all devices
flutter devices

# Launch on a specific device
flutter run -d <device-id>

# Examples:
flutter run -d android         # Android Emulator/Device
flutter run -d iphone          # iOS Simulator/Device
```

---

## 🐛 Common Problems

### App won't launch?

```bash
flutter clean
flutter pub get
flutter run
```

### Build error?

```bash
# Android
cd android && ./gradlew clean && cd ..
flutter clean && flutter pub get

# iOS
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
flutter clean && flutter pub get
```

### Permissions not working?

1. Uninstall the app from the device
2. Relaunch with `flutter run`
3. Accept the permissions

---

## 📋 Checklist Before Starting

- [ ] Flutter installed (`flutter --version`)
- [ ] An editor (VS Code / Android Studio / Xcode)
- [ ] A device/emulator connected (`flutter devices`)
- [ ] Dependencies installed (`flutter pub get`)

---

## 🎯 Next Steps

After the first launch:

1. **Test the permissions**: Click "Allow Camera"
2. **Explore the interface**: Familiarize yourself with the UI
3. **Check SETUP.md**: For advanced configuration
4. **Read README.md**: For complete documentation

---

## 💡 Pro Tips

### Shortcuts During Execution

- `r` - Hot reload (fast)
- `R` - Hot restart (complete)
- `p` - Display debug painting
- `o` - Toggle iOS/Android
- `q` - Quit

### Performance

```bash
# Release mode (faster)
flutter run --release

# Profile mode (for profiling)
flutter run --profile
```

### Debug

```bash
# Detailed logs
flutter run --verbose

# Analyze performance
flutter run --profile
# Then open DevTools
```

---

## 📞 Need Help?

1. **Detailed documentation**: See `SETUP.md`
2. **Flutter Docs**: https://docs.flutter.dev
3. **Issues**: Open a GitHub issue

---

**Happy coding! 🚀**
