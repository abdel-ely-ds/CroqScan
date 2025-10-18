# 🍏 Configuration Sign in with Apple pour PetScan

## 📋 Prérequis

- ✅ Compte Apple Developer actif ($99/an)
- ✅ Xcode installé sur Mac
- ✅ Bundle identifier défini : `com.petscan.app` (ou votre choix)

---

## 🔧 Configuration Apple Developer Portal

### Étape 1 : Créer l'App ID

1. Connectez-vous à [Apple Developer Portal](https://developer.apple.com/)
2. Allez dans **Certificates, Identifiers & Profiles**
3. Cliquez sur **Identifiers** puis **+** (nouveau)
4. Sélectionnez **App IDs** → **Continue**
5. Sélectionnez **App** → **Continue**

### Étape 2 : Configurer l'App ID

1. **Description** : `PetScan App`
2. **Bundle ID** : `com.petscan.app` (ou votre bundle)
3. Dans **Capabilities**, cochez **Sign in with Apple**
4. Cliquez sur **Continue** puis **Register**

---

## 📱 Configuration iOS (Xcode)

### Étape 1 : Ouvrir le projet iOS

```bash
cd ios
open Runner.xcworkspace
```

### Étape 2 : Configurer le Bundle Identifier

1. Dans Xcode, sélectionnez **Runner** dans le navigateur
2. Onglet **General**
3. **Bundle Identifier** : `com.petscan.app` (même que l'App ID)
4. **Team** : Sélectionnez votre équipe Apple Developer

### Étape 3 : Activer Sign in with Apple

1. Onglet **Signing & Capabilities**
2. Cliquez sur **+ Capability**
3. Cherchez et ajoutez **Sign in with Apple**

### Étape 4 : Info.plist (optionnel)

Aucune modification nécessaire pour le MVP. Le package `sign_in_with_apple` gère tout automatiquement.

---

## 🔑 Configuration du projet Flutter

### Fichiers déjà configurés :

✅ `pubspec.yaml` - Dépendances ajoutées

```yaml
dependencies:
  sign_in_with_apple: ^6.1.2
  flutter_secure_storage: ^9.2.2
```

✅ `lib/services/auth_service.dart` - Service d'authentification  
✅ `lib/screens/login_screen.dart` - Écran de connexion  
✅ `lib/screens/splash_screen.dart` - Vérification auto-login

---

## 🧪 Test sur simulateur/appareil

### Sur simulateur iOS :

```bash
flutter run
```

⚠️ **Note** : Sign in with Apple peut ne pas fonctionner sur tous les simulateurs. Testez de préférence sur un appareil réel.

### Sur appareil iOS réel :

1. Connectez votre iPhone
2. Assurez-vous d'être connecté à iCloud
3. Lancez l'app :

```bash
flutter run
```

---

## 📊 Flux d'authentification

### Première utilisation :

1. **Splash screen** (1.5s) → Vérifie l'authentification
2. **Écran de connexion** → Affiche "Continuer avec Apple 🍏"
3. **Modal Apple** → Demande autorisation (email, nom)
4. **Sauvegarde locale** → Stockage sécurisé (iOS Keychain)
5. **Navigation** → Page d'accueil de l'app

### Utilisations suivantes :

1. **Splash screen** → Détecte l'utilisateur connecté
2. **Auto-login** → Navigation directe vers l'accueil
3. **Pas de modal** Apple à chaque fois

### Déconnexion :

1. Page **Profil** → Bouton "Se déconnecter"
2. **Confirmation** → Dialog de confirmation
3. **Suppression** → Données d'auth supprimées (favoris conservés)
4. **Retour** → Écran de connexion

---

## 🔒 Données stockées localement

| Donnée                 | Emplacement       | Sécurité   |
| ---------------------- | ----------------- | ---------- |
| `apple_user_id`        | iOS Keychain      | ✅ Chiffré |
| `apple_identity_token` | iOS Keychain      | ✅ Chiffré |
| `apple_email`          | iOS Keychain      | ✅ Chiffré |
| `apple_name`           | iOS Keychain      | ✅ Chiffré |
| Favoris                | SharedPreferences | 🔓 Local   |
| Historique             | SharedPreferences | 🔓 Local   |
| Profil animal          | SharedPreferences | 🔓 Local   |

---

## ⚠️ Limitations du MVP

### Ce qui fonctionne :

- ✅ Authentification Apple locale
- ✅ Stockage sécurisé iOS Keychain
- ✅ Auto-login à chaque ouverture
- ✅ Déconnexion propre

### Ce qui ne fonctionne PAS (mode local) :

- ❌ Synchronisation cloud des favoris
- ❌ Accès depuis plusieurs appareils
- ❌ Backup des données
- ❌ Récupération de compte

---

## 🚀 Prochaines étapes (v2)

Pour une vraie synchronisation cloud, il faudra :

1. **Backend** : Serveur Node.js/Firebase
2. **Vérification token** : Valider le `identityToken` côté serveur
3. **Base de données** : PostgreSQL/Firestore
4. **API** : Endpoints pour favoris, profils, etc.
5. **Sync** : Stratégie de synchronisation offline-first

---

## 🐛 Dépannage

### Erreur "Invalid Client"

- Vérifiez que le Bundle ID dans Xcode correspond exactement à celui dans Apple Developer Portal
- Vérifiez que Sign in with Apple est activé dans Capabilities

### Erreur "1000" ou "1001"

- L'utilisateur a annulé la connexion → Normal

### Le bouton ne s'affiche pas

- Vérifiez que vous êtes sur iOS (pas Android pour le MVP)
- Sign in with Apple n'est disponible que sur iOS 13+

---

## 📚 Ressources

- [Documentation Sign in with Apple](https://developer.apple.com/sign-in-with-apple/)
- [Package Flutter](https://pub.dev/packages/sign_in_with_apple)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

---

**Dernière mise à jour** : Octobre 2025  
**Version** : MVP v1.0 (Local only)
