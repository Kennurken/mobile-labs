import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:lab14_push_fcm/main.dart';

class _Fake implements PushService {
  _Fake({this.fail = false});
  final bool fail;

  @override
  Future<String?> init() async {
    if (fail) throw Exception('no firebase');
    return 'fake-token-123';
  }

  @override
  Stream<RemoteMessage> get onMessage => const Stream.empty();
}

void main() {
  testWidgets('FCM токені экранға шығады', (tester) async {
    await tester.pumpWidget(PushApp(service: _Fake()));
    await tester.pumpAndSettle();
    expect(find.textContaining('fake-token-123'), findsOneWidget);
    expect(find.text('Әзірге жоқ'), findsOneWidget);
  });

  testWidgets('Firebase бапталмаса түсіндірме көрсетіледі', (tester) async {
    await tester.pumpWidget(PushApp(service: _Fake(fail: true)));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('errorText')), findsOneWidget);
    expect(find.textContaining('google-services.json'), findsOneWidget);
  });
}
