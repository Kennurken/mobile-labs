// Зертханалық сабақ №15. Жобаның финалдық тексерісі.
// Қосымша 4–9 және 14-зертханалардың функционалын біріктіреді:
// логин/тақырып, ToDo (CRUD), API, суреттер, геолокация, камера/жад, push + өзін-өзі тексеру.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/api.dart';
import 'features/images.dart';
import 'features/location.dart';
import 'features/login_profile.dart';
import 'features/media.dart';
import 'features/push.dart';
import 'features/self_check.dart';
import 'features/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(FinalApp(state: AppState(prefs), repo: TaskRepository(prefs)));
}

class FinalApp extends StatelessWidget {
  const FinalApp({super.key, required this.state, required this.repo, this.api});
  final AppState state;
  final TaskRepository repo;
  final CatFactsApi? api;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => MaterialApp(
        title: 'Final Project',
        debugShowCheckedModeBanner: false,
        themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        // Логин бұрын енгізілген болса — тікелей мәзірге
        initialRoute: state.userName.isEmpty ? LoginPage.route : MenuPage.route,
        routes: {
          LoginPage.route: (_) => LoginPage(state: state),
          MenuPage.route: (_) => MenuPage(state: state, repo: repo, api: api),
          ProfilePage.route: (_) => ProfilePage(state: state),
        },
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key, required this.state, required this.repo, this.api});
  static const route = '/menu';
  final AppState state;
  final TaskRepository repo;
  final CatFactsApi? api;

  void _open(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, VoidCallback)>[
      (Icons.person, 'Профиль', 'Логин және Dark Mode (4-лаб)',
          () => Navigator.pushNamed(context, ProfilePage.route)),
      (Icons.checklist, 'ToDo', 'CRUD операциялары (5-лаб)',
          () => _open(context, TaskListPage(repo: repo))),
      (Icons.cloud_download, 'API', 'Cat Facts, Random User (6-лаб)',
          () => _open(context, CatFactPage(api: api ?? CatFactsApi()))),
      (Icons.image, 'Суреттер', 'Асинхронды жүктеу (7-лаб)', () => _open(context, const ImagePage())),
      (Icons.location_on, 'Геолокация', 'Координаттар (8-лаб)',
          () => _open(context, LocationPage(service: DeviceLocationService()))),
      (Icons.photo_camera, 'Камера / жад', 'Рұқсаттар (9-лаб)',
          () => _open(context, PermissionsPage(service: DeviceMediaService()))),
      (Icons.notifications, 'Push', 'Firebase Cloud Messaging (14-лаб)',
          () => _open(context, PushPage(service: FcmPushService()))),
      (Icons.fact_check, 'Финалдық тексеріс', 'Барлық функцияларды автотексеру (15-лаб)',
          () => _open(context, SelfCheckPage(check: SelfCheck(state: state, repo: repo, api: api)))),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Сәлем, ${state.userName}!')),
      body: ListView(
        children: [
          for (final (icon, title, subtitle, onTap) in items)
            ListTile(
              leading: Icon(icon),
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}
