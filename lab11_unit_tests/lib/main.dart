// Зертханалық сабақ №11. Қосымшаға unit-тест жазу.
// Қосымша — калькулятор; логика lib/calculator.dart ішінде, тесттер test/ қалтасында.
import 'package:flutter/material.dart';

import 'calculator.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _a = TextEditingController(text: '4');
  final _b = TextEditingController(text: '5');
  String _result = '—';

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  void _calc(String op) {
    final a = int.tryParse(_a.text);
    final b = int.tryParse(_b.text);
    if (a == null || b == null) {
      setState(() => _result = 'Бүтін сан енгізіңіз');
      return;
    }
    setState(() {
      try {
        _result = switch (op) {
          '+' => '${add(a, b)}',
          '−' => '${subtract(a, b)}',
          '×' => '${multiply(a, b)}',
          _ => '${divide(a, b)}',
        };
      } on ArgumentError catch (e) {
        _result = '${e.message}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: TextField(controller: _a, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'a', border: OutlineInputBorder()))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _b, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'b', border: OutlineInputBorder()))),
            ]),
            const SizedBox(height: 16),
            Wrap(spacing: 8, children: [
              for (final op in ['+', '−', '×', '÷'])
                FilledButton(onPressed: () => _calc(op), child: Text(op)),
            ]),
            const SizedBox(height: 24),
            Text('Нәтиже: $_result', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
