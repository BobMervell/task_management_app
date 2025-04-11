import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Widgets/Components/text_editor.dart';
import 'package:task_management_app/Widgets/Components/tags_editor.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:task_management_app/Widgets/Components/task_variables_editors.dart';
import 'package:task_management_app/Widgets/Components/date_picker.dart';

/// A dialog widget for editing task details.
class TaskEditDialog extends StatefulWidget {
  final Task task;

  const TaskEditDialog({super.key, required this.task});

  @override
  TaskEditDialogState createState() => TaskEditDialogState();
}

/// State class for the TaskEditDialog widget.
class TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _nameController;
  late Color _accentColor;
  late QuillController _descriptionController;
  late List<String> _tags;
  late PriorityLevels _oldPriority;
  late Status _oldStatus;
  late DateTime _startDate;
  late DateTime _deadline;
  late Duration _estimatedDuration;
  late Duration _actualDuration;

  @override
  void initState() {
    super.initState();
    // Initialize the document for the Quill editor
    Document descriptionDoc = widget.task.description;
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = QuillController(
      document: descriptionDoc,
      selection: TextSelection.collapsed(offset: descriptionDoc.toPlainText().length.clamp(0, descriptionDoc.length - 1)),
    );
    _tags = List<String>.from(widget.task.tags);
    _startDate = widget.task.startDate;
    _deadline = widget.task.deadline;
    _accentColor = widget.task.accentColor;
    _oldStatus = widget.task.status;
    _oldPriority = widget.task.priority;
    _estimatedDuration = widget.task.estimatedDuration;
    _actualDuration = widget.task.actualDuration;
  }

  void _handleDeleteConfirmed() {
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    setState(() {
      Task parentTask = Task.getTaskById(widget.task.parentTaskID, taskProvider.tasks);
      parentTask.subTasksList.remove(widget.task);  
    });
    Navigator.of(context).pop(); // Close the edit dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(child: TitleEditor(controller: _nameController)),
                  SizedBox(width: 20),
                  DeleteButton(
                    onDeleteConfirmed: _handleDeleteConfirmed,
                  ),
                  SizedBox(width: 20),
                  ColorEditor(
                    initialColor: _accentColor,
                    onColorChanged: (color) {
                      setState(() {
                        _accentColor = color;
                      });
                    },
                    size: Size(40, 40),
                  ),
                ],
              ),
              SizedBox(height: 20),
              RichTextEditor(editorTitle: "Description", controller: _descriptionController),
              SizedBox(height: 20),
              TagEditorScreen(
                initialTags: _tags,
                onTagsChanged: (newTags) {
                  setState(() {
                    _tags = newTags;
                  });
                },
              ),
              SizedBox(height: 20),
              StatusEditor(task: widget.task),
              SizedBox(height: 20),
              PriorityEditor(task: widget.task),
              SizedBox(height: 20),
              DateTimePickerWidget(
                title: "Start",
                includeTime: true,
                initialDate: _startDate,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _startDate = dateTime!;
                  });
                },
              ),
              SizedBox(height: 20),
              DateTimePickerWidget(
                title: "Deadline",
                includeTime: true,
                initialDate: _deadline,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _deadline = dateTime!;
                  });
                },
              ),
              SizedBox(height: 20),
              SaveButton(
                task: widget.task,
                taskProvider: Provider.of<TaskProvider>(context, listen: false),
                nameController: _nameController,
                descriptionController: _descriptionController,
                tags: _tags,
                accentColor: _accentColor,
                startDate: _startDate,
                deadline: _deadline,
              ),
              SizedBox(height: 8),
              CancelButton(
                task: widget.task,
                oldStatus: _oldStatus,
                oldPriority: _oldPriority,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/// Creates a button to save the edited task details.
class SaveButton extends StatelessWidget {
  final Task task;
  final TaskProvider taskProvider;
  final TextEditingController nameController;
  final QuillController descriptionController;
  final List<String> tags;
  final Color accentColor;
  final DateTime startDate;
  final DateTime deadline;

  const SaveButton({
    super.key,
    required this.task,
    required this.taskProvider,
    required this.nameController,
    required this.descriptionController,
    required this.tags,
    required this.accentColor,
    required this.startDate,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        task.updateName(nameController.text);
        task.updateDescription(descriptionController.document);
        task.updateTags(tags);
        task.updateColor(accentColor);
        task.updateStartDate(startDate);
        task.updateDeadline(deadline);
        taskProvider.updateTask(task);
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text('Save'),
    );
  }
}

/// Creates a button to cancel the editing of the task.
class CancelButton extends StatelessWidget {
  final Task task;
  final Status oldStatus;
  final PriorityLevels oldPriority;

  const CancelButton({
    super.key,
    required this.task,
    required this.oldStatus,
    required this.oldPriority,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        task.status.updateStatus(oldStatus.statusType);
        task.updatePriority(oldPriority);
        Navigator.of(context).pop();
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.red.withAlpha(150),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text('Cancel'),
    );
  }
}
