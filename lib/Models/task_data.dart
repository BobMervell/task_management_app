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

  static Color getColorForStatusAccent(StatusType statusType) {
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

  static Color getColorForStatusNormal(StatusType statusType) {
    switch (statusType) {
      case StatusType.notStarted:
        return const Color.fromARGB(200, 158, 158, 158);
      case StatusType.inProgress:
        return const Color.fromARGB(200, 33, 150, 243);
      case StatusType.completed:
        return const Color.fromARGB(200, 76, 175, 80);
      case StatusType.onHold:
        return const Color.fromARGB(200, 255, 152, 0);
      case StatusType.cancelled:
        return const Color.fromARGB(200, 244, 67, 54);
      }
  }

  static Color getColorForStatusLight(StatusType statusType) {
    switch (statusType) {
      case StatusType.notStarted:
        return const Color.fromARGB(100, 158, 158, 158);
      case StatusType.inProgress:
        return const Color.fromARGB(100, 33, 150, 243);
      case StatusType.completed:
        return const Color.fromARGB(100, 76, 175, 80);
      case StatusType.onHold:
        return const Color.fromARGB(100, 255, 152, 0);
      case StatusType.cancelled:
        return const Color.fromARGB(100, 244, 67, 54);
      }
  }

void updateStatus(StatusType newStatus, {int? newProgress}) {
  if (newProgress == null) {
    statusType = newStatus;
    if (statusType == StatusType.completed ) {progress = 100;}
    else if (statusType == StatusType.notStarted ) {progress = 0;  }
  }
  else if (newStatus == StatusType.completed || newProgress >= 100 ) {
    statusType = StatusType.completed;
    progress = 100;
  }
  else if (newStatus == StatusType.notStarted || newProgress <= 0 ) {
    statusType = StatusType.notStarted;
    progress = 0;
  }
  else if (newStatus == StatusType.inProgress && (statusType == StatusType.completed || statusType == StatusType.notStarted)) {
    statusType = StatusType.inProgress;
    progress = 50;
  }
   else {
    statusType = newStatus;
    progress = newProgress;
  }
}

}
