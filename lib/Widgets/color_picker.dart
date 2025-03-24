import 'package:flutter/material.dart';


class ColorPickerDialog extends StatefulWidget {
  final Function(Color) onColorSelected;

  const ColorPickerDialog({super.key, required this.onColorSelected});

  @override
  ColorPickerDialogState createState() => ColorPickerDialogState();
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? _selectedColor;

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
      title: Text('Choose a Color'),
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: SizedBox(
        width: 200.0, 
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
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shadowColor: Colors.black, // Couleur de l'ombre
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // Style pour l'état survolé
                padding: EdgeInsets.all(8.0),
              ).merge(
                ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return color.withAlpha(255); // Couleur de survol
                      }
                      return Colors.transparent;
                    },
                  ),
                  elevation: WidgetStateProperty.resolveWith<double>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return 8; // Élévation accrue lors du survol
                      }
                      return 3;
                    },
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedColor = color; // Met à jour la couleur sélectionnée
                });
              },
              child: Container(),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Ferme le dialogue sans sauvegarder
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedColor != null) {
              widget.onColorSelected(_selectedColor!); // Appelle le callback avec la couleur sélectionnée
            }
            Navigator.of(context).pop(); // Ferme le dialogue
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

