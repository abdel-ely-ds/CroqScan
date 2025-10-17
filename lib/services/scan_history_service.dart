import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service de gestion de l'historique des scans
class ScanHistoryService {
  static const String _historyKey = 'scan_history';
  static const int _maxHistorySize = 20;

  /// Ajouter un produit à l'historique
  static Future<void> addToHistory(
    String barcode,
    String name,
    String brand,
    String imageUrl,
    int score,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // Créer l'entrée
    final entry = {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'score': score,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    // Retirer les doublons (même barcode)
    history.removeWhere((item) => item['barcode'] == barcode);

    // Ajouter en premier
    history.insert(0, entry);

    // Limiter la taille
    if (history.length > _maxHistorySize) {
      history.removeRange(_maxHistorySize, history.length);
    }

    // Sauvegarder
    final jsonList = history.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_historyKey, jsonList);

    print('📝 Ajouté à l\'historique: $name ($barcode)');
  }

  /// Récupérer l'historique complet
  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Vérifier et nettoyer si les données sont corrompues
      final existingData = prefs.get(_historyKey);
      if (existingData != null && existingData is! List<String>) {
        print('⚠️ Données corrompues détectées, nettoyage...');
        await prefs.remove(_historyKey);
        return [];
      }

      final jsonList = prefs.getStringList(_historyKey) ?? [];

      return jsonList
          .map((jsonStr) {
            try {
              return jsonDecode(jsonStr) as Map<String, dynamic>;
            } catch (e) {
              print('❌ Erreur parsing JSON: $e');
              return <String, dynamic>{};
            }
          })
          .where((item) => item.isNotEmpty)
          .toList();
    } catch (e) {
      print('❌ Erreur chargement historique: $e');
      // En cas d'erreur, nettoyer et retourner vide
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      return [];
    }
  }

  /// Récupérer les N derniers produits scannés
  static Future<List<Map<String, dynamic>>> getRecentScans([
    int count = 5,
  ]) async {
    final history = await getHistory();
    return history.take(count).toList();
  }

  /// Effacer l'historique
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    print('🗑️ Historique effacé');
  }
}
