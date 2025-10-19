import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/services/scan_history_service.dart';
import 'package:croq_scan/core/services/profile_service.dart';

/// Tests de logique pour HomeScreen
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen Logic Tests', () {
    test('ScanHistoryService can load recent scans', () async {
      final scans = await ScanHistoryService.getRecentScans(5);
      expect(scans, isA<List>());
    });

    test('ProfileService can load profile', () async {
      final profile = await ProfileService.loadProfile();
      expect(profile, isA<AnimalProfile?>());
    });

    test('home screen data loads correctly', () async {
      final scans = await ScanHistoryService.getRecentScans(5);
      final profile = await ProfileService.loadProfile();
      
      // Data should load without errors
      expect(scans, isNotNull);
      expect(profile, isA<AnimalProfile?>());
    });
  });
}

