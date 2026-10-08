// Зертханалық сабақ №4. Пайдаланушы параметрлерін сақтау (логин / тақырып).
// App State: userName (String) және isDarkMode (bool) — барлық экранға ортақ,
// shared_preferences арқылы қосымша жабылғаннан кейін де сақталады.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App State — барлық қосымшаға ортақ айнымалылар.
class AppState extends ChangeNotifier {
  AppState(this._prefs)
      : _userName = _prefs.getString('userName') ?? '',
        _isDarkMode = _prefs.getBool('isDarkMode') ?? false;

  final SharedPreferences _prefs;
  String _userName;
  bool _isDarkMode;

  String get userName => _userName;
  bool get isDarkMode => _isDarkMode;

  // Set App State Variable: userName
  void setUserName(String value) {
    _userName = value;
    _prefs.setString('userName', value);
    notifyListeners();
  }

  // Set App State Variable: isDarkMode
  void setDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.state});
  static const route = '/';
  final AppState state;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.state.userName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    widget.state.setUserName(name); // TextField мәні → userName
    Navigator.pushReplacementNamed(context, '/menu'); // Navigate To → Меню
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              key: const Key('nameField'),
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Атыңызды енгізіңіз',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _login(),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _login, child: const Text('Кіру')),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.state});
  static const route = '/profile';
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Profile Page')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Қош келдіңіз, ${state.userName}!',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              FilledButton.tonal(
                onPressed: () => state.setDarkMode(!state.isDarkMode),
                child: Text(state.isDarkMode ? 'Light Mode қосу' : 'Dark Mode қосу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
