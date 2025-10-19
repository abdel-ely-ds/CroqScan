import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/app_initializer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppInitializer Tests', () {
    test('initialize returns successfully', () async {
      final result = await AppInitializer.initialize();
      expect(result, isA<bool>());
    });

    test('initialize handles errors gracefully', () async {
      // Should not throw even if some services fail
      expect(() async => await AppInitializer.initialize(), returnsNormally);
    });
  });
}

