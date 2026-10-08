// Зертханалық сабақ №3. Бірнеше экраны бар қосымша (Home / Profile / Settings).
import 'package:flutter/material.dart';

void main() {
  runApp(const MultiScreenApp());
}

class MultiScreenApp extends StatelessWidget {
  const MultiScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Screen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (_) => const HomePage(),
        ProfilePage.route: (_) => const ProfilePage(),
        SettingsPage.route: (_) => const SettingsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Home Page',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // Navigate To → Profile Page
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, ProfilePage.route),
              child: const Text('Profile бетіне өту'),
            ),
            const SizedBox(height: 12),
            // Navigate To → Settings Page
            FilledButton.tonal(
              onPressed: () => Navigator.pushNamed(context, SettingsPage.route),
              child: const Text('Settings бетіне өту'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const route = '/profile';

  @override
  Widget build(BuildContext context) {
    return _SimplePage(title: 'Profile', text: 'Бұл – Profile Page');
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    return _SimplePage(title: 'Settings', text: 'Бұл – Settings Page');
  }
}

class _SimplePage extends StatelessWidget {
  const _SimplePage({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),

            OutlinedButton(
              onPressed: () => Navigator.popUntil(
                context,
                ModalRoute.withName(HomePage.route),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
