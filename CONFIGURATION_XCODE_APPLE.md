# 🔧 Configuration Xcode pour Sign in with Apple - Guide Pratique

## ⚠️ Problème actuel

Erreur `1000` = Sign in with Apple n'est pas configuré correctement dans Xcode.

---

## ✅ Solution : Configuration en 5 minutes

### Xcode est déjà ouvert. Suivez exactement ces étapes :

---

## 📋 Étape 1 : Vérifier le projet

1. Dans le **navigateur de gauche** (panneau de gauche)
2. Cliquez sur **Runner** (icône bleue tout en haut, premier élément)
3. Vous devriez voir apparaître les onglets : General, Signing & Capabilities, etc.

---

## 🔐 Étape 2 : Configurer le Signing

1. Cliquez sur l'onglet **"Signing & Capabilities"**
2. Sous la section **"Signing"** :

   - ✅ Cochez **"Automatically manage signing"**
   - **Team** : Sélectionnez votre compte Apple Developer
     - Si vide ou "None" : Cliquez dessus et sélectionnez votre compte
     - Si vous n'avez pas de Team, vous devez vous connecter avec votre Apple ID :
       - Xcode → Settings → Accounts → Ajouter votre Apple ID

3. **Bundle Identifier** devrait afficher : `com.mbonnafon.croqScan`

---

## 🍏 Étape 3 : Ajouter Sign in with Apple

**C'est l'étape critique !**

1. Toujours dans **"Signing & Capabilities"**
2. Cliquez sur le bouton **"+ Capability"** (en haut à gauche de la section)
3. Une fenêtre de recherche s'ouvre
4. Tapez : **"Sign in with Apple"**
5. **Double-cliquez** sur "Sign in with Apple" pour l'ajouter
6. Une nouvelle section devrait apparaître avec le titre **"Sign in with Apple"**

---

## 📄 Étape 4 : Vérifier le fichier Entitlements

1. Dans le navigateur de gauche, cherchez **Runner.entitlements**

   - Il devrait être dans le dossier **Runner**
   - Je viens de le créer pour vous

2. Si vous ne le voyez pas :

   - Clic droit sur le dossier **Runner** (dans le navigateur)
   - **Add Files to "Runner"...**
   - Naviguez vers `ios/Runner/Runner.entitlements`
   - Cliquez **Add**

3. Cliquez sur **Runner.entitlements** pour l'ouvrir
   - Vérifiez qu'il contient :
   ```xml
   <key>com.apple.developer.applesignin</key>
   <array>
       <string>Default</string>
   </array>
   ```

---

## ✅ Étape 5 : Vérification finale

Dans **Signing & Capabilities**, vous devriez voir **3 sections** :

1. ✅ **Signing (Debug)**

   - Team : Votre compte
   - Signing Certificate : Apple Development
   - Provisioning Profile : (géré automatiquement)

2. ✅ **Signing (Release)**

   - Team : Votre compte
   - Signing Certificate : Apple Distribution
   - Provisioning Profile : (géré automatiquement)

3. ✅ **Sign in with Apple**
   - Aucune configuration supplémentaire requise

---

## 🧪 Test

1. Fermez Xcode
2. Dans le terminal :

```bash
cd /Users/Marc-Enzo\ Bonnafon/programming/perso/CroqScan
flutter clean
flutter pub get
flutter run
```

3. **Sur un iPhone réel** (le simulateur peut ne pas fonctionner)
4. Cliquez sur **"Continuer avec Apple"**
5. La modal Apple devrait s'afficher correctement

---

## ⚠️ Si l'erreur persiste

### Vérification Apple Developer Portal

1. Allez sur https://developer.apple.com/account/
2. **Certificates, Identifiers & Profiles**
3. Cliquez sur **Identifiers**
4. Cherchez votre App ID : `com.mbonnafon.croqScan`

   **Si n'existe pas :**

   - Cliquez sur **+** (nouveau)
   - Sélectionnez **App IDs** → Continue
   - Sélectionnez **App** → Continue
   - Description : `PetScan`
   - Bundle ID : `com.mbonnafon.croqScan`
   - Dans **Capabilities**, cochez **Sign in with Apple**
   - Continue → Register

   **Si existe déjà :**

   - Cliquez dessus pour l'éditer
   - Vérifiez que **Sign in with Apple** est coché
   - Save

---

## 🎯 Résultat attendu

Après configuration :

- ✅ Le bouton "Continuer avec Apple" fonctionne
- ✅ Modal Apple s'affiche avec Face ID / Touch ID
- ✅ L'utilisateur peut s'authentifier
- ✅ Les données sont sauvegardées dans le Keychain
- ✅ Pas d'erreur 1000

---

## 📞 Aide supplémentaire

Si vous avez toujours l'erreur 1000 :

- Vérifiez que vous avez un **Apple Developer Program** actif ($99/an)
- Testez sur un **appareil réel** (pas simulateur)
- Assurez-vous d'être **connecté à iCloud** sur l'appareil
- Vérifiez que l'App ID existe sur developer.apple.com

---

**Date** : Octobre 2025  
**Version** : Configuration iOS pour Sign in with Apple
