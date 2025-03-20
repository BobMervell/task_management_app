import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'dart:math';
import 'package:task_management_app/Models/task.dart';

// ignore: unused_import
import 'package:task_management_app/Widgets/test_widget.dart';

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

  Row statusButton(BuildContext context,Task task) {
    var taskProvider = Provider.of<TaskProvider>(context);
    Color backgroundColor = Status.getColorForStatusLight(task.status.statusType);
    Color progressColor = Status.getColorForStatusNormal(task.status.statusType);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(builder: (context) {
            return  SliderButton(
            onProgressChanged: (newProgress) {
            task.status.updateStatus(StatusType.inProgress, newProgress.toInt());
            taskProvider.updateTask(task);
            },
            onPressed: () async {

              StatusType? newStatusType = await showMenu<StatusType>(
              context: context,
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              position: customPopupMenuPositionBuilder(context),
      items: StatusType.values.map((statusType) {
        return PopupMenuItem<StatusType>(
          height: 30,
          value: statusType,
          child: Center(
            child: SimpleButton(
              onPressed: () => Navigator.pop(context, statusType),
              backgroundColor: Status.getColorForStatusNormal(statusType),
              width: 100,
              height: 25,
              child: Text(
                statusType.toString().split('.').last.toReadable(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        );
      }).toList(),
            );
              
              task.status.updateStatus( newStatusType ?? task.status.statusType,task.status.progress ); //if null keep same
              taskProvider.updateTask(task);
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
            );
          } )
         
        ],
      );
    }

RelativeRect customPopupMenuPositionBuilder(BuildContext context) {
    // Calculate the position of the popup menu
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    return position;
  }

}

class StatusSelector extends StatelessWidget {
  const StatusSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: StatusType.values.map((statusType) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: SimpleButton(
                    onPressed: () => Navigator.pop(context,statusType),
                    backgroundColor: Status.getColorForStatusNormal(statusType),
                    width: 100,
                    height: 25,
                    child: Text(
                    statusType.toString().split('.').last.toReadable(),
                    style: Theme.of(context).textTheme.bodyMedium,
                                ),
                  ),
                );
              
              }).toList(),
      ),
    );
  }
}






class DropDownWithCustomButtons extends StatefulWidget {
  const DropDownWithCustomButtons({super.key});

  @override
  DropDownWithCustomButtonsState createState() => DropDownWithCustomButtonsState();
}
class DropDownWithCustomButtonsState extends State<DropDownWithCustomButtons> {
  void _showCustomMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx, // Position X du clic
        details.globalPosition.dy, // Position Y du clic
        overlay.size.width, // Largeur de l'écran
        overlay.size.height, // Hauteur de l'écran
      ),


      items: StatusType.values.map((statusType) {
        return PopupMenuItem(
          value: statusType,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: SimpleButton(
              onPressed: () => Navigator.pop(context, statusType),
              backgroundColor: Status.getColorForStatusNormal(statusType),
              width: 100,
              height: 25,
              child: Text(
                statusType.toString().split('.').last.toReadable(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        );
      }).toList(),
    );

    if (result != null) {
      print("Sélectionné : $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Dropdown Menu")),
      body: GestureDetector(
        onTapDown: (details) => _showCustomMenu(context, details),
        child: Center(
          child: Text("Cliquez pour ouvrir le menu"),
        ),
      ),
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



class SimpleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color hoverColor;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final Widget child;

  SimpleButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    Color? hoverColor,
    BorderRadius? borderRadius,
    required this.height,
    required this.width,
    required this.child,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(8.0),
       hoverColor = hoverColor?? backgroundColor;

  @override
  SimpleButtonState createState() => SimpleButtonState();
}

class SimpleButtonState extends State<SimpleButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _mouseEnter(true),
      onExit: (event) => _mouseEnter(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          height: widget.height,
          width: widget.width,
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _isHovering ? widget.hoverColor : widget.backgroundColor,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: _isHovering ? Theme.of(context).dividerColor : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Center(child: widget.child),
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