import 'package:flutter/material.dart';

void main() {
  runApp(const DataInputApp());
}

class DataInputApp extends StatelessWidget {
  const DataInputApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Input App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const DataInputPage(),
    );
  }
}

class DataInputPage extends StatefulWidget {
  const DataInputPage({super.key});

  @override
  State<DataInputPage> createState() => _DataInputPageState();
}

class _DataInputPageState extends State<DataInputPage> {
  final _nameController = TextEditingController();
  String _result = '';

  void _show() {
    setState(() {
      _result = _nameController.text.trim();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Input Page'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Өзіңіздің атыңызды енгізіңіз',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Аты-жөні',
              ),
              onSubmitted: (_) => _show(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _show,
              child: const Text('Көрсету'),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
