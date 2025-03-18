import 'package:flutter/foundation.dart';

enum PriorityLevels {
  unassigned,
  low,
  medium,
  high,
  critical,
}

enum StatusType {
  notStarted,
  inProgress,
  completed,
  onHold,
  cancelled,
}

class Status extends ChangeNotifier {
  StatusType status;
  int progress;

  Status({
    required this.status,
    this.progress = 0,
  });


  // Méthode pour mettre à jour le statut et la progression
  void updateStatus(StatusType newStatus, {int newProgress = 0}) {
    status = newStatus;
    if (newStatus == StatusType.inProgress) {
      if (newProgress >= 0 && newProgress <= 100) {
        progress = newProgress;
      }
    } else {
      progress = 0;
    }
    notifyListeners();
  }
}
