import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Widgets/task_edition_dialog.dart';
import 'package:task_management_app/Widgets/Components/custom_buttons.dart';

/// A widget that displays a summary card for a project task.
///
/// This widget shows the task name, an edit button, and a list of sub-tasks.
class ProjectSummaryCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;

  const ProjectSummaryCard({
    super.key,
    required this.task,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Define the title row containing the task color, name, and edit button
    var titleRow = Row(
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

    // Use Consumer to listen to changes in TaskProvider
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
            elevation: 10.0,
            shadowColor: Theme.of(context).dividerColor,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  titleRow,
                  Divider(color: Theme.of(context).dividerColor, thickness: 2.0),
                  Expanded(child: scrollableTasks())
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Creates a scrollable list of sub-tasks for the given task.
  ///
  /// If there are no sub-tasks, it displays a message indicating that.
  Widget scrollableTasks() {
    return task.subTasksList.isEmpty
        ? Center(child: Text('No task to display'))
        : ListView.builder(
            itemCount: task.subTasksList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  // Show a dialog to edit the selected sub-task
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskEditDialog(task: task.subTasksList[index]);
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.subTasksList[index].name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      // Display the status button for the sub-task
                      statusButton(context, task.subTasksList[index]),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
