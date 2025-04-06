import 'dart:async';

class ToDoItem {
  final String id;
  final String title;
  final bool isCompleted;

  ToDoItem({required this.id, required this.title, this.isCompleted = false});
}

class ToDoData {
  static final List<ToDoItem> _tasks = [];

  static Future<List<ToDoItem>> fetchTasks() async {
    // Simulate server response delay
    await Future.delayed(const Duration(seconds: 2));

    // If no tasks exist, provide default fake tasks
    return _tasks.isNotEmpty
        ? _tasks
        : [
            ToDoItem(id: "1", title: "Sample Task 1"),
            ToDoItem(id: "2", title: "Sample Task 2"),
            ToDoItem(id: "3", title: "Sample Task 3"),
          ];
  }

  static Future<void> addTask(String title) async {
    _tasks.add(ToDoItem(id: DateTime.now().toString(), title: title));
  }

  static Future<void> removeTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
}
