import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ScanHistoryItem {
  final Product product;
  final DateTime scannedAt;

  ScanHistoryItem({required this.product, required this.scannedAt});

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'scannedAt': scannedAt.toIso8601String(),
  };

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      product: Product.fromJson(json['product']),
      scannedAt: DateTime.parse(json['scannedAt']),
    );
  }
}

class ScanHistoryService {
  static const String _historyKey = 'scan_history';
  static const int _maxHistoryItems = 50;

  /// Ajouter un produit à l'historique
  static Future<void> addToHistory(Product product) async {
    print('📝 Ajout à l\'historique: ${product.name}');

    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // Supprimer les doublons (même produit)
    history.removeWhere((item) => item.product.barcode == product.barcode);

    // Ajouter le nouveau scan au début
    history.insert(
      0,
      ScanHistoryItem(product: product, scannedAt: DateTime.now()),
    );

    // Limiter le nombre d'items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    // Sauvegarder
    final jsonList = history.map((item) => item.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));

    print('✅ Historique sauvegardé: ${history.length} items');
  }

  /// Récupérer l'historique
  static Future<List<ScanHistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ScanHistoryItem.fromJson(json)).toList();
    } catch (e) {
      print('❌ Erreur lors du chargement de l\'historique: $e');
      return [];
    }
  }

  /// Effacer tout l'historique
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    print('🗑️  Historique effacé');
  }

  /// Supprimer un item spécifique
  static Future<void> removeItem(String barcode) async {
    final history = await getHistory();
    history.removeWhere((item) => item.product.barcode == barcode);

    final prefs = await SharedPreferences.getInstance();
    final jsonList = history.map((item) => item.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));

    print('🗑️  Item supprimé de l\'historique');
  }
}

