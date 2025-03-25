import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Providers/task_provider.dart';

import 'package:task_management_app/Models/task_data.dart';

import 'package:task_management_app/Widgets/Utilities/string_utilities.dart';
import 'package:task_management_app/Widgets/Utilities/menu_position_utilities.dart';

//Methods

Row statusButton(BuildContext context,Task task) {
    var taskProvider = Provider.of<TaskProvider>(context);
    Color backgroundColor = Status.getColorForStatusLight(task.status.statusType);
    Color progressColor = Status.getColorForStatusNormal(task.status.statusType);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(builder: (context) {
            return  SliderStatusButton(
            onProgressChanged: (newProgress) {
            task.status.updateStatus(StatusType.inProgress, newProgress: newProgress.toInt());
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
              ),
            ),
          ),
        );
      }).toList(),
            );
              
              task.status.updateStatus( newStatusType ?? task.status.statusType); //if null keep same
              taskProvider.updateTask(task);
            },
            task: task,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
            width: 100,
            height: 25,
            child: Text(
                task.status.statusType.toString().split('.').last.toReadable(),
              ),
            );
          } )
         
        ],
      );
    }

Row priorityButton(BuildContext context, Task task) {
  var taskProvider = Provider.of<TaskProvider>(context);
  Color backgroundColor = Task.getColorForPriorityNormal(task.priority); // Fonction pour obtenir la couleur de la priorité

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Builder(builder: (context) {
        return SimpleButton(
          backgroundColor: backgroundColor,
          height: 25,
          width: 100,
          child: Text(
            task.priority.toString().split('.').last.toReadable(),
            style: Theme.of(context).textTheme.labelLarge,
             ),
          onPressed: () async {
            PriorityLevels? newPriority = await showMenu<PriorityLevels>(
              context: context,
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              position: customPopupMenuPositionBuilder(context),
              items: PriorityLevels.values.map((priority) {
                return PopupMenuItem<PriorityLevels>(
                  height: 30,
                  value: priority,
                  child: Center(
                    child: SimpleButton(
                      onPressed: () => Navigator.pop(context, priority),
                      backgroundColor: Task.getColorForPriorityNormal(priority),
                      width: 100,
                      height: 25,
                      child: Text(
                        priority.toString().split('.').last.toReadable(),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );

            if (newPriority != null) {
              task.priority = newPriority;
              taskProvider.updateTask(task);
            }
          },
        );
      }),
    ],
  );
}





//Classes


class DualActionButton extends StatelessWidget {
  final Text label;
  final Icon icon;
  final VoidCallback onPressed;
  final VoidCallback onIconPressed;

  const DualActionButton({super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: label,
                ),
                IconButton(
                  icon: icon,
                  onPressed: onIconPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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








class SliderStatusButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ValueChanged<double> onProgressChanged;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final Widget child;
  final Task task;

  SliderStatusButton({
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
  SliderStatusButtonState createState() => SliderStatusButtonState();
}

class SliderStatusButtonState extends State<SliderStatusButton> {
  bool _isHovering = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context,taskProvider,child) {
        _progress = widget.task.status.progress.toDouble();
      return MouseRegion(
        onEnter: (event) => _mouseEnter(true),
        onExit: (event) => _mouseEnter(false),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            double progressWidth = context.size!.width;
            _progress = (details.localPosition.dx / progressWidth * 100).clamp(0, 100);
            widget.onProgressChanged(_progress);
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
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      );
      }
    );
  }

  void _mouseEnter(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }
}









