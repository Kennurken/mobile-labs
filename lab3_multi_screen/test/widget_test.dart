import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_multi_screen/main.dart';

void main() {
  testWidgets('Home -> Profile -> Home -> Settings -> Home', (tester) async {
    await tester.pumpWidget(const MultiScreenApp());
    await tester.tap(find.text('Profile бетіне өту'));
    await tester.pumpAndSettle();
    expect(find.text('Бұл – Profile Page'), findsOneWidget);
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();
    expect(find.text('Home Page'), findsOneWidget);
    await tester.tap(find.text('Settings бетіне өту'));
    await tester.pumpAndSettle();
    expect(find.text('Бұл – Settings Page'), findsOneWidget);
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();
    expect(find.text('Home Page'), findsOneWidget);
  });
}
