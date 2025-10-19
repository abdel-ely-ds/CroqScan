# Guide : Gérer les Cas Complexes dans les Golden Tests

## 🎯 Vue d'ensemble

Certains widgets et écrans sont difficiles à tester avec les golden tests en raison de :
- Dépendances hardware (caméra, GPS, capteurs)
- Problèmes de layout (overflow, animations infinies)
- Interactions avec des services externes
- Taille de contenu dynamique

Ce guide explique comment gérer ces situations.

---

## 📷 Cas 1 : Widgets avec Caméra (ScannerScreen)

### Problème

```dart
// ❌ Ce test échoue car la caméra nécessite des permissions hardware
testWidgets('ScannerScreen test', (tester) async {
  await tester.pumpWidget(MaterialApp(home: ScannerScreen()));
  // Error: Camera permission denied or hardware not available
});
```

### Solutions

#### Solution A : Mock la Vue Caméra (Recommandé)

Créez une version mockée qui ressemble au scanner sans utiliser la caméra réelle :

```dart
class MockedScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scanner')),
      body: Stack(
        children: [
          // Fond noir simulant la caméra
          Container(color: Colors.black),
          // Cadre de scan
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 50,
            child: Text('Placez le code-barres dans le cadre'),
          ),
        ],
      ),
    );
  }
}
```

**Avantages** :
- ✅ Teste l'UI sans dépendances hardware
- ✅ Rapide et fiable
- ✅ Fonctionne en CI/CD

**Fichier** : `scanner_screen_mocked_golden_test.dart`

#### Solution B : Tester uniquement les Contrôles

Si le widget caméra est encapsulé, testez les contrôles autour :

```dart
testWidgets('Scanner controls golden test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scanner'),
          actions: [
            IconButton(icon: Icon(Icons.flash_on), onPressed: () {}),
            IconButton(icon: Icon(Icons.flip_camera), onPressed: () {}),
          ],
        ),
        body: Center(
          child: Text('Camera Preview Area'),
        ),
      ),
    ),
  );
  
  await expectLater(
    find.byType(Scaffold),
    matchesGoldenFile('scanner_controls.png'),
  );
});
```

#### Solution C : Dependency Injection

Injectez la caméra comme dépendance mockable :

```dart
class ScannerScreen extends StatelessWidget {
  final Widget cameraWidget;
  
  const ScannerScreen({
    Key? key,
    this.cameraWidget = const CameraPreview(), // Production
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          cameraWidget, // Mockable
          // ... autres widgets
        ],
      ),
    );
  }
}

// Dans les tests
testWidgets('Scanner golden test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ScannerScreen(
        cameraWidget: Container(color: Colors.black), // Mock
      ),
    ),
  );
});
```

---

## 📱 Cas 2 : Écrans avec Overflow (LoginScreen)

### Problème

```dart
// ❌ Ce test échoue avec "RenderFlex overflowed"
testWidgets('LoginScreen test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: LoginScreen()),
  );
  // Error: A RenderFlex overflowed by 230 pixels
});
```

### Solutions

#### Solution A : Tester par Sections (Recommandé)

Divisez l'écran en sections testables :

```dart
// Section 1 : Header
testWidgets('Login header golden', (tester) async {
  await tester.binding.setSurfaceSize(Size(375, 300));
  await tester.pumpWidget(
    MaterialApp(home: LoginScreenHeader()),
  );
});

// Section 2 : Formulaire
testWidgets('Login form golden', (tester) async {
  await tester.binding.setSurfaceSize(Size(375, 400));
  await tester.pumpWidget(
    MaterialApp(home: LoginScreenForm()),
  );
});

// Section 3 : Boutons sociaux
testWidgets('Login social buttons golden', (tester) async {
  await tester.binding.setSurfaceSize(Size(375, 200));
  await tester.pumpWidget(
    MaterialApp(home: LoginScreenSocialButtons()),
  );
});
```

**Avantages** :
- ✅ Teste chaque partie de l'UI
- ✅ Pas de problèmes d'overflow
- ✅ Plus facile de détecter les régressions spécifiques

#### Solution B : Augmenter la Surface de Test

