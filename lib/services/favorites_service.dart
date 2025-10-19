import 'package:shared_preferences/shared_preferences.dart';

/// Service de gestion des favoris
class FavoritesService {
  static const String _favoritesKey = 'favorites_barcodes';

  /// Récupérer tous les favoris
  static Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.toSet();
  }

  /// Ajouter un produit aux favoris
  static Future<void> addFavorite(String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.add(barcode);
    final success = await prefs.setStringList(
      _favoritesKey,
      favorites.toList(),
    );
    print(
      '💾 DEBUG: Ajout favori $barcode - Success: $success - Total: ${favorites.length}',
    );
  }

  /// Retirer un produit des favoris
  static Future<void> removeFavorite(String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(barcode);
    final success = await prefs.setStringList(
      _favoritesKey,
      favorites.toList(),
    );
    print(
      '🗑️ DEBUG: Retrait favori $barcode - Success: $success - Total: ${favorites.length}',
    );
  }

  /// Vérifier si un produit est en favoris
  static Future<bool> isFavorite(String barcode) async {
    final favorites = await getFavorites();
    final result = favorites.contains(barcode);
    print('❓ DEBUG: isFavorite($barcode) = $result');
    return result;
  }

  /// Basculer l'état favori d'un produit
  static Future<bool> toggleFavorite(String barcode) async {
    print('🔄 DEBUG: Toggle favori pour $barcode');
    final isFav = await isFavorite(barcode);
    if (isFav) {
      await removeFavorite(barcode);
      return false;
    } else {
      await addFavorite(barcode);
      return true;
    }
  }
}
