import 'package:flutter/material.dart';
import '../Models/task.dart';

class ProjectSummaryCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;

  const ProjectSummaryCard({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: 300 * 4/3, 
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: const Color(0xFF4F4739), width: 3.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 10.0,
        shadowColor: Theme.of(context).dividerColor,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                    icon: Icon(Icons.edit, color: Theme.of(context).dividerColor), // Icône de stylo
                    onPressed: onEdit,
                  ),
                  // Ajoute ici d'autres icônes si nécessaire
                ],
              ),
              /* SizedBox(height: 16), */
              
              Divider(color: Theme.of(context).dividerColor, thickness: 2.0), 
              SizedBox(height: 8),
              Text(
                'Description: ${task.description}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Start Date: ${task.startDate.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Deadline: ${task.deadline.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Priority: ${task.priority.toString().split('.').last}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class TaskSummaryCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;

  const TaskSummaryCard({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: 300.0, 
      height: 200.0, 
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: const Color(0xFF4F4739), width: 2.0), // Contour noir
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0, // Pas d'ombre
        color: Theme.of(context).cardColor, // Couleur de fond
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: const Color(0xFF4F4739)), // Icône de stylo
                    onPressed: onEdit,
                  ),
                  // Ajoute ici d'autres icônes si nécessaire
                ],
              ),
              SizedBox(height: 16),
              Text(
                task.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${task.description}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Start Date: ${task.startDate.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Deadline: ${task.deadline.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Priority: ${task.priority.toString().split('.').last}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
