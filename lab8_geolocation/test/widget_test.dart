import 'package:flutter_test/flutter_test.dart';
import 'package:lab8_geolocation/main.dart';

class _Fake implements LocationService {
  _Fake({this.fail = false});
  final bool fail;

  @override
  Future<({double latitude, double longitude})> getCurrent() async {
    if (fail) throw 'Рұқсат берілмеді!';
    return (latitude: 51.1605, longitude: 71.4704); // Астана
  }
}

void main() {
  testWidgets('Батырма координаттарды Text-ке шығарады', (tester) async {
    await tester.pumpWidget(GeoApp(service: _Fake()));
    expect(find.text('Latitude: —'), findsOneWidget);
    await tester.tap(find.text('Координаттарды алу'));
    await tester.pumpAndSettle();
    expect(find.text('Latitude: 51.160500'), findsOneWidget);
    expect(find.text('Longitude: 71.470400'), findsOneWidget);
  });

  testWidgets('Рұқсат берілмесе қате хабарламасы шығады', (tester) async {
    await tester.pumpWidget(GeoApp(service: _Fake(fail: true)));
    await tester.tap(find.text('Координаттарды алу'));
    await tester.pumpAndSettle();
    expect(find.text('Рұқсат берілмеді!'), findsOneWidget);
  });
}
