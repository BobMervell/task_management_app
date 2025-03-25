import 'package:flutter/material.dart';

class DualActionButton extends StatelessWidget {
  final Text label;
  final Icon icon;
  final VoidCallback onPressed;
  final VoidCallback onIconPressed;

  const DualActionButton({super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: label,
                ),
                IconButton(
                  icon: icon,
                  onPressed: onIconPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
