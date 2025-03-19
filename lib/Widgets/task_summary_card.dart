import 'package:flutter/material.dart';
import 'package:task_management_app/Models/task_data.dart';

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
          height: 500,
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
              children: StatusType.values.map((status) {
                return ListTile(
                  title: Text(status.toString().split('.').last.capitalize()),
                  onTap: () {
                    Navigator.pop(context, status);
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
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}


  TextButton statusButton(BuildContext context,Task task) {
    return TextButton(
                  onPressed: () async {
                    StatusType? selectedStatus = await StatusSelector.showStatusSelector(context);
                    if (selectedStatus != null) {
                      // Utiliser le statut sélectionné
                      print('Selected Status: $selectedStatus');
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Status.getColorForStatus(task.status.status),
                  ),
                  child: Text(
                    task.status.status.toString().split('.').last,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              );
  }

