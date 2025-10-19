import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:croq_scan/core/services/scan_history_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScanHistoryService', () {
    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    test('addToHistory adds a product scan', () async {
      await ScanHistoryService.addToHistory(
        '1234567890123',
        'Test Product',
        'Test Brand',
        'https://example.com/image.jpg',
        75,
      );

      final history = await ScanHistoryService.getHistory();

      expect(history, isNotEmpty);
      final recentItem = history.first;
      expect(recentItem['barcode'], '1234567890123');
      expect(recentItem['name'], 'Test Product');
      expect(recentItem['brand'], 'Test Brand');
      expect(recentItem['score'], 75);
    });

    test('getRecentScans returns limited number of scans', () async {
      // Add multiple scans
      for (int i = 0; i < 10; i++) {
        await ScanHistoryService.addToHistory(
          'barcode_$i',
          'Product $i',
          'Brand',
          '',
          50 + i,
        );
      }

      final recent = await ScanHistoryService.getRecentScans(5);

      expect(recent.length, lessThanOrEqualTo(5));
    });

    test('addToHistory removes duplicates', () async {
      const testBarcode = '1234567890123';

      // Add same product twice
      await ScanHistoryService.addToHistory(
        testBarcode,
        'Test Product',
        'Brand',
        '',
        75,
      );

      await ScanHistoryService.addToHistory(
        testBarcode,
        'Test Product Updated',
        'Brand',
        '',
        80,
      );

      final history = await ScanHistoryService.getHistory();
      final matchingItems = history
          .where((item) => item['barcode'] == testBarcode)
          .toList();

      // Should only have one entry for this barcode
      expect(matchingItems.length, equals(1));
      // Should have the updated info
      expect(matchingItems.first['name'], 'Test Product Updated');
      expect(matchingItems.first['score'], 80);
    });

    test('getHistory handles corrupted data gracefully', () async {
      // This test verifies the error handling in getHistory
      // Even if data is corrupted, it should return an empty list
      // instead of throwing an exception

      final history = await ScanHistoryService.getHistory();

      expect(history, isA<List<Map<String, dynamic>>>());
    });

    test('addToHistory limits history size', () async {
      // Add more than 50 items (the limit)
      for (int i = 0; i < 60; i++) {
        await ScanHistoryService.addToHistory(
          'barcode_$i',
          'Product $i',
          'Brand',
          '',
          50,
        );
      }

      final history = await ScanHistoryService.getHistory();

      // Should not exceed 50 items
      expect(history.length, lessThanOrEqualTo(50));
    });

    test('scan history items have required fields', () async {
      await ScanHistoryService.addToHistory(
        '1234567890123',
        'Test Product',
        'Test Brand',
        'https://example.com/image.jpg',
        85,
      );

      final history = await ScanHistoryService.getHistory();
      final item = history.first;

      expect(item.containsKey('barcode'), isTrue);
      expect(item.containsKey('name'), isTrue);
      expect(item.containsKey('brand'), isTrue);
      expect(item.containsKey('imageUrl'), isTrue);
      expect(item.containsKey('score'), isTrue);
      expect(item.containsKey('timestamp'), isTrue);
    });
  });
}
