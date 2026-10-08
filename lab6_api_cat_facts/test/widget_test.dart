import 'package:flutter/widgets.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab6_api_cat_facts/main.dart';

void main() {
  testWidgets('Батырма API-ді шақырады, fact экранға шығады', (tester) async {
    var n = 0;
    final client = MockClient((req) async {
      n++;
      return http.Response('{"fact":"Cat fact #$n","length":12}', 200);
    });
    await tester.pumpWidget(ApiDemoApp(api: CatFactsApi(client)));

    await tester.tap(find.text('Жаңа факт алу'));
    await tester.pumpAndSettle();
    expect(find.text('Cat fact #1'), findsWidgets);

    await tester.tap(find.text('Жаңа факт алу'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('factText')), findsOneWidget);
    expect(find.text('Cat fact #2'), findsWidgets);
  });

  test('CatFact.fromJson', () {
    final f = CatFact.fromJson({'fact': 'Cats sleep 70% of their lives.', 'length': 34});
    expect(f.length, 34);
  });

  test('RandomUser.fromJson', () {
    final u = RandomUser.fromJson({
      'results': [
        {
          'name': {'first': 'Aigerim', 'last': 'Sadykova'},
          'email': 'a@b.kz',
          'location': {'country': 'Kazakhstan'},
        }
      ]
    });
    expect(u.name, 'Aigerim Sadykova');
    expect(u.country, 'Kazakhstan');
  });
}
