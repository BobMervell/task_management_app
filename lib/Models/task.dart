import 'package:flutter/material.dart';
import 'package:task_management_app/Models/task_data.dart';


class Task {
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
        status = status ?? Status(statusType:StatusType.notStarted);

  void addSubTask(Task task) {
    subTasksList.add(task);
  }

  void removeSubTask(Task task) {
    subTasksList.remove(task);
  }

  void updateName(String newName) {
    name = newName;
  }

  void updateColor(Color newColor) {
    accentColor = newColor;
  }

  void updateDescription(String newDescription) {
    description = newDescription;
  }

  void updateStartDate(DateTime newStartDate) {
    startDate = newStartDate;
  }

  void updateDeadline(DateTime newDeadline) {
    deadline = newDeadline;
  }

  void updateEstimatedDuration(Duration newEstimatedDuration) {
    estimatedDuration = newEstimatedDuration;
  }

  void updateActualDuration(Duration newActualDuration) {
    actualDuration = newActualDuration;
  }

  void updateStatus(Status newStatus) {
    status = newStatus;
  }
  
  void updateAssignee(String newAssignee) {
    tags = newAssignee;
  }
  
  void updatePriority(PriorityLevels newPriotity) {
    priority = newPriotity;
  }
}
