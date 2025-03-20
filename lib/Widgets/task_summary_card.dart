import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'dart:math';
import 'package:task_management_app/Models/task.dart';

class ProjectSummaryCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;

  const ProjectSummaryCard({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    var titleRow = 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: task.accentColor,
                      borderRadius: BorderRadius.circular(8.0), 
                    ),
                  ),
                  Text(
                    task.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).dividerColor),
                    onPressed: onEdit,
                  ),
                ],
              );
    
    return Consumer<TaskProvider>(
      builder: (context, value, child) {
        return SizedBox(
          width: 400, 
          height: 300,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: const Color(0xFF4F4739), width: 3.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation:10.0,
            shadowColor: Theme.of(context).dividerColor,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [titleRow,
                  Divider(color: Theme.of(context).dividerColor, thickness: 2.0), 
                  Expanded(child: scrollableTasks())
                ]
              ),
            ),
          ),
        );
      }
    );
  }

  Widget scrollableTasks() {
    return task.subTasksList.isEmpty
      ? Center(child: Text('No task to display'))
      : ListView.builder(
          itemCount: task.subTasksList.length,
          itemBuilder: (BuildContext context,int index ){
            return InkWell(
              onTap: () {
                print("edit task");
                print(task.subTasksList[index].name);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        (' ${task.subTasksList[index].name} '),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    statusButton(context,task.subTasksList[index]),
                  ]
                ),
              ),
            );
        },
      );
  }

  Consumer<TaskProvider> progressSlider(int index) {
    return Consumer<TaskProvider>(
                    builder: (context,value,child) {
                      return CircularSlider(
                        progress: task.subTasksList[index].status.progress.toDouble(),
                        backgroundColor:const Color.fromARGB(0, 0, 0, 0),
                        progressColor: Status.getColorForStatus(task.subTasksList[index].status.statusType),
                        circleSize: Size(20,20),
                        circleWidth: 5,
                      );
                    }
                  );
  }

  Row statusButton(BuildContext context,Task task) {
    var taskProvider = Provider.of<TaskProvider>(context);
    Color statusColor = Status.getColorForStatus(task.status.statusType);
    Color backgroundColor = statusColor.withAlpha(100);
    Color progressColor = statusColor.withAlpha(200);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SliderButton(
            onProgressChanged: (newProgress) {
            task.status.updateStatus(StatusType.inProgress, newProgress.toInt());
            taskProvider.updateTask(task);
            },
            onPressed: () async {
              StatusType? selectedStatus = await StatusSelector.showStatusSelector(context);
              if (selectedStatus != null) {
                task.status.updateStatus(selectedStatus, task.status.progress);
                taskProvider.updateTask(task);
              }
            },
            task: task,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
            width: 100,
            height: 25,
            child: Text(
                task.status.statusType.toString().split('.').last.toReadable(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      );
    }

}

extension StringExtension on String {
  
  String truncateText(int maxLength) {
   if (length <= maxLength) {
      return this;
    } else {
      return '${substring(0, maxLength)} ... ';
    }
  }

  String toReadable() {
    if (isEmpty) return this;
    String readableString = replaceAllMapped(RegExp(r'(?<!^)(?=[A-Z])'),  (match) => ' ');

    return readableString[0].toUpperCase() + readableString.substring(1).toLowerCase();
  }
}


class StatusSelector {
  static Future<StatusType?> showStatusSelector(BuildContext context) async {
    return showModalBottomSheet<StatusType>(
      context: context,
      isScrollControlled: true, 
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8)),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 2.0,
            )
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: StatusType.values.map((statusType) {
                return ListTile(
                  title: Text(statusType.toString().split('.').last.toReadable()),
                  onTap: () {
                    Navigator.pop(context, statusType);
                  },
                );
              }).toList(),
            ),
        );
      },
    );
  }
}



class CircularSlider extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final Size circleSize;
  final double circleWidth;

  const CircularSlider({super.key, 
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.circleSize,
    required this.circleWidth
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: circleSize, // Taille du widget
      painter: CircularSliderPainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
        circleWidth: circleWidth,
      ),
    );
  }
}

class CircularSliderPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double circleWidth;


  CircularSliderPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.circleWidth,

  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      paint,
    );

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      (progress / 100) * 2 * pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class SliderButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ValueChanged<double> onProgressChanged;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final Widget child;
  final Task task;

  SliderButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.progressColor,
    BorderRadius? borderRadius,
    required this.height,
    required this.width,
    required this.child,
    required this.task,
    required this.onProgressChanged,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(8.0);

  @override
  SliderButtonState createState() => SliderButtonState();
}

class SliderButtonState extends State<SliderButton> {
  bool _isHovering = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _mouseEnter(true),
      onExit: (event) => _mouseEnter(false),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          double progressWidth = context.size!.width;
          double newProgress = (details.localPosition.dx / progressWidth * 100).clamp(0, 100);
          setState(() {
            _progress = newProgress;
          });
          widget.onProgressChanged(newProgress);
        },
        child: AnimatedContainer(
          height: widget.height,
          width: widget.width,
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: _isHovering ? Theme.of(context).dividerColor : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              // Background container
              Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: widget.borderRadius,
                ),
              ),
              // Progress container
              FractionallySizedBox(
                widthFactor: _progress / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.progressColor,
                    borderRadius: widget.borderRadius,
                  ),
                ),
              ),
              // Button content
              TextButton(
                onPressed: widget.onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: widget.borderRadius,
                  ),
                ),
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mouseEnter(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }
}
