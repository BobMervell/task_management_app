import 'package:flutter/foundation.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/db_helper.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  final DatabaseHelper dbHelper;


  TaskProvider({required this.dbHelper}) {
    _loadTasksFromDatabase();
  }

  List<Task> get tasks => _tasks;

  void addTask(Task task) async {
    _tasks.add(task);
    await dbHelper.insertTask(task);
    notifyListeners();
  }

  void removeTask(Task task) async {
    _tasks.remove(task);
    await dbHelper.deleteTask(task);
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.taskID == updatedTask.taskID);
    if (index >= 0) {
      _tasks[index] = updatedTask;
    }
    await dbHelper.updateTask(updatedTask);
    notifyListeners();
  }

  
  Future<void> _loadTasksFromDatabase() async {
    _tasks.clear();
    _tasks.addAll(await dbHelper.getTasks());
    notifyListeners();
  }
}
