import 'package:flutter_test/flutter_test.dart';
import 'package:lab11_unit_tests/calculator.dart';

void main() {
  group('Калькулятор', () {
    test('Қосу функциясын тексеру', () {
      expect(add(2, 3), 5);
    });

    test('Көбейту функциясын тексеру', () {
      expect(multiply(4, 5), 20);
    });

    test('Теріс сандарды қосу', () {
      expect(add(-2, -3), -5);
    });

    test('Нөлге көбейту', () {
      expect(multiply(7, 0), 0);
      expect(multiply(0, 0), 0);
    });

    test('Азайту', () {
      expect(subtract(10, 4), 6);
      expect(subtract(4, 10), -6);
    });

    test('Бөлу және нөлге бөлу қатесі', () {
      expect(divide(10, 4), 2.5);
      expect(() => divide(1, 0), throwsArgumentError);
    });
  });
}
