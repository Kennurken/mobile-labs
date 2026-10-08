import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11_unit_tests/main.dart';

void main() {
  testWidgets('Калькулятор экраны: 4 × 5 = 20, нөлге бөлу хабарламасы', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('×'));
    await tester.pump();
    expect(find.text('Нәтиже: 20'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, '0');
    await tester.tap(find.text('÷'));
    await tester.pump();
    expect(find.text('Нәтиже: Нөлге бөлуге болмайды'), findsOneWidget);
  });
}
