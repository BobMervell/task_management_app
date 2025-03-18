import 'package:flutter/material.dart';

import '../Models/task.dart';

class ProjectSummaryCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;

  const ProjectSummaryCard({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    var titleRow = [
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
              ),
              Divider(color: Theme.of(context).dividerColor, thickness: 2.0), 
              SizedBox(height: 8),
              scrollableTasks()
            ];
    
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
            children: titleRow,
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
                  return Center(child: Text(' ${task.subTasksList[index].name}'));
              },
            );
  }
}


