import 'package:flutter/material.dart';
import 'package:task_management_app/Widgets/Components/color_picker.dart';
import 'package:task_management_app/Widgets/Components/custom_buttons.dart';
import 'package:task_management_app/Models/task.dart';



/// Creates a text field for editing the task name.
class TitleEditor extends StatelessWidget {
  final TextEditingController controller;

  const TitleEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).dividerColor,
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: "Name",
      ),
    );
  }
}

/// Creates a button for selecting the task's accent color.
class ColorEditor extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final Size? size; // Ajout d'un paramètre optionnel pour la taille

  const ColorEditor({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
    this.size, // La taille est optionnelle
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: initialColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: size, // Utilise la taille si elle est fournie
        maximumSize: size, // Utilise la taille si elle est fournie
      ).merge(
        ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return initialColor.withAlpha(45);
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
              onColorSelected: onColorChanged,
            );
          },
        );
      },
      child: Container(),
    );
  }
}


/// Creates a row widget for editing the task's status.
class StatusEditor extends StatelessWidget {
  final Task task;

  const StatusEditor({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Status: ", style: Theme.of(context).textTheme.headlineSmall),
        statusButton(context, task),
      ],
    );
  }
}

/// Creates a row widget for editing the task's priority.
class PriorityEditor extends StatelessWidget {
  final Task task;

  const PriorityEditor({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Priority: ", style: Theme.of(context).textTheme.headlineSmall),
        priorityButton(context, task),
      ],
    );
  }
}