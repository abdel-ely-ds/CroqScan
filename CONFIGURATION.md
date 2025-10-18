# Guide de Configuration CroqScan 🚀

Ce guide vous aidera à configurer et lancer votre application CroqScan sur Android et iOS.

## 📱 Configuration Android

### 1. Vérification des Prérequis

- Android Studio installé
- Android SDK installé (minimum API 21)
- Un émulateur Android ou un appareil physique

### 2. Configuration du Projet

Le projet est déjà configuré avec :

- **Nom de package** : `com.croqscan.app`
- **SDK Min** : 21 (Android 5.0)
- **SDK de Compilation** : 34

### 3. Permissions Configurées

✅ Accès à la caméra
✅ Accès au stockage (lecture/écriture)
✅ Accès Internet

### 4. Lancer l'Application Android

```bash
# Vérifier les appareils disponibles
flutter devices

# Lancer l'application
flutter run

# Ou spécifier un appareil
flutter run -d <device-id>
```

### 5. Build de Production Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommandé pour le Play Store)
flutter build appbundle --release
```

L'APK sera disponible dans : `build/app/outputs/flutter-apk/app-release.apk`

---

## 🍎 Configuration iOS

### 1. Vérification des Prérequis

- macOS avec Xcode installé (version 14+)
- CocoaPods installé
- Un compte développeur Apple (pour le déploiement sur appareil réel)

### 2. Installation de CocoaPods (si nécessaire)

```bash
sudo gem install cocoapods
```

### 3. Configuration des Pods

```bash
cd ios
pod install
cd ..
```

### 4. Permissions Configurées

✅ Accès à la caméra (`NSCameraUsageDescription`)
✅ Accès à la galerie photo (`NSPhotoLibraryUsageDescription`)
✅ Ajout de photos (`NSPhotoLibraryAddUsageDescription`)

### 5. Configuration dans Xcode

1. Ouvrez le projet dans Xcode :

```bash
open ios/Runner.xcworkspace
```

2. Dans Xcode :
   - Sélectionnez le projet "Runner" dans le navigateur
   - Allez dans "Signing & Capabilities"
   - Sélectionnez votre équipe de développement
   - Changez le "Bundle Identifier" si nécessaire (actuellement : `com.croqscan.app`)

### 6. Lancer l'Application iOS

```bash
# Vérifier les appareils disponibles
flutter devices

# Lancer sur simulateur iOS
flutter run

# Ou spécifier un appareil
flutter run -d <device-id>
```

### 7. Build de Production iOS

```bash
# Build pour iOS
flutter build ios --release

# Build IPA pour distribution
flutter build ipa --release
```

---

## 🔧 Installation des Dépendances

Avant de lancer l'application, installez toutes les dépendances :

```bash
flutter pub get
```

### Dépendances Installées :

- `camera` : Accès caméra native
- `image_picker` : Sélection d'images
- `permission_handler` : Gestion des permissions
- `qr_code_scanner` : Scanner QR codes
- `mobile_scanner` : Scanner moderne de codes
- `path_provider` : Accès aux répertoires système
- `path` : Manipulation de chemins

---

## 🐛 Dépannage

### Problème : "Flutter command not found"

**Solution** : Assurez-vous que Flutter est dans votre PATH

```bash
export PATH="$PATH:[CHEMIN_VERS_FLUTTER]/flutter/bin"
```

### Problème : Erreurs de build Android

**Solution** : Nettoyez le build

```bash
flutter clean
flutter pub get
flutter run
```

### Problème : Erreurs CocoaPods iOS

**Solution** : Réinstallez les pods

```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Problème : Permissions refusées sur iOS

**Solution** :

1. Désinstallez l'app du simulateur/appareil
2. Relancez avec `flutter run`
3. Acceptez les permissions quand demandées

### Problème : Permissions refusées sur Android

**Solution** :

1. Allez dans Paramètres > Apps > CroqScan > Permissions
2. Activez la caméra et le stockage manuellement

---

## 🎨 Personnalisation

### Changer l'Icône de l'Application

1. Remplacez les icônes dans :
   - `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Changer le Nom de l'Application

- **Android** : Modifiez `android:label` dans `android/app/src/main/AndroidManifest.xml`
- **iOS** : Modifiez `CFBundleDisplayName` dans `ios/Runner/Info.plist`

### Changer les Couleurs du Thème

Modifiez `lib/constants/app_colors.dart` pour personnaliser la palette de couleurs.

---

## 📊 Tests

### Lancer les Tests

```bash
flutter test
```

### Analyser le Code

```bash
flutter analyze
```

---

## 🚀 Déploiement

### Google Play Store (Android)

1. Configurez la signature de l'application
2. Créez un App Bundle : `flutter build appbundle --release`
3. Téléchargez sur la Console Google Play

### Apple App Store (iOS)

1. Archivez dans Xcode : Product > Archive
2. Distribuez via App Store Connect
3. Soumettez pour révision

---

## 📝 Checklist de Lancement

- [ ] `flutter pub get` exécuté avec succès
- [ ] Aucune erreur avec `flutter analyze`
- [ ] Les tests passent : `flutter test`
- [ ] L'application se lance sur Android
- [ ] L'application se lance sur iOS
- [ ] Les permissions caméra fonctionnent
- [ ] Les permissions galerie fonctionnent
- [ ] L'icône d'application est configurée
- [ ] Le nom d'application est configuré
- [ ] La signature est configurée pour la production

---

## 💡 Ressources Utiles

- [Documentation Flutter](https://docs.flutter.dev/)
- [Packages Flutter](https://pub.dev/)
- [Déploiement Android](https://docs.flutter.dev/deployment/android)
- [Déploiement iOS](https://docs.flutter.dev/deployment/ios)

---

Besoin d'aide ? Consultez la documentation ou ouvrez une issue sur GitHub ! 🎉
