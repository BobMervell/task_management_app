import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Models/task_data.dart';
import 'package:task_management_app/Models/task.dart';
import 'package:task_management_app/Providers/task_provider.dart';
import 'package:task_management_app/Themes/app_themes.dart';
import 'package:task_management_app/Widgets/color_picker.dart';
import 'package:task_management_app/Widgets/text_editor.dart';
import 'package:task_management_app/Widgets/tags_editor.dart';


class TaskEditDialog extends StatefulWidget {
  final Task task;

  const TaskEditDialog({super.key, required this.task});

  @override
  TaskEditDialogState createState() => TaskEditDialogState();
}

class TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _summaryController;
  late TextEditingController _tagsController;
  late DateTime _startDate;
  late DateTime _deadline;
  late Color _accentColor;
  late Status _status;
  late PriorityLevels _priority;
  late Duration _estimatedDuration;
  late Duration _actualDuration;
  final bool _isNameHovered = false;
  final bool _isDescriptionHovered = false;
  final bool _isTagsHovered = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _summaryController = TextEditingController(text: widget.task.summary);
    _tagsController = TextEditingController(text: widget.task.tags);
    _startDate = widget.task.startDate;
    _deadline = widget.task.deadline;
    _accentColor = widget.task.accentColor;
    _status = widget.task.status;
    _priority = widget.task.priority;
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
                  Expanded(child: editableText(context,_nameController,"Name")),
                  SizedBox(width: 20),
                 ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor, // Couleur d'accentuation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Bordures légèrement arrondies
                      ),
                    ).merge(
                      ButtonStyle(
                        overlayColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return _accentColor.withAlpha(45); // Couleur de survol
                            }
                            return Colors.transparent;
                          },
                        ),
                        side: WidgetStateProperty.resolveWith<BorderSide>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return BorderSide(color: Theme.of(context).dividerColor, width: 1.0); // Bordure au survol
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
                              _accentColor = color;
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                    child: Container(), // Conteneur vide pour remplacer le texte
                  )
                ],
              ),
              
              SizedBox(height: 20),
              RichTextEditor(editorTitle: "Summary",),
              SizedBox(height: 20),
              TagEditorScreen(),
              SizedBox(height: 20),
              SizedBox(height: 20),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.task.updateName(_nameController.text);
                  widget.task.updateSummary(_summaryController.text);
                  widget.task.updateAssignee(_tagsController.text);
                  taskProvider.updateTask(widget.task);
                  // Update other attributes as needed
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField editableText(BuildContext context,TextEditingController textController, String titleString) {
    return TextField(
        cursorColor: Theme.of(context).dividerColor,
        controller: textController,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: titleString,
        ),
      );
  }

}


