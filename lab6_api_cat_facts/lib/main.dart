// Зертханалық сабақ №6. Ашық API-ден деректерді алу қосымшасы.
// CatFacts: GET https://catfact.ninja/fact -> {"fact": "...", "length": 34}
// Қосымша: Random User API (https://randomuser.me/api/) және факттар тізімі.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// API жауабы: fact (String), length (Number).
class CatFact {
  const CatFact({required this.fact, required this.length});
  final String fact;
  final int length;

  factory CatFact.fromJson(Map<String, dynamic> json) =>
      CatFact(fact: json['fact'] as String, length: json['length'] as int);
}

class RandomUser {
  const RandomUser({required this.name, required this.email, required this.country});
  final String name;
  final String email;
  final String country;

  factory RandomUser.fromJson(Map<String, dynamic> json) {
    final r = (json['results'] as List).first as Map<String, dynamic>;
    final n = r['name'] as Map<String, dynamic>;
    return RandomUser(
      name: '${n['first']} ${n['last']}',
      email: r['email'] as String,
      country: (r['location'] as Map<String, dynamic>)['country'] as String,
    );
  }
}

/// Call API: CatFacts (GET). Клиент сыртқа шығарылған — тестте ауыстыруға болады.
class CatFactsApi {
  CatFactsApi([http.Client? client]) : _client = client ?? http.Client();
  final http.Client _client;

  Future<CatFact> fetchFact() async {
    final res = await _client.get(Uri.parse('https://catfact.ninja/fact'));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    return CatFact.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<RandomUser> fetchUser() async {
    final res = await _client.get(Uri.parse('https://randomuser.me/api/'));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    return RandomUser.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}

void main() => runApp(ApiDemoApp(api: CatFactsApi()));

class ApiDemoApp extends StatelessWidget {
  const ApiDemoApp({super.key, required this.api});
  final CatFactsApi api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Demo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: CatFactPage(api: api),
    );
  }
}

class CatFactPage extends StatefulWidget {
  const CatFactPage({super.key, required this.api});
  final CatFactsApi api;

  @override
  State<CatFactPage> createState() => _CatFactPageState();
}

class _CatFactPageState extends State<CatFactPage> {
  final List<CatFact> _facts = []; // ListView: бірнеше факт қатары
  RandomUser? _user;
  bool _loading = false;
  String? _error;

  Future<void> _run(Future<void> Function() job) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await job();
    } catch (e) {
      _error = 'Қате: $e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadFact() => _run(() async {
        final f = await widget.api.fetchFact();
        _facts.insert(0, f);
      });

  Future<void> _loadUser() => _run(() async {
        _user = await widget.api.fetchUser();
      });

  @override
  Widget build(BuildContext context) {
    final latest = _facts.isEmpty ? null : _facts.first;
    return Scaffold(
      appBar: AppBar(title: const Text('Cat Fact Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      latest?.fact ?? 'Фактті алу үшін батырманы басыңыз',
                      key: const Key('factText'),
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    if (latest != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('length: ${latest.length}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _loading ? null : _loadFact,
                    child: const Text('Жаңа факт алу'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: _loading ? null : _loadUser,
                    child: const Text('Random User'),
                  ),
                ),
              ],
            ),
            if (_loading) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            if (_user != null)
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(_user!.name),
                subtitle: Text('${_user!.email} · ${_user!.country}'),
              ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: _facts.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, i) => ListTile(
                  leading: Text('${_facts.length - i}'),
                  title: Text(_facts[i].fact),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
