import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/services/favorites_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesService', () {
    setUp(() async {
      // Clear favorites before each test
      final favorites = await FavoritesService.getFavorites();
      for (final barcode in favorites) {
        await FavoritesService.removeFavorite(barcode);
      }
    });

    test('addFavorite adds a product to favorites', () async {
      const testBarcode = '1234567890123';
      
      await FavoritesService.addFavorite(testBarcode);
      
      final favorites = await FavoritesService.getFavorites();
      expect(favorites, contains(testBarcode));
    });

    test('removeFavorite removes a product from favorites', () async {
      const testBarcode = '1234567890123';
      
      // First add it
      await FavoritesService.addFavorite(testBarcode);
      expect(await FavoritesService.isFavorite(testBarcode), isTrue);
      
      // Then remove it
      await FavoritesService.removeFavorite(testBarcode);
      expect(await FavoritesService.isFavorite(testBarcode), isFalse);
    });

    test('isFavorite returns correct status', () async {
      const testBarcode = '1234567890123';
      
      // Initially should not be favorite
      expect(await FavoritesService.isFavorite(testBarcode), isFalse);
      
      // After adding, should be favorite
      await FavoritesService.addFavorite(testBarcode);
      expect(await FavoritesService.isFavorite(testBarcode), isTrue);
    });

    test('toggleFavorite switches favorite status', () async {
      const testBarcode = '1234567890123';
      
      // Toggle on
      final status1 = await FavoritesService.toggleFavorite(testBarcode);
      expect(status1, isTrue);
      expect(await FavoritesService.isFavorite(testBarcode), isTrue);
      
      // Toggle off
      final status2 = await FavoritesService.toggleFavorite(testBarcode);
      expect(status2, isFalse);
      expect(await FavoritesService.isFavorite(testBarcode), isFalse);
    });

    test('getFavorites returns all favorite barcodes', () async {
      const testBarcodes = ['111', '222', '333'];
      
      for (final barcode in testBarcodes) {
        await FavoritesService.addFavorite(barcode);
      }
      
      final favorites = await FavoritesService.getFavorites();
      
      expect(favorites.length, greaterThanOrEqualTo(testBarcodes.length));
      for (final barcode in testBarcodes) {
        expect(favorites, contains(barcode));
      }
    });

    test('addFavorite prevents duplicates', () async {
      const testBarcode = '1234567890123';
      
      await FavoritesService.addFavorite(testBarcode);
      await FavoritesService.addFavorite(testBarcode); // Add again
      
      final favorites = await FavoritesService.getFavorites();
      final count = favorites.where((b) => b == testBarcode).length;
      
      expect(count, equals(1)); // Should only appear once
    });
  });
}

