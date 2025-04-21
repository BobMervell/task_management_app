// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Widgets/task_edition_dialog.dart';
import 'package:task_management_app/Widgets/Components/custom_buttons.dart';
import 'package:task_management_app/Widgets/Components/task_variables_editors.dart';
import 'package:uuid/uuid.dart';
import 'package:task_management_app/db_helper.dart';

var uuid = Uuid();

class ProjectSummaryCard extends StatefulWidget {
  final Task task;
  final VoidCallback onEdit;
  final DatabaseHelper dbHelper;

  const ProjectSummaryCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.dbHelper,
  });

  @override
  ProjectSummaryCardState createState() => ProjectSummaryCardState();
}

class ProjectSummaryCardState extends State<ProjectSummaryCard> {
  late TextEditingController _nameController;
  double _cardHeight = 300.0;
  final GlobalKey truc = GlobalKey();
  final Map<String, Task> _loadedTasks = {}; // Liste en mémoire pour les tâches chargées

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);

    // Charger les sous-tâches une fois à la création
    for (var subTaskId in widget.task.subTasksList) {
      widget.dbHelper.getTaskById(subTaskId).then((task) {
        if (task != null) {
          setState(() {
            _loadedTasks[subTaskId] = task;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleDeleteConfirmed(Task subTask, TaskProvider taskProvider) {
    setState(() {
      widget.task.subTasksList.remove(subTask.taskID);
      _loadedTasks.remove(subTask.taskID);
      taskProvider.updateTask(subTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) {
      throw Exception("Invalid BuildContext");
    }
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    var titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ColorEditor(
          initialColor: widget.task.accentColor,
          onColorChanged: (color) {
            setState(() {
              widget.task.updateColor(color);
              widget.dbHelper.updateTask(widget.task);
            });
          },
          size: Size(40, 40),
        ),
        Expanded(
          child: TextField(
            controller: _nameController,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter project name',
            ),
            textAlign: TextAlign.center,
            onSubmitted: (newValue) {
              setState(() {
                widget.task.updateName(newValue);
                taskProvider.updateTask(widget.task);
              });
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Theme.of(context).dividerColor),
          onPressed: widget.onEdit,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        return Consumer<TaskProvider>(
          builder: (context, value, child) {
            return Stack(
              children: [
                SizedBox(
                  width: 400,
                  height: _cardHeight,
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
                          Expanded(child: scrollableTasks(widget.dbHelper))
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: maxHeight - _cardHeight,
                  left: 0,
                  right: 0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (!isMobile()) {
                          setState(() {
                            _cardHeight = (_cardHeight + (details.primaryDelta ?? 0)).clamp(130.0, constraints.maxHeight);
                          });
                        }
                      },
                      onTap: () {
                        setState(() {
                          _cardHeight += 50; // Augmente la taille du widget lors du clic
                        });
                      },
                      child: Container(
                        height: 19,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(8.0), // Arrondir les bords avec un rayon de 8
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget scrollableTasks(DatabaseHelper dbHelper) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return Column(
      children: [
        SimpleButton(
          onPressed: () {
            setState(() {
              Task newTask = Task(
                name: "New task",
                accentColor: Colors.white.withAlpha(200),
                taskID: uuid.v4(),
                parentTaskID: widget.task.taskID,
                dbHelper: dbHelper,
              );
              widget.task.addSubTask(newTask);
              _loadedTasks[newTask.taskID] = newTask; // Ajoutez la nouvelle tâche à la mémoire
              taskProvider.updateTask(widget.task);
            });
          },
          backgroundColor: Theme.of(context).canvasColor,
          height: 30,
          width: double.infinity,
          borderRadius: BorderRadius.circular(8.0),
          child: Text('Add Task', style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: widget.task.subTasksList.isEmpty
              ? Center(child: Text('No task to display'))
              : ListView.builder(
                  itemCount: widget.task.subTasksList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Utilisez les tâches en mémoire si disponibles
                    Task? task = _loadedTasks[widget.task.subTasksList[index]];
                    if (task == null) {
                      // Chargez la tâche si elle n'est pas en mémoire
                      dbHelper.getTaskById(widget.task.subTasksList[index]).then((loadedTask) {
                        if (loadedTask != null) {
                          setState(() {
                            _loadedTasks[widget.task.subTasksList[index]] = loadedTask;
                          });
                        }
                      });
                      return Container(); // Retourne un conteneur vide en attendant le chargement
                    }
                    final TextEditingController subTaskController = TextEditingController(text: task.name);
                    final FocusNode _focusNode = FocusNode();

                    _focusNode.addListener(() {
                      if (!_focusNode.hasFocus) {
                        String text = subTaskController.text;
                        print("Text when focus lost: $text");
                        task.updateName(text);
                        taskProvider.updateTask(task);
                      }
                    });

                    return InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TaskEditDialog(task: task, dbHelper: dbHelper);
                          },
                        ).then((_) => setState(() {})); // Force update after dialog closes
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Focus(
                                focusNode: _focusNode,
                                child: TextField(
                                  controller: subTaskController,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    hintText: 'Task name',
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    isDense: true,
                                  ),
                                  maxLines: null,
                                  onSubmitted: (newValue) {
                                    print("Submitted new value: $newValue"); // Débogage
                                    setState(() {
                                      task.updateName(newValue);
                                      print("Task name updated to: ${task.name}"); // Débogage
                                      taskProvider.updateTask(task).then((_) {
                                        print("Task updated in database"); // Débogage
                                      }).catchError((error) {
                                        print("Error updating task: $error"); // Débogage
                                      });
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            statusButton(context, task),
                            DeleteButton(
                              onDeleteConfirmed: () => _handleDeleteConfirmed(task, taskProvider),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  bool isMobile() {
    return Theme.of(context).platform == TargetPlatform.iOS ||
           Theme.of(context).platform == TargetPlatform.android;
  }
}
