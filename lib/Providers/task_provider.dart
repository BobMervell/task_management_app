import 'package:flutter/foundation.dart';
import 'package:task_management_app/Models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.name == updatedTask.name);
    if (index >= 0) {
      _tasks[index] = updatedTask;
    }
    notifyListeners();
  }
}
