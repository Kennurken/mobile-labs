import 'package:flutter/widgets.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_user_settings/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Login -> Profile көрсетеді, Dark Mode ауысады және сақталады',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final state = AppState(prefs);

    await tester.pumpWidget(UserSettingsApp(state: state));
    await tester.enterText(find.byKey(const Key('nameField')), 'Eldos');
    await tester.tap(find.text('Кіру'));
    await tester.pumpAndSettle();
    expect(find.text('Қош келдіңіз, Eldos!'), findsOneWidget);

    await tester.tap(find.text('Dark Mode қосу'));
    await tester.pumpAndSettle();
    expect(state.isDarkMode, isTrue);
    expect(prefs.getBool('isDarkMode'), isTrue);
    expect(prefs.getString('userName'), 'Eldos');
  });
}
