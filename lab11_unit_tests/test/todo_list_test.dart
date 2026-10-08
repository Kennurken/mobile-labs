import 'package:flutter_test/flutter_test.dart';
import 'package:lab11_unit_tests/todo_list.dart';

void main() {
  group('TodoList бизнес-логикасы', () {
    late TodoList list;
    setUp(() => list = TodoList()); // Arrange

    test('Элемент қосу тізімді ұлғайтады', () {
      list.add('Сабақ оқу'); // Act
      expect(list.items.length, 1); // Assert
      expect(list.items.first.title, 'Сабақ оқу');
    });

    test('Бос атау қабылданбайды', () {
      expect(() => list.add('   '), throwsArgumentError);
      expect(list.items, isEmpty);
    });

    test('toggle орындалмаған санын өзгертеді', () {
      list.add('A');
      list.add('B');
      expect(list.remaining, 2);
      list.toggle(0);
      expect(list.remaining, 1);
      list.toggle(0);
      expect(list.remaining, 2);
    });

    test('Жою', () {
      list.add('A');
      list.add('B');
      list.removeAt(0);
      expect(list.items.single.title, 'B');
    });
  });
}
