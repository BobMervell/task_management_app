import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/db_helper.dart';


class Task {
  String name;
  Color accentColor;
  Document description;
  DateTime startDate;
  DateTime deadline;
  Duration estimatedDuration;
  Duration actualDuration;
  List<String> subTasksList;
  Status status;
  List<String> tags;
  PriorityLevels priority;
  String taskID;
  String parentTaskID;
  DatabaseHelper dbHelper;


  Task({
    required this.dbHelper,
    required this.name,
    required this.accentColor,
    required this.taskID,
    required this.parentTaskID,
    Document? description,
    DateTime? startDate,
    DateTime? deadline,
    this.estimatedDuration = Duration.zero,
    this.actualDuration = Duration.zero,
    this.subTasksList = const [],
    Status? status,
    this.tags = const [],
    this.priority = PriorityLevels.unassigned,

  })  : description = description?? Document(),
        startDate = startDate ?? DateTime.now(),
        deadline = deadline ?? DateTime.now().add(Duration(days: 1)),
        status = status ?? Status(statusType:StatusType.notStarted);
  
  void addSubTask(Task task) {
    subTasksList.add(task.taskID);
    dbHelper.insertTask(task);
    dbHelper.updateTask(this);
  }

  void removeSubTask(Task task) {
    subTasksList.remove(task.taskID);
    dbHelper.deleteTask(task);
    dbHelper.updateTask(this);
  }

  void updateName(String newName) {
    name = newName;
    dbHelper.updateTask(this);
  }

  void updateColor(Color newColor) {
    accentColor = newColor;
    dbHelper.updateTask(this);
  }

  void updateDescription(Document newDescription) {
    description = newDescription;
    dbHelper.updateTask(this);
  }

  void updateStartDate(DateTime newStartDate) {
    startDate = newStartDate;
    dbHelper.updateTask(this);
  }

  void updateDeadline(DateTime newDeadline) {
    deadline = newDeadline;
    dbHelper.updateTask(this);
  }

  void updateEstimatedDuration(Duration newEstimatedDuration) {
    estimatedDuration = newEstimatedDuration;
    dbHelper.updateTask(this);
  }

  void updateActualDuration(Duration newActualDuration) {
    actualDuration = newActualDuration;
    dbHelper.updateTask(this);
  }
  
  void updateTags(List<String> newTags) {
    tags = newTags;
    dbHelper.updateTask(this);
  }
  
  void updatePriority(PriorityLevels newPriotity) {
    priority = newPriotity;
    dbHelper.updateTask(this);
  }

  void setTaskID(String newTaskID) {
    taskID = newTaskID;
    dbHelper.updateTask(this);
  }

  void setParentTaskID(String newParentTaskID) {
    parentTaskID = newParentTaskID;
    dbHelper.updateTask(this);
  }

 factory Task.fromMap(Map<String, dynamic> map,DatabaseHelper dbHelper) {
  return Task(
     name: map['name'] ?? '', 
    accentColor: Color(int.parse(map['accentColor'] ?? 'FFFFFF', radix: 16)), 
    taskID: map['taskID'] ?? '', 
    parentTaskID: map['parentTaskID'] ?? '', 
    description: map['description'] != null
        ? Document.fromDelta(Delta.fromJson(jsonDecode(map['description'])))
        : Document(),
    startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : DateTime.now(), 
    deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : DateTime.now(), 
    estimatedDuration: Duration(seconds: map['estimatedDuration'] ?? 0), 
    actualDuration: Duration(seconds: map['actualDuration'] ?? 0), 
    subTasksList: map['subTasksList'] != null ? List<String>.from(jsonDecode(map['subTasksList'])) : [], 
    status: Status(statusType: StatusType.values[map['statusType']?? 0], progress:map['statusProgress']?? 0 ),
    tags: map['tags'] != null && map['tags'].isNotEmpty
    ? (map['tags'].startsWith('['))  // Check if it's a JSON array
        ? List<String>.from(jsonDecode(map['tags']))
        : [map['tags']]  // Treat as a single tag
    : [],
    priority: map['priority'] != null
        ? PriorityLevels.values.firstWhere((e) => e.toString().split('.').last == map['priority'])
        : PriorityLevels.values.first, 
    dbHelper: dbHelper,
   );
}


Map<String, dynamic> toMap() {
  return {
    'name': name,
    'accentColor': accentColor.toARGB32().toRadixString(16), // Convert Color to hex string
    'taskID': taskID,
    'parentTaskID': parentTaskID,
    'description': jsonEncode(description.toDelta().toJson()), 
    'startDate': startDate.toIso8601String(),
    'deadline': deadline.toIso8601String(),
    'estimatedDuration': estimatedDuration.inSeconds,
    'actualDuration': actualDuration.inSeconds,
    'subTasksList': jsonEncode(subTasksList),
    'statusType': status.statusType.index,
    'statusProgress' : status.progress,
    'tags': jsonEncode(tags),
    'priority': priority.toString().split('.').last,
  };
}




// Méthode statique pour obtenir une tâche par son ID
static Future<Task?> getTaskById(String taskId, DatabaseHelper dbHelper) {
 return( dbHelper.getTaskById(taskId));
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
