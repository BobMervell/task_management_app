import 'package:flutter/material.dart';
import 'package:task_management_app/Models/task_data.dart';


class Task {
  String name;
  Color accentColor;
  String summary;
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
    this.summary = '',
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

  void updateSummary(String newSummary) {
    summary = newSummary;
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
  
  void updateAssignee(String newAssignee) {
    tags = newAssignee;
  }
  
  void updatePriority(PriorityLevels newPriotity) {
    priority = newPriotity;
  }

   static Color getColorForPriorityAccent(PriorityLevels priority) {
    switch (priority) {
      case PriorityLevels.unassigned:
        return Colors.grey;
      case PriorityLevels.low:
        return Colors.green;
      case PriorityLevels.medium:
        return Colors.orange;
      case PriorityLevels.high:
        return Colors.red;
      case PriorityLevels.critical:
        return Colors.purple;
    }
  }

      // Fonction pour obtenir la couleur en fonction de la priorité
  static Color getColorForPriorityNormal(PriorityLevels priority) {
    switch (priority) {
      case PriorityLevels.unassigned:
        return Colors.grey.withAlpha(200);
      case PriorityLevels.low:
        return Colors.green.withAlpha(200);
      case PriorityLevels.medium:
        return Colors.orange.withAlpha(200);
      case PriorityLevels.high:
        return Colors.red.withAlpha(200);
      case PriorityLevels.critical:
        return Colors.purple.withAlpha(200);
    }
  }

      // Fonction pour obtenir la couleur en fonction de la priorité
  static Color getColorForPriorityLight(PriorityLevels priority) {
    switch (priority) {
      case PriorityLevels.unassigned:
        return Colors.grey.withAlpha(100);
      case PriorityLevels.low:
        return Colors.green.withAlpha(100);
      case PriorityLevels.medium:
        return Colors.orange.withAlpha(100);
      case PriorityLevels.high:
        return Colors.red.withAlpha(100);
      case PriorityLevels.critical:
        return Colors.purple.withAlpha(100);
    }
  }


}
