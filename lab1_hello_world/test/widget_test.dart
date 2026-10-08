import 'package:flutter_test/flutter_test.dart';
import 'package:lab1_hello_world/main.dart';

void main() {
  testWidgets('shows Hello, World!', (tester) async {
    await tester.pumpWidget(const HelloWorldApp());
    expect(find.text('Hello, World!'), findsOneWidget);
  });
}