```dart
testWidgets('LoginScreen full golden', (tester) async {
  // Taille suffisante pour tout le contenu
  await tester.binding.setSurfaceSize(Size(375, 1200));
  
  await tester.pumpWidget(
    MaterialApp(home: LoginScreen()),
  );
  
  await expectLater(
    find.byType(LoginScreen),
    matchesGoldenFile('login_screen_full.png'),
  );
});
```

**Inconvénients** :
- ❌ Image golden très grande
- ❌ Difficile de voir les détails
- ❌ Changements mineurs = grande image diff

#### Solution C : Wrapper dans SingleChildScrollView

```dart
testWidgets('LoginScreen scrollable golden', (tester) async {
  await tester.binding.setSurfaceSize(Size(375, 667));
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: LoginScreen(),
        ),
      ),
    ),
  );
  
  // Scroll vers le bas pour capturer tout le contenu
  await tester.drag(
    find.byType(SingleChildScrollView),
    Offset(0, -500),
  );
  await tester.pumpAndSettle();
});
```

---

## 🎨 Cas 3 : Widgets avec Overflow de Design (ScoreBadge)

### Problème

```dart
// ❌ Widget mal designé : contenu trop grand pour le conteneur
class ScoreBadge extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: Column(
        children: [
          Text('95', style: TextStyle(fontSize: 28)),  // Trop grand
          Text('/100', style: TextStyle(fontSize: 12)),
          Text('Excellent', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
// Error: A RenderFlex overflowed by 5.0 pixels
```

### Solutions

#### Solution A : Fixer le Widget (Recommandé)

Corrigez le design du widget source :

```dart
// ✅ Widget corrigé avec FittedBox ou tailles ajustées
class ScoreBadge extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: FittedBox(  // Adapte automatiquement le contenu
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text('95', style: TextStyle(fontSize: 28)),
              Text('/100', style: TextStyle(fontSize: 12)),
              Text('Excellent', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Solution B : Augmenter la Taille dans les Tests

```dart
testWidgets('ScoreBadge golden', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ScoreBadge(
        score: 95,
        size: 120,  // Plus grand dans les tests
      ),
    ),
  );
});
```

#### Solution C : Wrapper dans un Conteneur Plus Grand

```dart
testWidgets('ScoreBadge golden', (tester) async {
  await tester.binding.setSurfaceSize(Size(300, 300));
  
  await tester.pumpWidget(
    MaterialApp(
      home: Center(
        child: ScoreBadge(score: 95),
      ),
    ),
  );
});
```

---

## ⏱️ Cas 4 : Animations Infinies (Timeouts)

### Problème

```dart
// ❌ pumpAndSettle timeout - animations ne se terminent jamais
testWidgets('Animated screen test', (tester) async {
  await tester.pumpWidget(MaterialApp(home: AnimatedScreen()));
  await tester.pumpAndSettle();  // Timeout!
});
```

### Solutions

#### Solution A : Utiliser pump() avec Duration

```dart
// ✅ Éviter pumpAndSettle, utiliser pump manuel
testWidgets('Animated screen golden', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: AnimatedScreen()),
  );
  
  // Pump plusieurs fois avec duration
  await tester.pump(Duration(seconds: 1));
  await tester.pump(Duration(milliseconds: 500));
  
  await expectLater(
    find.byType(AnimatedScreen),
    matchesGoldenFile('animated_screen.png'),
  );
});
```

#### Solution B : Désactiver les Animations dans les Tests

```dart
testWidgets('Screen without animations', (tester) async {
  // Désactive toutes les animations
  tester.binding.window.physicalSizeTestValue = Size(375, 667);
  tester.binding.window.devicePixelRatioTestValue = 1.0;
  
  await tester.pumpWidget(
    MaterialApp(
      home: AnimatedScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: true,  // Désactive animations
          ),
          child: child!,
        );
      },
    ),
  );
  
  await tester.pump();
});
```

#### Solution C : Mocker les Animations

```dart
class AnimatedScreen extends StatelessWidget {
  final bool enableAnimations;
  
