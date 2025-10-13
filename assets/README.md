# 📁 Dossier Assets

Ce dossier contient les ressources statiques de l'application CroqScan.

## 📂 Structure

```
assets/
├── images/          # Images de l'application
│   └── (ajoutez vos images ici)
├── icons/           # Icônes personnalisées
│   └── (ajoutez vos icônes ici)
└── README.md        # Ce fichier
```

## 🖼️ Images (`images/`)

Placez ici toutes les images utilisées dans l'application :

- Logos
- Illustrations
- Arrière-plans
- Captures d'écran
- Photos de produits
- Etc.

### Formats Supportés

- PNG (recommandé pour la transparence)
- JPEG/JPG (pour les photos)
- WebP (pour l'optimisation)
- GIF (animations simples)

### Bonnes Pratiques

1. **Nommage** : Utilisez des noms descriptifs en snake_case

   - ✅ `logo_croqscan.png`
   - ✅ `fond_accueil.jpg`
   - ❌ `IMG_1234.png`

2. **Tailles Multiples** : Pour une meilleure qualité sur tous les appareils

   ```
   logo.png          # 1x (référence)
   logo@2x.png       # 2x (haute résolution)
   logo@3x.png       # 3x (très haute résolution)
   ```

3. **Optimisation** : Compressez vos images avant de les ajouter
   - Outils : TinyPNG, ImageOptim, Squoosh

## 🎨 Icônes (`icons/`)

Placez ici les icônes personnalisées :

- Icônes d'interface utilisateur
- Icônes de fonctionnalités
- Icônes de catégories d'animaux
- Icônes de types de produits
- Etc.

### Format Recommandé

- SVG (vectoriel, s'adapte à toutes les tailles)
- PNG avec transparence (plusieurs tailles)

### Tailles Communes

- 24x24 (petites icônes)
- 48x48 (icônes moyennes)
- 72x72 (grandes icônes)

## 📝 Utilisation dans le Code

### Afficher une Image

```dart
Image.asset('assets/images/logo.png')
```

### Avec Dimensions Spécifiques

```dart
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.contain,
)
```

### Image de Fond

```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/fond.jpg'),
      fit: BoxFit.cover,
    ),
  ),
)
```

## ⚠️ Important

1. **Déclaration** : Les assets doivent être déclarés dans `pubspec.yaml`

   ```yaml
   flutter:
     assets:
       - assets/images/
       - assets/icons/
   ```

2. **Sensibilité à la Casse** : Les chemins sont sensibles à la casse

   - ✅ `assets/images/Logo.png`
   - ❌ `assets/images/logo.png` (si le fichier s'appelle Logo.png)

3. **Hot Reload** : Après avoir ajouté des assets, faites un hot restart (R)

## 💡 Astuces

### Vérifier le Chargement d'une Image

```dart
Image.asset(
  'assets/images/logo.png',
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
  },
)
```

### Précharger une Image

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(AssetImage('assets/images/logo.png'), context);
}
```

### Image avec Cache

```dart
Image.asset(
  'assets/images/logo.png',
  cacheWidth: 100,  # Optimise la mémoire
  cacheHeight: 100,
)
```

## 📐 Tailles Recommandées

### Icônes d'Application

- **Android** : 192x192, 512x512
- **iOS** : Multiples tailles de 20x20 à 1024x1024

### Images d'Interface

- **Petites** : 48x48 à 128x128
- **Moyennes** : 256x256 à 512x512
- **Grandes** : 1024x1024+

### Arrière-plans

- **Mobile** : 1080x1920 (portrait)
- **Tablette** : 2048x2732
- **Adaptatif** : SVG ou très haute résolution

## 🐾 Suggestions pour CroqScan

### Images de Produits

- Photos de croquettes, pâtées, friandises
- Images d'animaux heureux et en santé
- Logos de marques (avec permission)
- Ingrédients naturels (viande, légumes, etc.)

### Icônes Personnalisées

- Icône scanner personnalisée
- Icônes pour différents types d'animaux
- Icônes pour scores de santé
- Icônes pour ingrédients (protéines, fibres, etc.)

## 🚀 Optimisation

### Checklist Avant d'Ajouter une Image

- [ ] Image compressée/optimisée
- [ ] Nom descriptif et clair
- [ ] Format approprié (PNG/JPEG/WebP)
- [ ] Taille raisonnable (< 500KB si possible)
- [ ] Versions multiples si nécessaire (@2x, @3x)

### Outils Recommandés

- **Compression** : TinyPNG, ImageOptim
- **Conversion** : CloudConvert, Convertio
- **Édition** : GIMP, Photoshop, Figma, Canva

---

**Note** : Ce dossier est surveillé par Git. N'ajoutez pas d'images trop lourdes ou de fichiers temporaires.
