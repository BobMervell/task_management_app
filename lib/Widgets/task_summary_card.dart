import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Providers/task_provider.dart';

import '../Models/task.dart';

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
        print(value);
        return SizedBox(
          width: 300, 
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: const Color(0xFF4F4739), width: 3.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation:10.0,
            shadowColor: Theme.of(context).dividerColor,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [titleRow,
                  Divider(color: Theme.of(context).dividerColor, thickness: 2.0), 
                  SizedBox(height: 8),
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
                print("task edition to add");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: task.subTasksList[index].accentColor,
                        borderRadius: BorderRadius.circular(8.0), 
                        ),
                      ),
                      Text(
                        ' ${task.subTasksList[index].name}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    statusButton(context,task.subTasksList[index]),
                    SizedBox(height: 50),
                ]
                          ),
              ),
            );
        },
      );
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
          height: 250,
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

extension StringExtension on String {
  
  String toReadable() {
    if (isEmpty) return this;
    String readableString = replaceAllMapped(RegExp(r'(?<!^)(?=[A-Z])'),  (match) => ' ');

    return readableString[0].toUpperCase() + readableString.substring(1).toLowerCase();
  }
}


  HoverButton statusButton(BuildContext context,Task task) {
    var taskProvider = Provider.of<TaskProvider>(context);
      
      return HoverButton(
        onPressed: () async {
          StatusType? selectedStatus = await StatusSelector.showStatusSelector(context);
          if (selectedStatus != null) {
            // Utiliser le statut sélectionné
            task.updateStatus(Status(statusType: selectedStatus));
            taskProvider.updateTask(task);
          }
        },
        backgroundColor: Status.getColorForStatus(task.status.statusType),
        child: Text(
            task.status.statusType.toString().split('.').last.toReadable(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }


class HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget child;

  HoverButton({super.key, 
    required this.onPressed,
    required this.backgroundColor,
    BorderRadius? borderRadius,
    required this.child,
  }):
        borderRadius = borderRadius ?? BorderRadius.circular(8.0); // not in optional above cause not constant

  @override
  HoverButtonState createState() => HoverButtonState();
}

class HoverButtonState extends State<HoverButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _mouseEnter(true),
      onExit: (event) => _mouseEnter(false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: _isHovering ? Theme.of(context).dividerColor : Colors.transparent,
            width: 1.0,
          ),
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius,
            ),
          ),
          child: widget.child,
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
