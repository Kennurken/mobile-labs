import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab2_data_input/main.dart';

void main() {
  testWidgets('button shows entered name', (tester) async {
    await tester.pumpWidget(const DataInputApp());
    await tester.enterText(find.byType(TextField), 'Елдос');
    await tester.tap(find.text('Көрсету'));
    await tester.pump();
    expect(find.text('Елдос'), findsNWidgets(2));
  });
}
