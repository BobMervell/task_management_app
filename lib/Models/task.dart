import 'package:flutter/material.dart';
import 'package:task_management_app/Models/task_data.dart';


class Task extends ChangeNotifier {
  String name;
  Color accentColor;
  String description;
  DateTime startDate;
  DateTime deadline;
  Duration estimatedDuration;
  Duration actualDuration;
  List<Task> subTasksList;
  Status status;
  String tags;
  PriorityLevels priority;


  Task({
    required this.name,
    required this.accentColor,
    this.description = '',
    DateTime? startDate,
    DateTime? deadline,
    this.estimatedDuration = Duration.zero,
    this.actualDuration = Duration.zero,
    this.subTasksList = const [],
    Status? status,
    this.tags = '',
    this.priority = PriorityLevels.unassigned,

  })  : 
        startDate = startDate ?? DateTime.now(), // not in optional above cause not constant
        deadline = deadline ?? DateTime.now().add(Duration(days: 1)),
        status = status ?? Status(status:StatusType.notStarted);

  void addSubTask(Task task) {
    subTasksList.add(task);
    notifyListeners();
  }

  void removeSubTask(Task task) {
    subTasksList.remove(task);
    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateColor(Color newColor) {
    accentColor = newColor;
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
    tags = newAssignee;
    notifyListeners();
  }
  
  void updatePriority(PriorityLevels newPriotity) {
    priority = newPriotity;
    notifyListeners();
  }
}
