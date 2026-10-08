// Зертханалық сабақ №5. CRUD-қосымша: тапсырмалар тізімі (ToDo App).
// Деректер қоры ретінде Local State (shared_preferences, JSON) қолданылады.
// TaskRepository интерфейсі арқылы оны Firebase Firestore-ға ауыстыру оңай.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  Task({required this.id, required this.title, this.isDone = false});

  final int id;
  final String title;
  final bool isDone;

  Task copyWith({String? title, bool? isDone}) =>
      Task(id: id, title: title ?? this.title, isDone: isDone ?? this.isDone);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'isDone': isDone};

  factory Task.fromJson(Map<String, dynamic> j) =>
      Task(id: j['id'] as int, title: j['title'] as String, isDone: j['isDone'] as bool);
}

/// CRUD операциялары (tasks коллекциясы).
class TaskRepository extends ChangeNotifier {
  TaskRepository(this._prefs) {
    final raw = _prefs.getString('tasks');
    if (raw != null) {
      _tasks.addAll((jsonDecode(raw) as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>)));
    }
  }

  final SharedPreferences _prefs;
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  // Read: тізім өзгерген сайын ListenableBuilder UI-ді жаңартады
  Future<void> _save() async {
    await _prefs.setString('tasks', jsonEncode(_tasks.map((t) => t.toJson()).toList()));
    notifyListeners();
  }

  // Create Document → tasks
  Future<void> create(String title) {
    final id = _tasks.isEmpty ? 1 : _tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    _tasks.add(Task(id: id, title: title));
    return _save();
  }

  // Update Document: isDone true/false ауысады
  Future<void> toggle(int id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i != -1) _tasks[i] = _tasks[i].copyWith(isDone: !_tasks[i].isDone);
    return _save();
  }

  // Update Document: атауын өзгерту
  Future<void> rename(int id, String title) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i != -1) _tasks[i] = _tasks[i].copyWith(title: title);
    return _save();
  }

  // Delete Document
  Future<void> delete(int id) {
    _tasks.removeWhere((t) => t.id == id);
    return _save();
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key, required this.repo});
  final TaskRepository repo;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    await widget.repo.create(title);
    _controller.clear();
  }

  Future<void> _edit(Task task) async {
    final c = TextEditingController(text: task.title);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Тапсырманы өзгерту'),
        content: TextField(key: const Key('editField'), controller: c, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Болдырмау')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Сақтау')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) await widget.repo.rename(task.id, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List Page')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskField'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Тапсырма енгізіңіз',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _add, child: const Text('Add Task')),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.repo,
              builder: (context, _) {
                final tasks = widget.repo.tasks;
                if (tasks.isEmpty) {
                  return const Center(child: Text('Тапсырмалар жоқ'));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, i) {
                    final t = tasks[i];
                    return ListTile(
                      key: ValueKey(t.id),
                      leading: Checkbox(value: t.isDone, onChanged: (_) => widget.repo.toggle(t.id)),
                      title: Text(
                        t.title,
                        style: TextStyle(
                          decoration: t.isDone ? TextDecoration.lineThrough : null,
                          color: t.isDone ? Colors.grey : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit),
                            onPressed: () => _edit(t),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            icon: const Icon(Icons.delete),
                            onPressed: () => widget.repo.delete(t.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
