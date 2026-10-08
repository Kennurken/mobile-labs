/// ToDo тізімінің қарапайым бизнес-логикасы.
class TodoItem {
  TodoItem(this.title, {this.done = false});
  final String title;
  bool done;
}

class TodoList {
  final List<TodoItem> _items = [];

  List<TodoItem> get items => List.unmodifiable(_items);
  int get remaining => _items.where((t) => !t.done).length;

  /// Элемент қосу. Бос атау қабылданбайды.
  void add(String title) {
    final t = title.trim();
    if (t.isEmpty) throw ArgumentError('Атау бос болмауы керек');
    _items.add(TodoItem(t));
  }

  void toggle(int index) => _items[index].done = !_items[index].done;

  void removeAt(int index) => _items.removeAt(index);
}
