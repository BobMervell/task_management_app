import 'package:flutter/material.dart';

/// A dialog widget for picking a color from a predefined list.
///
/// This widget displays a grid of color options and allows the user to select one.
class ColorPickerDialog extends StatefulWidget {
  final Function(Color) onColorSelected;

  const ColorPickerDialog({super.key, required this.onColorSelected});

  @override
  ColorPickerDialogState createState() => ColorPickerDialogState();
}

/// State class for the ColorPickerDialog widget.
///
/// Manages the list of available colors and handles color selection.
class ColorPickerDialogState extends State<ColorPickerDialog> {
  // List of available colors with reduced opacity
  final List<Color> _availableColors = [
    Colors.black.withAlpha(200),
    Colors.grey.withAlpha(200),
    Colors.white.withAlpha(200),
    Colors.red.withAlpha(200),
    Colors.orange.withAlpha(200),
    Colors.yellow.withAlpha(200),
    Colors.green.withAlpha(200),
    Colors.blue.withAlpha(200),
    Colors.indigo.withAlpha(200),
    Colors.purple.withAlpha(200),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick a Color'),
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: SizedBox(
        width: 200,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: _availableColors.length,
          itemBuilder: (context, index) {
            Color color = _availableColors[index];
            return colorButton(color, context);
          },
        ),
      ),
    );
  }

  /// Creates a button for each color option.
  ///
  /// The button changes appearance on hover and selects the color when pressed.
  ElevatedButton colorButton(Color color, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shadowColor: Colors.black, // Shadow color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(8.0),
      ).merge(
        ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return color.withAlpha(255); // Hover color
              }
              return Colors.transparent;
            },
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return 8; // Increased elevation on hover
              }
              return 3;
            },
          ),
        ),
      ),
      onPressed: () {
        widget.onColorSelected(color);
        Navigator.of(context).pop();
      },
      child: Container(),
    );
  }
}
