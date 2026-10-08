// Зертханалық сабақ №12. APK/Bundle құрастыру, құрылғыда тексеру.
// Қосымша құрастыру режимін (Debug / Profile / Release) көрсетеді —
// release APK/AAB дұрыс құрастырылғанын құрылғыда тексеруге болады.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const BuildDemoApp());

/// Ағымдағы құрастыру режимі.
String buildMode() {
  if (kReleaseMode) return 'Release';
  if (kProfileMode) return 'Profile';
  return 'Debug';
}

class BuildDemoApp extends StatelessWidget {
  const BuildDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 12 APK Build',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const BuildInfoPage(),
    );
  }
}

class BuildInfoPage extends StatefulWidget {
  const BuildInfoPage({super.key});

  @override
  State<BuildInfoPage> createState() => _BuildInfoPageState();
}

class _BuildInfoPageState extends State<BuildInfoPage> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) {
    final mode = buildMode();
    final rows = <(String, String)>[
      ('Режим', mode),
      ('applicationId', 'kz.labs.lab12_apk_build'),
      ('Нұсқа', '1.0.0+1'),
      ('Платформа', defaultTargetPlatform.name),
      ('Assertions', kDebugMode ? 'қосулы' : 'өшірулі'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('APK / AAB Build')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: kReleaseMode ? Colors.green.shade100 : Colors.amber.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '$mode build',
                  key: const Key('modeText'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final (k, v) in rows)
              ListTile(dense: true, title: Text(k), trailing: Text(v)),
            const Spacer(),
            Center(child: Text('Басу саны: $_taps', style: const TextStyle(fontSize: 22))),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(() => _taps++),
              child: const Text('Тексеру (басыңыз)'),
            ),
          ],
        ),
      ),
    );
  }
}
