# CroqScan 📱

![CroqScan](image.png)

Mobile application for scanning QR codes and documents on Android and iOS.

**Supported Platforms:** Android 📱 | iOS 🍎

## 🚀 Features

- QR code and barcode scanner
- Import images from gallery
- Modern and intuitive interface
- Dark mode support
- Native Android and iOS applications

## 📋 Prerequisites

- Flutter SDK (version >=3.9.2)
- For iOS: Xcode installed and configured
- For Android: Android Studio with Android SDK

## 🛠️ Installation

1. Clone the repository:

```bash
git clone <your-repo>
cd CroqScan
```

2. Install dependencies:

```bash
flutter pub get
```

3. For iOS, install pods (if necessary):

```bash
cd ios
pod install
cd ..
```

## 🏃 Running the Application

### Android

```bash
flutter run
```

or for a production build:

```bash
flutter build apk --release
```

### iOS

```bash
flutter run
```

or for a production build:

```bash
flutter build ios --release
```

**iOS Note**: You need an Apple Developer account and configure code signing in Xcode. See the [Flutter iOS documentation](https://docs.flutter.dev/platform-integration/ios/setup).

## 🔑 Permissions

The application requires the following permissions:

- **Camera**: To scan QR codes and take photos
- **Photo gallery**: To import existing images
- **Storage**: To save scans

## 📦 Main Dependencies

- `camera`: Camera access
- `image_picker`: Image selection
- `permission_handler`: Permission management
- `mobile_scanner`: QR/barcode scanner
- `path_provider`: System directory access

## 🏗️ Project Structure

```
lib/
  ├── main.dart           # Application entry point
  └── (coming soon)       # Other files and folders

android/                  # Android native configuration
ios/                      # iOS native configuration
assets/                   # Images and icons
```

## 🔧 Configuration

### Android

- **Application ID**: `com.croqscan.app`
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest stable version

### iOS

- **Bundle ID**: To be configured in Xcode
- **Deployment Target**: iOS 12.0+

## 📝 Next Steps

- [ ] Implement QR/barcode scanner
- [ ] Add document scanning feature
- [ ] Scan history
- [ ] Share results
- [ ] PDF export

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or pull request.

## 📞 Support

For any questions or issues, please open an issue on GitHub.
