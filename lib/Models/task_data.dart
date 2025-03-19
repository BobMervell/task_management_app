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
        return const Color.fromARGB(150, 158, 158, 158);
      case StatusType.inProgress:
        return const Color.fromARGB(150, 33, 150, 243);
      case StatusType.completed:
        return const Color.fromARGB(150, 76, 175, 80);
      case StatusType.onHold:
        return const Color.fromARGB(150, 255, 152, 0);
      case StatusType.cancelled:
        return const Color.fromARGB(150, 244, 67, 54);
      }
  }


  // Méthode pour mettre à jour le statut et la progression
  void updateStatus(StatusType newStatus, {int newProgress = 0}) {
    statusType = newStatus;
    if (newStatus == StatusType.inProgress) {
      if (newProgress >= 0 && newProgress <= 100) {
        progress = newProgress;
      }
    } else {
      progress = 0;
    }
  }
}
