import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/utils/error_handler.dart';

void main() {
  group('ErrorHandler Tests', () {
    test('logger is initialized', () {
      expect(logger, isNotNull);
    });

    test('logInfo works', () {
      expect(() => logInfo('Test info'), returnsNormally);
    });

    test('logWarning works', () {
      expect(() => logWarning('Test warning'), returnsNormally);
    });

    test('logDebug works', () {
      expect(() => logDebug('Test debug'), returnsNormally);
    });

    test('logError works', () {
      expect(() => logError('Test error', Exception('test')), returnsNormally);
    });

    test('initializeErrorHandlers works', () {
      expect(() => initializeErrorHandlers(), returnsNormally);
    });
  });
}
