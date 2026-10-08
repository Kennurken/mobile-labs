import 'package:flutter/widgets.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab15_final_project/features/api.dart';
import 'package:lab15_final_project/features/login_profile.dart';
import 'package:lab15_final_project/features/self_check.dart';
import 'package:lab15_final_project/features/todo.dart';
import 'package:lab15_final_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('Логин → мәзір → ToDo → кері', (tester) async {
    final app = FinalApp(state: AppState(prefs), repo: TaskRepository(prefs));
    await tester.pumpWidget(app);
    await tester.enterText(find.byKey(const Key('nameField')), 'Eldos');
    await tester.tap(find.text('Кіру'));
    await tester.pumpAndSettle();
    expect(find.text('Сәлем, Eldos!'), findsOneWidget);
    expect(find.text('Финалдық тексеріс'), findsOneWidget);

    await tester.tap(find.text('ToDo'));
    await tester.pumpAndSettle();
    expect(find.text('Task List Page'), findsOneWidget);
  });

  test('Өзін-өзі тексеру: логин, CRUD және API өтеді', () async {
    final state = AppState(prefs)..setUserName('Eldos');
    final repo = TaskRepository(prefs);
    await repo.create('сақталатын тапсырма');
    final client = MockClient((_) async => http.Response('{"fact":"x","length":1}', 200));
    final check = SelfCheck(state: state, repo: repo, api: CatFactsApi(client));

    expect((await check.login()).status, CheckStatus.ok);
    final crud = await check.crud();
    expect(crud.status, CheckStatus.ok);
    expect(repo.tasks.length, 1); // CRUD тексеруі тапсырмаларды бұзбады
    expect((await check.network()).status, CheckStatus.ok);
  });
}
