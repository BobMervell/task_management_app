import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Widgets/color_picker.dart';
import 'package:task_management_app/Widgets/text_editor.dart';
import 'package:task_management_app/Widgets/tags_editor.dart';
import 'package:task_management_app/Widgets/task_summary_card.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'test_widget.dart';


class TaskEditDialog extends StatefulWidget {
  final Task task;

  const TaskEditDialog({super.key, required this.task});

  @override
  TaskEditDialogState createState() => TaskEditDialogState();
}

class TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _nameController;
  late Color _accentColor;
  late quill.QuillController _descriptionController;
  late List<String> _tags;
  late PriorityLevels _oldPriority;
  late Status _oldStatus;
  late DateTime _startDate;
  late DateTime _deadline;
/*   late Duration _estimatedDuration;
  late Duration _actualDuration; */

  @override
  void initState() {
    super.initState();
    quill.Document descriptionDoc = widget.task.description;
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = quill.QuillController(
      document: descriptionDoc,
      selection: TextSelection.collapsed(offset: descriptionDoc.toPlainText().length.clamp(0,descriptionDoc.length-1))
      );
    _tags = List<String>.from(widget.task.tags);
    _startDate = widget.task.startDate;
    _deadline = widget.task.deadline;
    _accentColor = widget.task.accentColor;
    _oldStatus = widget.task.status;
    _oldPriority = widget.task.priority;
/*     _estimatedDuration = widget.task.estimatedDuration;
    _actualDuration = widget.task.actualDuration; */
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
                  Expanded(child: editableText(context, _nameController, "Name")),
                  SizedBox(width: 20),
                  ElevatedButton(
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
                  ),
                ],
              ),
              SizedBox(height: 20),
              RichTextEditor(editorTitle: "Description",controller: _descriptionController),
              SizedBox(height: 20),
              TagEditorScreen(initialTags: widget.task.tags, tags: _tags, onTagsChanged: (newTags) {
                setState(() {
                  _tags = newTags;
                });
              }),
              SizedBox(height: 20),
              statusEditor(context, widget.task),
              SizedBox(height: 20),
              priorityEditor(context, widget.task),
              SizedBox(height: 20),
              DateTimePickerWidget(
                title: "Start",
                includeTime: true, // Définir sur false si vous ne voulez pas inclure l'heure
                initialDate: widget.task.startDate,
                onDateTimeChanged: (DateTime? dateTime) {
                  _startDate = dateTime!;
                },
              ),
              SizedBox(height: 20,),
               DateTimePickerWidget(
                title: "Due",
                includeTime: true, // Définir sur false si vous ne voulez pas inclure l'heure
                initialDate: widget.task.deadline,
                onDateTimeChanged: (DateTime? dateTime) {
                  _deadline = dateTime!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
              ),
              SizedBox(height: 8,),
              TextButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField editableText(BuildContext context, TextEditingController textController, String titleString) {
    return TextField(
      cursorColor: Theme.of(context).dividerColor,
      controller: textController,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: titleString,
      ),
    );
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
}