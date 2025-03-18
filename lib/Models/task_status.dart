import 'package:flutter/foundation.dart';


enum TaskStatusType {
  notStarted,
  inProgress,
  completed,
  onHold,
  cancelled,
}

class TaskStatus extends ChangeNotifier {
  TaskStatusType status;
  int progress;

  TaskStatus({
    required this.status,
    this.progress = 0,
  });


  // Méthode pour mettre à jour le statut et la progression
  void updateStatus(TaskStatusType newStatus, {int newProgress = 0}) {
    status = newStatus;
    if (newStatus == TaskStatusType.inProgress) {
      if (newProgress >= 0 && newProgress <= 100) {
        progress = newProgress;
      }
    } else {
      progress = 0;
    }
    notifyListeners();
  }
}
