import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_profiling/main.dart';

void main() {
  testWidgets('Тізім lazy: бастапқыда тек көрінетін элементтер салынады', (tester) async {
    await tester.pumpWidget(const ProfileDemoApp());
    expect(find.text('Элемент №1'), findsOneWidget);
    expect(find.text('Элемент №100'), findsNothing); // әлі салынбаған
    expect(find.byType(ListTile).evaluate().length, lessThan(itemCount));
  });

  testWidgets('Оңтайландыру қосқышы тақырыпты ауыстырады', (tester) async {
    await tester.pumpWidget(const ProfileDemoApp());
    expect(find.text('Профиль: баяу'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.text('Профиль: оңтайлы'), findsOneWidget);
  });
}
