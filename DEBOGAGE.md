# 🐛 Guide de Débogage CroqScan

## Problème : "Aucun produit trouvé" dans la recherche

### Étapes de Vérification

1. **Lancez l'app en mode debug**

```bash
flutter run
```

2. **Regardez les logs dans le terminal**

Vous devriez voir :

```
🔄 Chargement des produits...
📁 Chargement du fichier JSONL...
📄 Fichier chargé, parsing...
  ✓ Produit 1: [nom du produit] ([marque])
  ✓ Produit 2: [nom du produit] ([marque])
  ✓ Produit 3: [nom du produit] ([marque])
✅ Parsing terminé: XXXX produits parsés, YYYY ignorés
✅ XXXX produits chargés
📦 ProductsLoader: Fournit XXXX produits au provider
```

3. **Sur l'écran d'accueil**

   - Vérifiez le badge "X produits dans la base"
   - Si = 0, il y a un problème de chargement
   - Si > 0, le chargement a fonctionné

4. **Allez dans la recherche**
   - Vérifiez les logs :

```
🔍 SearchScreen: XXXX produits disponibles
```

---

## Solutions Possibles

### Si "0 produits dans la base"

**Le fichier ne se charge pas :**

1. Vérifiez que le fichier existe :

```bash
ls -lh assets/openpetfoodfacts-products.jsonl
```

2. Vérifiez qu'il est déclaré dans `pubspec.yaml` :

```yaml
assets:
  - assets/openpetfoodfacts-products.jsonl
```

3. Refaites un `flutter pub get` :

```bash
flutter clean
flutter pub get
flutter run
```

### Si l'app plante au démarrage

**Le fichier est trop gros :**

Option 1 : Réduire le nombre de produits

```bash
# Garder seulement les 1000 premières lignes
head -n 1000 assets/openpetfoodfacts-products.jsonl > assets/openpetfoodfacts-products-small.jsonl
```

Puis changez dans `pubspec.yaml` et `product_service.dart`

Option 2 : Augmenter le timeout
Dans `lib/services/product_service.dart`, ajoutez :

```dart
await Future.delayed(Duration.zero); // Force async
```

### Si les produits ne s'affichent pas dans la recherche

**Le provider ne transmet pas :**

Vérifiez les logs :

- Si vous voyez "📦 ProductsLoader: Fournit X produits"
- ET "🔍 SearchScreen: 0 produits disponibles"
- → Problème de provider

**Solution :**
Redémarrez l'app complètement (pas juste hot reload)

---

## 🧪 Test Manuel Rapide

### Ajoutez ce code temporaire dans search_screen.dart

Juste après `didChangeDependencies`, ajoutez :

```dart
print('DEBUG: _allProducts.length = ${_allProducts.length}');
print('DEBUG: _searchResults.length = ${_searchResults.length}');
print('DEBUG: provider = $provider');
if (provider != null) {
  print('DEBUG: provider.products.length = ${provider.products.length}');
}
```

Relancez et voyez les logs !

---

## 📊 Logs Attendus

### Séquence Normale

```
🔄 Chargement des produits...
📁 Chargement du fichier JSONL...
📄 Fichier chargé, parsing...
  ✓ Produit 1: Croquettes poulet, algues (Forza10Bio)
  ✓ Produit 2: Friskies Seafood Supreme (Purina)
  ✓ Produit 3: Hill's SciCroquettes (Hill's)
✅ Parsing terminé: 5000+ produits parsés, 8000+ ignorés
✅ 5000+ produits chargés
📦 ProductsLoader: Fournit 5000+ produits au provider
🔍 SearchScreen: 5000+ produits disponibles
```

**Note** : Beaucoup de produits sont ignorés car :

- Pas de nom
- Données incomplètes
- Format invalide
- C'est normal !

---

## 🔧 Si Ça Ne Marche Toujours Pas

### Option Alternative : Revenir aux Produits d'Exemple

Si le fichier JSONL cause des problèmes, vous pouvez temporairement revenir aux produits d'exemple :

1. Dans `lib/screens/search_screen.dart`, changez :

```dart
import '../data/sample_products.dart';

// Dans didChangeDependencies
_allProducts = SampleProducts.products;
_searchResults = _allProducts;
```

2. Dans `lib/screens/scanner_screen.dart` :

```dart
import '../data/sample_products.dart';

// Dans _onBarcodeDetected
final product = SampleProducts.findByBarcode(barcode);
```

Cela vous permet de continuer le développement pendant qu'on résout le problème de la vraie base.

---

## 💡 Prochaines Étapes de Debug

1. **Lancez l'app**
2. **Copiez tous les logs** du terminal
3. **Partagez-les** pour qu'on puisse diagnostiquer
4. **Vérifiez** le nombre de produits sur l'écran d'accueil

---

**Besoin d'aide ? Partagez les logs que vous voyez ! 🔍**
