import 'package:flutter_test/flutter_test.dart';
import 'package:lab9_permissions/main.dart';

class _Denied implements MediaService {
  @override
  Future<String?> takePhoto() async => null;
  @override
  Future<String?> pickFromGallery() async => null;
}

void main() {
  testWidgets('Рұқсат берілмесе «Рұқсат берілмеді!» Snackbar шығады', (tester) async {
    await tester.pumpWidget(PermissionsApp(service: _Denied()));
    await tester.tap(find.text('Камераны ашу'));
    await tester.pump();
    expect(find.text('Рұқсат берілмеді!'), findsOneWidget);
  });

  testWidgets('Екі батырма да бар', (tester) async {
    await tester.pumpWidget(PermissionsApp(service: _Denied()));
    expect(find.text('Камераны ашу'), findsOneWidget);
    expect(find.text('Жадтан сурет таңдау'), findsOneWidget);
    expect(find.text('Сурет таңдалмаған'), findsOneWidget);
  });
}
