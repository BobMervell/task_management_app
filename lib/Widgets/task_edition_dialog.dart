import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Widgets/Components/color_picker.dart';
import 'package:task_management_app/Widgets/Components/text_editor.dart';
import 'package:task_management_app/Widgets/Components/tags_editor.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'Components/date_picker.dart';
import 'package:task_management_app/Widgets/Components/custom_buttons.dart';

/// A dialog widget for editing task details.
///
/// This widget allows users to edit various properties of a task, such as name, description, tags, status, priority, and dates.
class TaskEditDialog extends StatefulWidget {
  final Task task;

  const TaskEditDialog({super.key, required this.task});

  @override
  TaskEditDialogState createState() => TaskEditDialogState();
}

/// State class for the TaskEditDialog widget.
///
/// Manages the state of the task being edited, including text controllers, colors, and other properties.
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

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);

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
                  Expanded(child: titleEditor(context, _nameController, "Name")),
                  SizedBox(width: 20),
                  colorEditor(context),
                ],
              ),
              SizedBox(height: 20),
              RichTextEditor(editorTitle: "Description", controller: _descriptionController),
              SizedBox(height: 20),
              tagsEditor(),
              SizedBox(height: 20),
              statusEditor(context, widget.task),
              SizedBox(height: 20),
              priorityEditor(context, widget.task),
              SizedBox(height: 20),
              startDateEditor(),
              SizedBox(height: 20),
              deadlineDateEditor(),
              SizedBox(height: 20),
              saveButton(taskProvider, context),
              SizedBox(height: 8),
              cancelButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a text field for editing the task name.
  TextField titleEditor(BuildContext context, TextEditingController textController, String titleString) {
    return TextField(
      cursorColor: Theme.of(context).dividerColor,
      controller: textController,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: titleString,
      ),
    );
  }

  /// Creates a button for selecting the task's accent color.
  ElevatedButton colorEditor(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ).merge(
        ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return _accentColor.withAlpha(45);
              }
              return Colors.transparent;
            },
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return BorderSide(color: Theme.of(context).dividerColor, width: 1.0);
              }
              return BorderSide.none;
            },
          ),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ColorPickerDialog(
              onColorSelected: (Color color) {
                setState(() {
                  _accentColor = color;
                });
              },
            );
          },
        );
      },
      child: Container(),
    );
  }

  /// Creates a textfield for editing the task's tags.
  TagEditorScreen tagsEditor() {
    return TagEditorScreen(
      initialTags: widget.task.tags,
      onTagsChanged: (newTags) {
        setState(() {
          _tags = newTags;
        });
      },
    );
  }

  /// Creates a row widget for editing the task's status.
  Row statusEditor(BuildContext context, Task task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Status: ", style: Theme.of(context).textTheme.headlineSmall),
        statusButton(context, task),
      ],
    );
  }

  /// Creates a row widget for editing the task's priority.
  Row priorityEditor(BuildContext context, Task task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Priority: ", style: Theme.of(context).textTheme.headlineSmall),
        priorityButton(context, task),
      ],
    );
  }

  /// Creates a date picker widget for editing the task's start date.
  DateTimePickerWidget startDateEditor() {
    return DateTimePickerWidget(
      title: "Start",
      includeTime: true,
      initialDate: widget.task.startDate,
      onDateTimeChanged: (DateTime? dateTime) {
        setState(() {
          _startDate = dateTime!;
        });
      },
    );
  }

  /// Creates a date picker widget for editing the task's deadline.
  DateTimePickerWidget deadlineDateEditor() {
    return DateTimePickerWidget(
      title: "Deadline",
      includeTime: true,
      initialDate: widget.task.deadline,
      onDateTimeChanged: (DateTime? dateTime) {
        setState(() {
          _deadline = dateTime!;
        });
      },
    );
  }

  /// Creates a button to save the edited task details.
  ElevatedButton saveButton(TaskProvider taskProvider, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.task.updateName(_nameController.text);
        widget.task.updateDescription(_descriptionController.document);
        widget.task.updateTags(_tags);
        widget.task.updateColor(_accentColor);
        widget.task.updateStartDate(_startDate);
        widget.task.updateDeadline(_deadline);
        taskProvider.updateTask(widget.task);
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

  /// Creates a button to cancel the editing of the task.
  TextButton cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.task.status.updateStatus(_oldStatus.statusType);
        widget.task.updatePriority(_oldPriority);
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
