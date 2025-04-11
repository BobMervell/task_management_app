import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Widgets/task_edition_dialog.dart';
import 'package:task_management_app/Widgets/Components/custom_buttons.dart';
import 'package:task_management_app/Widgets/Components/task_variables_editors.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
class ProjectSummaryCard extends StatefulWidget {
  final Task task;
  final VoidCallback onEdit;

  const ProjectSummaryCard({
    super.key,
    required this.task,
    required this.onEdit,
  });

  @override
  ProjectSummaryCardState createState() => ProjectSummaryCardState();
}

class ProjectSummaryCardState extends State<ProjectSummaryCard> {
  late TextEditingController _nameController;
  double _cardHeight = 300.0;
  final GlobalKey truc = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleDeleteConfirmed(Task subTask) {
    setState(() {
      widget.task.subTasksList.remove(subTask);  
    });
  }


  @override
  Widget build(BuildContext context) {
    var titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ColorEditor(
          initialColor: widget.task.accentColor,
          onColorChanged: (color) {
            setState(() {
              widget.task.accentColor = color;
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
                widget.task.name = newValue;
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
                          Expanded(child: scrollableTasks())
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

  Widget scrollableTasks() {
    return Column(
      children: [
        SimpleButton(
          onPressed: () {
            setState(() {
              widget.task.addSubTask(Task(
                name: "New task",
                accentColor: Colors.white.withAlpha(200),
                taskID: uuid.v4(),
                parentTaskID: widget.task.taskID,
              ));
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
                    final subTask = widget.task.subTasksList[index];
                    final TextEditingController subTaskController = TextEditingController(text: subTask.name);
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
                            return TaskEditDialog(task: subTask);
                          },
                        ).then((_) => setState(() {})); // Force update after dialog closes
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: subTaskController,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  hintText: 'Task name',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Réduit le padding vertical
                                  isDense: true, // Réduit le padding interne
                                ),
                                maxLines: null, // Permet au texte de s'étendre sur plusieurs lignes
                                onSubmitted: (newValue) {
                                  setState(() {
                                    subTask.name = newValue;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8.0),
                            statusButton(context, subTask),
                            DeleteButton(
                              onDeleteConfirmed: () => _handleDeleteConfirmed(subTask),
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


