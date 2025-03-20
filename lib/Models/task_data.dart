import 'package:flutter/material.dart';

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

class Status {
  StatusType statusType;
  int progress;

  Status({
    required this.statusType,
    this.progress = 0,
  });


  static Color getColorForStatus(StatusType statusType) {
    switch (statusType) {
      case StatusType.notStarted:
        return const Color.fromARGB(255, 158, 158, 158);
      case StatusType.inProgress:
        return const Color.fromARGB(255, 33, 150, 243);
      case StatusType.completed:
        return const Color.fromARGB(255, 76, 175, 80);
      case StatusType.onHold:
        return const Color.fromARGB(255, 255, 152, 0);
      case StatusType.cancelled:
        return const Color.fromARGB(255, 244, 67, 54);
      }
  }


  // Méthode pour mettre à jour le statut et la progression
  void updateStatus(StatusType newStatus, int newProgress) {
    newProgress = newProgress.clamp(0, 100);
    if (newStatus == StatusType.completed || (newProgress == 100 && newStatus == StatusType.inProgress)){
      statusType = StatusType.completed;
      progress = 100;
    }
    else if (newStatus == StatusType.notStarted || (newProgress == 0 && newStatus == StatusType.inProgress)){
      statusType = StatusType.notStarted;
      progress = 0;
    } else {
      statusType = newStatus;
      progress = newProgress;
    }
  }
}
