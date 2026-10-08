import 'package:flutter/widgets.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:lab12_apk_build/main.dart';

void main() {
  testWidgets('Режим көрсетіледі, батырма санауышты арттырады', (tester) async {
    await tester.pumpWidget(const BuildDemoApp());
    expect(find.byKey(const Key('modeText')), findsOneWidget);
    expect(find.text('Debug build'), findsOneWidget); // тест — debug режимінде
    expect(find.text('Басу саны: 0'), findsOneWidget);
    await tester.tap(find.text('Тексеру (басыңыз)'));
    await tester.pump();
    expect(find.text('Басу саны: 1'), findsOneWidget);
  });
}
