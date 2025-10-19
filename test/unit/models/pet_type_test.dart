import 'package:flutter_test/flutter_test.dart';
import 'package:croq_scan/core/models/product.dart';

void main() {
  group('PetType Enum Tests', () {
    test('all pet types defined', () {
      expect(PetType.values.length, greaterThanOrEqualTo(4));
      expect(PetType.values, contains(PetType.dog));
      expect(PetType.values, contains(PetType.cat));
      expect(PetType.values, contains(PetType.bird));
      expect(PetType.values, contains(PetType.other));
    });

    test('pet type to string', () {
      expect(PetType.dog.toString(), contains('dog'));
      expect(PetType.cat.toString(), contains('cat'));
    });
  });
}
