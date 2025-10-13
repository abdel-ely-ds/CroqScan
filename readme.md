# CroqScan 🐾

![CroqScan](image.png)

**Pet Product Health Scanner** - Your trusted companion for checking the quality and safety of pet products.

Like Yuka for humans, CroqScan helps you scan and evaluate pet food and products to ensure the best health for your furry, feathered, and scaly friends.

**Supported Platforms:** Android 📱 | iOS 🍎

---

## 🚀 Features

### ✅ Core Functionality

- **Barcode Scanner** - Scan product barcodes using your camera
- **Product Search** - Browse and search our product database
- **Health Scoring** - 0-100 health score with color-coded ratings
- **Detailed Analysis** - View ingredients, nutritional info, warnings, and benefits
- **Multi-Pet Support** - Products categorized for dogs, cats, birds, rabbits, and more

### 🎨 User Experience

- **Beautiful UI** - Modern, clean design with Material 3
- **Intuitive Navigation** - Simple and easy to use
- **Trustworthy Design** - Professional interface that inspires confidence
- **Responsive** - Smooth animations and fast performance

### 📊 Product Information

- **Health Score** (0-100) with visual indicators:
  - 🟢 75-100: Excellent
  - 🟡 50-74: Good
  - 🟠 25-49: Mediocre
  - 🔴 0-24: Poor
- **Ingredient List** - Complete list of all ingredients
- **Nutritional Analysis** - Protein, fat, fiber, moisture, ash content
- **Warnings** - Alerts for harmful ingredients or concerns
- **Benefits** - Highlights of positive qualities

---

## 📋 Prerequisites

- Flutter SDK (version >=3.9.2)
- For iOS: Xcode installed and configured
- For Android: Android Studio with Android SDK
- A device with a camera (for scanning)

---

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

3. For iOS, install pods:

```bash
cd ios
pod install
cd ..
```

---

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

---

## 📱 How to Use

### 1. Scan a Product

- Open the app
- Tap "Scan a Product"
- Point your camera at the barcode
- View instant health score and details

### 2. Search Products

- Open the app
- Tap "Search Products"
- Type product name or brand
- Browse and tap to view details

### 3. Understand the Score

- **Excellent (75-100)**: High quality, safe for your pet
- **Good (50-74)**: Acceptable but could be better
- **Mediocre (25-49)**: Not recommended, check alternatives
- **Poor (0-24)**: Avoid - contains harmful ingredients

---

## 🔑 Permissions

The application requires the following permissions:

- **Camera**: To scan product barcodes
- **Photo gallery**: To import images (future feature)
- **Storage**: To save scan history (future feature)

---

## 📦 Main Dependencies

- `camera`: Camera access
- `image_picker`: Image selection
- `permission_handler`: Permission management
- `mobile_scanner`: QR/barcode scanner
- `path_provider`: System directory access

---

## 🏗️ Project Structure

```
lib/
  ├── main.dart                 # Application entry point
  ├── constants/
  │   └── app_colors.dart       # Color palette and theming
  ├── models/
  │   └── product.dart          # Product and nutritional data models
  ├── data/
  │   └── sample_products.dart  # Sample product database
  ├── screens/
  │   ├── home_screen.dart      # Main home screen
  │   ├── scanner_screen.dart   # Barcode scanner
  │   ├── search_screen.dart    # Product search
  │   └── product_details_screen.dart # Product details view
  └── widgets/
      ├── score_badge.dart      # Health score badge
      └── product_card.dart     # Product list item

android/                         # Android native configuration
ios/                             # iOS native configuration
assets/                          # Images and icons
```

---

## 🎨 Design Philosophy

CroqScan is designed with three key principles:

1. **Trust** - Professional design that conveys reliability and expertise
2. **Simplicity** - Easy to use for everyone, from tech-savvy to beginners
3. **Clarity** - Clear visual indicators and straightforward information

### Color System

- **Blue (#2D9CDB)** - Primary color, represents trust and health
- **Green (#27AE60)** - Excellent products, safe choice
- **Yellow/Orange (#F2994A)** - Caution, mediocre products
- **Red (#EB5757)** - Warning, poor quality

---

## 🔧 Configuration

### Android

- **Application ID**: `com.croqscan.app`
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest stable version

### iOS

- **Bundle ID**: To be configured in Xcode
- **Deployment Target**: iOS 12.0+

---

## 📝 Roadmap

### Current (v1.0)

- [x] Barcode scanning
- [x] Product search
- [x] Health scoring system
- [x] Detailed product information
- [x] Sample product database

### Planned Features

- [ ] Real API integration
- [ ] User accounts
- [ ] Scan history
- [ ] Favorites list
- [ ] Product comparison
- [ ] Share results
- [ ] Community ratings
- [ ] Custom pet profiles
- [ ] Offline mode
- [ ] Multi-language support

---

## 🤝 Contributing

Contributions are welcome! This app is designed to help pet owners make better choices for their pets' health.

If you'd like to contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

This project is licensed under the MIT License.

---

## 🐾 About

CroqScan was created to help pet owners make informed decisions about the products they buy for their beloved companions. Just like how Yuka helps humans eat better, CroqScan helps pets live healthier lives.

**Made with ❤️ for pets and their humans**

---

## 📞 Support

For questions, feature requests, or bug reports, please open an issue on GitHub.

---

## 🙏 Acknowledgments

- Inspired by Yuka app
- Thanks to the Flutter community
- Icons by Flutter Material Icons
- Sample data for demonstration purposes only

---

**Remember: Always consult with your veterinarian for specific dietary needs and health concerns for your pets!** 🐕 🐈 🐦
