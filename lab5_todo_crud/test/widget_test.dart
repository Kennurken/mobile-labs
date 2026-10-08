import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5_todo_crud/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('CRUD: қосу, орындалды деп белгілеу, өзгерту, жою', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = TaskRepository(await SharedPreferences.getInstance());
    await tester.pumpWidget(TodoApp(repo: repo));

    // Create
    await tester.enterText(find.byKey(const Key('taskField')), 'Сабаққа дайындалу');
    await tester.tap(find.text('Add Task'));
    await tester.pump();
    expect(find.text('Сабаққа дайындалу'), findsOneWidget);

    // Update (isDone)
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(repo.tasks.single.isDone, isTrue);

    // Update (title)
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('editField')), 'Лабораторияны тапсыру');
    await tester.tap(find.text('Сақтау'));
    await tester.pumpAndSettle();
    expect(find.text('Лабораторияны тапсыру'), findsOneWidget);

    // Delete
    await tester.tap(find.byTooltip('Delete'));
    await tester.pump();
    expect(repo.tasks, isEmpty);
    expect(find.text('Тапсырмалар жоқ'), findsOneWidget);
  });

  test('Тапсырмалар сақталады (қайта ашқанда оқылады)', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await TaskRepository(prefs).create('A');
    expect(TaskRepository(prefs).tasks.single.title, 'A');
  });
}
