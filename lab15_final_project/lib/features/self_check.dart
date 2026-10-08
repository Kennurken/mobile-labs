// Финалдық тексеріс: қосымшаның барлық функцияларын автоматты түрде тексереді
// (логин, CRUD, API, геолокация, камера/жад рұқсаттары, push, құрастыру режимі).
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'api.dart';
import 'login_profile.dart';
import 'todo.dart';

enum CheckStatus { ok, warn, fail }

class CheckResult {
  const CheckResult(this.title, this.status, this.detail);
  final String title;
  final CheckStatus status;
  final String detail;
}

/// Барлық тексерулерді орындайды (тестте тәуелділіктерді ауыстыруға болады).
class SelfCheck {
  SelfCheck({required this.state, required this.repo, CatFactsApi? api})
      : api = api ?? CatFactsApi();

  final AppState state;
  final TaskRepository repo;
  final CatFactsApi api;

  Future<CheckResult> _guard(String title, Future<CheckResult> Function() body) async {
    try {
      return await body().timeout(const Duration(seconds: 12));
    } catch (e) {
      return CheckResult(title, CheckStatus.fail, '$e');
    }
  }

  Future<List<CheckResult>> run() async => [
        await login(),
        await crud(),
        await network(),
        await location(),
        await camera(),
        await storage(),
        await push(),
        buildInfo(),
      ];

  Future<CheckResult> login() => _guard('Логин / параметрлер', () async {
        final ok = state.userName.isNotEmpty;
        return CheckResult(
          'Логин / параметрлер',
          ok ? CheckStatus.ok : CheckStatus.warn,
          ok
              ? 'Пайдаланушы: ${state.userName}, тақырып: ${state.isDarkMode ? 'dark' : 'light'}'
              : 'Логин енгізілмеген',
        );
      });

  Future<CheckResult> crud() => _guard('CRUD (ToDo)', () async {
        final before = repo.tasks.length;
        await repo.create('__self_check__'); // Create
        final created = repo.tasks.last;
        await repo.toggle(created.id); // Update
        final updated = repo.tasks.last.isDone;
        await repo.delete(created.id); // Delete
        final restored = repo.tasks.length == before;
        final ok = created.title == '__self_check__' && updated && restored;
        return CheckResult('CRUD (ToDo)', ok ? CheckStatus.ok : CheckStatus.fail,
            ok ? 'Create → Update → Delete орындалды ($before тапсырма сақталды)' : 'CRUD қатесі');
      });

  Future<CheckResult> network() => _guard('Желі және API', () async {
        final sw = Stopwatch()..start();
        final fact = await api.fetchFact();
        return CheckResult('Желі және API', CheckStatus.ok,
            'catfact.ninja жауап берді: ${sw.elapsedMilliseconds} мс, length=${fact.length}');
      });

  Future<CheckResult> location() => _guard('Геолокация', () async {
        final enabled = await Geolocator.isLocationServiceEnabled();
        final perm = await Geolocator.checkPermission();
        final granted = perm == LocationPermission.always || perm == LocationPermission.whileInUse;
        return CheckResult(
          'Геолокация',
          granted && enabled ? CheckStatus.ok : CheckStatus.warn,
          'GPS: ${enabled ? 'қосулы' : 'өшірулі'}, рұқсат: ${perm.name}',
        );
      });

  Future<CheckResult> camera() => _guard('Камера рұқсаты', () async {
        final s = await Permission.camera.status;
        return CheckResult('Камера рұқсаты', s.isGranted ? CheckStatus.ok : CheckStatus.warn, s.name);
      });

  Future<CheckResult> storage() => _guard('Жад / галерея рұқсаты', () async {
        final s = await Permission.photos.status;
        return CheckResult('Жад / галерея рұқсаты',
            s.isGranted || s.isLimited ? CheckStatus.ok : CheckStatus.warn, s.name);
      });

  Future<CheckResult> push() => _guard('Push (Firebase)', () async {
        var ok = Firebase.apps.isNotEmpty;
        if (!ok) {
          try {
            await Firebase.initializeApp();
            ok = true;
          } catch (_) {
            ok = false;
          }
        }
        return CheckResult('Push (Firebase)', ok ? CheckStatus.ok : CheckStatus.warn,
            ok ? 'Firebase іске қосылған' : 'google-services.json қосылмаған — Push беті токенді көрсетпейді');
      });

  CheckResult buildInfo() {
    final mode = kReleaseMode ? 'Release' : (kProfileMode ? 'Profile' : 'Debug');
    return CheckResult('Құрастыру режимі', kReleaseMode ? CheckStatus.ok : CheckStatus.warn,
        '$mode build (жариялауға Release қажет)');
  }
}

class SelfCheckPage extends StatefulWidget {
  const SelfCheckPage({super.key, required this.check});
  final SelfCheck check;

  @override
  State<SelfCheckPage> createState() => _SelfCheckPageState();
}

class _SelfCheckPageState extends State<SelfCheckPage> {
  List<CheckResult>? _results;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() => _running = true);
    final r = await widget.check.run();
    if (mounted) {
      setState(() {
        _results = r;
        _running = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    final okCount = results?.where((r) => r.status == CheckStatus.ok).length ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Финалдық тексеріс')),
      body: results == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Өтті: $okCount / ${results.length}',
                      key: const Key('summary'),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                for (final r in results)
                  ListTile(
                    leading: switch (r.status) {
                      CheckStatus.ok => const Icon(Icons.check_circle, color: Colors.green),
                      CheckStatus.warn => const Icon(Icons.warning_amber, color: Colors.orange),
                      CheckStatus.fail => const Icon(Icons.error, color: Colors.red),
                    },
                    title: Text(r.title),
                    subtitle: Text(r.detail),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _running ? null : _run,
        icon: const Icon(Icons.refresh),
        label: const Text('Қайта тексеру'),
      ),
    );
  }
}
