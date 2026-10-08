import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab13_counter_app/main.dart';

void main() {
  testWidgets('Counter: екі батырма да санды арттырады', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Flutter Demo'), findsOneWidget);
    expect(find.text('Сәлем, Flutter!'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Басыңыз'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });
}
