// Зертханалық сабақ №14. Push-хабарлама жіберу (Firebase Cloud Messaging).
// 1) Firebase жобасын құрып, google-services.json файлын android/app/ қалтасына қойыңыз.
// 2) Қосымша ашылғанда FCM токені экранға шығады; Firebase Console → Cloud Messaging
//    арқылы хабарлама жіберіңіз. Ашық кезде — экранда, жабық кезде — notification панелінде.
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Фондық хабарлама: ${message.messageId}');
}

/// Push қызметі (тестте ауыстыруға болады).
abstract class PushService {
  /// Firebase іске қосылды ма — қате болса түсіндірме мәтінін лақтырады.
  Future<String?> init();
  Stream<RemoteMessage> get onMessage;
}

class FcmPushService implements PushService {
  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Future<String?> init() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(); // Android 13+: POST_NOTIFICATIONS
    return messaging.getToken();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PushApp(service: FcmPushService()));
}

class PushApp extends StatelessWidget {
  const PushApp({super.key, required this.service});
  final PushService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notifications Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: HomePage(service: service),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.service});
  final PushService service;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _token;
  String? _error;
  final List<String> _messages = [];
  StreamSubscription<RemoteMessage>? _sub;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    try {
      final token = await widget.service.init();
      debugPrint('FCM Token: $token');
      _sub = widget.service.onMessage.listen((m) {
        debugPrint('Қосымша ашық кезде хабарлама келді: ${m.notification?.title}');
        if (mounted) {
          setState(() => _messages.insert(
              0, '${m.notification?.title ?? '(тақырыпсыз)'}: ${m.notification?.body ?? ''}'));
        }
      });
      if (mounted) setState(() => _token = token);
    } catch (e) {
      if (mounted) {
        final reason = e.toString().split('\n').first;
        setState(() => _error = 'Firebase бапталмаған.\n'
            'Firebase Console-дан google-services.json жүктеп, android/app/ қалтасына қойыңыз '
            'да, қосымшаны қайта құрастырыңыз.\n\nСебебі: $reason');
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Push Notification Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _error != null
                    ? Text(_error!, key: const Key('errorText'))
                    : Text('FCM Token:\n${_token ?? 'алынуда…'}', key: const Key('tokenText')),
              ),
            ),
            if (_token != null)
              TextButton.icon(
                onPressed: () => Clipboard.setData(ClipboardData(text: _token!)),
                icon: const Icon(Icons.copy),
                label: const Text('Токенді көшіру'),
              ),
            const Divider(),
            const Text('Келген хабарламалар:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text('Әзірге жоқ'))
                  : ListView(children: [for (final m in _messages) ListTile(title: Text(m))]),
            ),
          ],
        ),
      ),
    );
  }
}
