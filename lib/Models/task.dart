import 'package:flutter/foundation.dart';
import 'package:task_management_app/Models/task_data.dart';


class Task extends ChangeNotifier {
  String name;
  String description;
  DateTime startDate;
  DateTime deadline;
  Duration estimatedDuration;
  Duration actualDuration;
  List<Task> taskList;
  Status status;
  String assignee;
  PriorityLevels priority;


  Task({
    required this.name,
    this.description = '',
    DateTime? startDate,
    DateTime? deadline,
    this.estimatedDuration = Duration.zero,
    this.actualDuration = Duration.zero,
    this.taskList = const [],
    Status? status,
    this.assignee = '',
    this.priority = PriorityLevels.unassigned,

  })  : startDate = startDate ?? DateTime.now(), // not in optional above cause not constant
        deadline = deadline ?? DateTime.now().add(Duration(days: 1)),
        status = status ?? Status(status:StatusType.notStarted);

  void addTask(Task task) {
    taskList.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    taskList.remove(task);
    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  void updateStartDate(DateTime newStartDate) {
    startDate = newStartDate;
    notifyListeners();
  }

  void updateDeadline(DateTime newDeadline) {
    deadline = newDeadline;
    notifyListeners();
  }

  void updateEstimatedDuration(Duration newEstimatedDuration) {
    estimatedDuration = newEstimatedDuration;
    notifyListeners();
  }

  void updateActualDuration(Duration newActualDuration) {
    actualDuration = newActualDuration;
    notifyListeners();
  }

  void updateStatus(Status newStatus) {
    status = newStatus;
    notifyListeners();
  }
  
  void updateAssignee(String newAssignee) {
    assignee = newAssignee;
    notifyListeners();
  }
  
  void updatePriority(PriorityLevels newPriotity) {
    priority = newPriotity;
    notifyListeners();
  }
}
