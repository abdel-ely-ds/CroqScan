# 🚀 Guide Rapide CroqScan

Guide ultra-rapide pour lancer votre application en quelques minutes !

## ⚡ Installation Express (3 étapes)

### 1️⃣ Installer les dépendances

```bash
flutter pub get
```

### 2️⃣ Lancer l'application

```bash
flutter run
```

### 3️⃣ C'est tout ! 🎉

---

## 📱 Commandes Essentielles

### Développement

```bash
# Lancer l'app
flutter run

# Lancer en mode debug verbeux
flutter run -v

# Hot reload (dans le terminal pendant que l'app tourne)
# Appuyez sur 'r'

# Hot restart (dans le terminal)
# Appuyez sur 'R'
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS (macOS uniquement)
flutter build ios --release
```

### Maintenance

```bash
# Nettoyer le projet
flutter clean

# Analyser le code
flutter analyze

# Lancer les tests
flutter test

# Voir les appareils connectés
flutter devices
```

---

## 🔍 Sélectionner un Appareil Spécifique

```bash
# Lister tous les appareils
flutter devices

# Lancer sur un appareil spécifique
flutter run -d <device-id>

# Exemples :
flutter run -d android         # Émulateur/Appareil Android
flutter run -d iphone          # Simulateur/Appareil iOS
```

---

## 🐛 Problèmes Courants

### L'app ne se lance pas ?

```bash
flutter clean
flutter pub get
flutter run
```

### Erreur de build ?

```bash
# Android
cd android && ./gradlew clean && cd ..
flutter clean && flutter pub get

# iOS
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
flutter clean && flutter pub get
```

### Permissions ne fonctionnent pas ?

1. Désinstallez l'app de l'appareil
2. Relancez avec `flutter run`
3. Acceptez les permissions

---

## 📋 Checklist Avant de Commencer

- [ ] Flutter installé (`flutter --version`)
- [ ] Un éditeur (VS Code / Android Studio / Xcode)
- [ ] Un appareil/émulateur connecté (`flutter devices`)
- [ ] Dépendances installées (`flutter pub get`)

---

## 🎯 Prochaines Étapes

Après le premier lancement :

1. **Testez le scanner** : Utilisez les codes-barres d'exemple
2. **Explorez la recherche** : Cherchez "chien", "chat", "premium"
3. **Consultez CONFIGURATION.md** : Pour la configuration avancée
4. **Lisez README.md** : Pour la documentation complète

---

## 💡 Astuces Pro

### Raccourcis Pendant l'Exécution

- `r` - Hot reload (rapide)
- `R` - Hot restart (complet)
- `p` - Afficher le debug painting
- `q` - Quitter

### Performance

```bash
# Mode release (plus rapide)
flutter run --release

# Mode profile (pour le profilage)
flutter run --profile
```

### Debug

```bash
# Logs détaillés
flutter run --verbose

# Analyser la performance
flutter run --profile
# Puis ouvrir DevTools
```

---

## 🧪 Tester l'Application

### Codes-Barres d'Exemple à Scanner

- `3017620422003` - Croquettes Premium Chien (Score: 85)
- `3017620422010` - Croquettes Budget (Score: 35)
- `3017620422027` - Pâtée Chat Saumon (Score: 92)
- `3017620422041` - Friandises Colorants (Score: 22)

### Termes de Recherche à Tester

- "chien" → Produits pour chiens
- "chat" → Nourriture pour chats
- "premium" → Produits de qualité
- "bio" → Produits biologiques

---

## 📞 Besoin d'Aide ?

1. **Documentation détaillée** : Voir `CONFIGURATION.md`
2. **Guide d'utilisation** : Voir `GUIDE_UTILISATEUR.md`
3. **Flutter Docs** : https://docs.flutter.dev
4. **Issues** : Ouvrir une issue GitHub

---

**Bon développement ! 🚀**