  const AnimatedScreen({
    this.enableAnimations = true,  // False dans tests
  });
  
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: enableAnimations 
        ? Duration(seconds: 2)
        : Duration.zero,  // Pas d'animation en test
      // ...
    );
  }
}
```

---

## 🌐 Cas 5 : Services Externes (API, Base de Données)

### Problème

```dart
// ❌ Dépend d'une API externe
class ProductDetailsScreen extends StatefulWidget {
  void initState() {
    super.initState();
    _loadProduct();  // Appel API
  }
}
```

### Solutions

#### Solution A : Fournir des Données Mock

```dart
testWidgets('ProductDetails golden', (tester) async {
  final mockProduct = Product(
    id: '123',
    name: 'Test Product',
    score: 85,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: ProductDetailsScreen(
        product: mockProduct,  // Données mockées
        isTestMode: true,  // Désactive chargement API
      ),
    ),
  );
});
```

#### Solution B : Utiliser un Provider Mock

```dart
testWidgets('Screen with provider golden', (tester) async {
  await tester.pumpWidget(
    Provider<ProductService>(
      create: (_) => MockProductService(),  // Mock service
      child: MaterialApp(
        home: ProductDetailsScreen(),
      ),
    ),
  );
});
```

---

## 📋 Checklist : Choisir la Bonne Stratégie

| Problème | Solution Recommandée | Alternative |
|----------|---------------------|-------------|
| 📷 Caméra/Hardware | Mock la vue | Test les contrôles uniquement |
| 📱 Overflow vertical | Tester par sections | Augmenter surface |
| 🎨 Overflow dans widget | Fixer le widget | Augmenter taille |
| ⏱️ Animations infinies | pump() avec Duration | Désactiver animations |
| 🌐 API externe | Mock les données | Provider mock |
| 🔄 State complexe | Injection de dépendances | Wrapper de test |

---

## ✅ Bonnes Pratiques

### DO ✅

1. **Isoler les widgets problématiques**
   ```dart
   // Tester le wrapper, pas le contenu problématique
   testWidgets('Screen wrapper', (tester) async {
     await tester.pumpWidget(
       MaterialApp(
         home: Scaffold(
           appBar: AppBar(title: Text('Scanner')),
           body: Container(color: Colors.black), // Mock caméra
         ),
       ),
     );
   });
   ```

2. **Documenter pourquoi un test est mocké**
   ```dart
   /// Tests the scanner UI without camera hardware
   /// Real camera requires permissions and hardware not available in tests
   testWidgets('Scanner UI mock', (tester) async {
     // ...
   });
   ```

3. **Créer des variantes testables**
   ```dart
   class ScannerScreen extends StatelessWidget {
     final bool isTestMode;
     
     const ScannerScreen({this.isTestMode = false});
     
     Widget build(BuildContext context) {
       return isTestMode
         ? _buildMockCamera()
         : _buildRealCamera();
     }
   }
   ```

### DON'T ❌

1. **Ne pas ignorer les erreurs**
   ```dart
   // ❌ Mauvais
   try {
     await tester.pumpAndSettle();
   } catch (e) {
     // Ignore timeout
   }
   ```

2. **Ne pas augmenter les timeouts à l'infini**
   ```dart
   // ❌ Mauvais
   await tester.pumpAndSettle(
     timeout: Duration(minutes: 5),  // Trop long!
   );
   ```

3. **Ne pas tester des implémentations internes**
   ```dart
   // ❌ Mauvais - teste l'implémentation caméra
   testWidgets('Camera implementation', ...);
   
   // ✅ Bon - teste l'UI visible
   testWidgets('Scanner UI layout', ...);
   ```

---

## 🎯 Résumé

Pour gérer les cas complexes dans les golden tests :

1. **Identifiez le problème** : Hardware, overflow, animation, service externe
2. **Choisissez la stratégie** : Mock, sections, injection, désactivation
3. **Documentez** : Expliquez pourquoi le test est différent
4. **Testez l'UI visible** : Pas les implémentations internes
5. **Gardez les tests simples** : Un test = une chose à vérifier

Les golden tests doivent vérifier **ce que l'utilisateur voit**, pas **comment ça marche en interne**.

---

## 📚 Exemples Complets

Voir les fichiers :
- `scanner_screen_mocked_golden_test.dart` - Mock caméra
- `login_screen_sections_golden_test.dart` - Test par sections
- `profile_screen_golden_test.dart` - Gestion animations

---

**Dernière mise à jour** : Octobre 2025

