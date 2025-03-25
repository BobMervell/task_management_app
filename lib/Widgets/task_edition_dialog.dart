import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Widgets/Components/color_picker.dart';
import 'package:task_management_app/Widgets/text_editor.dart';
import 'package:task_management_app/Widgets/tags_editor.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'test_widget.dart';
import 'package:task_management_app/Widgets/Components/custom_buttons.dart';


class TaskEditDialog extends StatefulWidget {
  final Task task;

  const TaskEditDialog({super.key, required this.task});

  @override
  TaskEditDialogState createState() => TaskEditDialogState();
}

class TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _nameController;
  late Color _accentColor;
  late QuillController _descriptionController;
  late List<String> _tags;
  late PriorityLevels _oldPriority;
  late Status _oldStatus;
  late DateTime _startDate;
  late DateTime _deadline;
  //TO DO
  late Duration _estimatedDuration;
  late Duration _actualDuration;

  @override
  void initState() {
    super.initState();
    Document descriptionDoc = widget.task.description;
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = QuillController(
      document: descriptionDoc,
      selection: TextSelection.collapsed(offset: descriptionDoc.toPlainText().length.clamp(0,descriptionDoc.length-1))
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
              RichTextEditor(editorTitle: "Description",controller: _descriptionController),
              SizedBox(height: 20),
              tagsEditor(),
              SizedBox(height: 20),
              statusEditor(context, widget.task),
              SizedBox(height: 20),
              priorityEditor(context, widget.task),
              SizedBox(height: 20),
              startDateEditor(),
              SizedBox(height: 20,),
              deadlineDateEditor(),
              SizedBox(height: 20),
              saveButton(taskProvider, context),
              SizedBox(height: 8,),
              cancelButton(context),
            ],
          ),
        ),
      ),
    );
  }

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

  TagEditorScreen tagsEditor() {
    return TagEditorScreen(
              initialTags: widget.task.tags,
              tags: _tags, onTagsChanged: (newTags) {
              setState(() {
                _tags = newTags;
              });
            });
  }

  Row statusEditor(BuildContext context, Task task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Status: ", style: Theme.of(context).textTheme.headlineSmall),
        statusButton(context, task),
      ],
    );
  }

  Row priorityEditor(BuildContext context, Task task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Priority: ", style: Theme.of(context).textTheme.headlineSmall),
        priorityButton(context, task),
      ],
    );
  }

  DateTimePickerWidget startDateEditor() {
    return DateTimePickerWidget(
              title: "Start",
              includeTime: true, // Définir sur false si vous ne voulez pas inclure l'heure
              initialDate: widget.task.startDate,
              onDateTimeChanged: (DateTime? dateTime) {
                _startDate = dateTime!;
              },
            );
  }

  DateTimePickerWidget deadlineDateEditor() {
    return DateTimePickerWidget(
              title: "Deadline",
              includeTime: true, // Définir sur false si vous ne voulez pas inclure l'heure
              initialDate: widget.task.deadline,
              onDateTimeChanged: (DateTime? dateTime) {
                _deadline = dateTime!;
              },
            );
  }

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
                //status and priority button already independantly update task
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