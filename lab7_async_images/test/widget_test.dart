import 'package:flutter_test/flutter_test.dart';
import 'package:lab7_async_images/main.dart';

void main() {
  testWidgets('Басты сурет + 9 суреттік GridView + жаңарту батырмасы', (tester) async {
    await tester.pumpWidget(const AsyncImageApp());
    // 1 үлкен сурет + торда көрінетін суреттер
    expect(find.byType(NetworkPhoto), findsAtLeastNWidgets(2));
    expect(find.text('Жаңа суреттер жүктеу'), findsOneWidget);

    String firstUrl() =>
        ((tester.widget(find.byType(NetworkPhoto).first)) as NetworkPhoto).url;
    final before = firstUrl();
    await tester.tap(find.text('Жаңа суреттер жүктеу'));
    await tester.pump();
    expect(firstUrl(), isNot(before));
  });
}
