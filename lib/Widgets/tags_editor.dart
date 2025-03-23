import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Providers/tags_provider.dart';

class TagEditorScreen extends StatefulWidget {
  final double heightRatio;

  const TagEditorScreen({super.key, this.heightRatio = 3});

  @override
  TagEditorScreenState createState() => TagEditorScreenState();
}

class TagEditorScreenState extends State<TagEditorScreen> {
  final List<String> _selectedTags = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  void _addTag(String tag) {
    if (!_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
      });
      _textController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  void _deleteAvailableTag(String tag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Tag'),
        content: Text('This action is irreversible. Do you want to delete this tag?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.redAccent.withAlpha(200)),
            ),
            onPressed: () {
              Provider.of<AvailableTags>(context, listen: false).removeTag(tag);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<String> _getSuggestions(String query) {
    return Provider.of<AvailableTags>(context).tags.where((tag) => tag.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tags", style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: _selectedTags.map((tag) {
            return Chip(
              label: Text(tag, style: Theme.of(context).textTheme.labelLarge),
              backgroundColor: Theme.of(context).canvasColor,
              deleteIcon: Icon(Icons.close),
              onDeleted: () => _removeTag(tag),
            );
          }).toList(),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _textController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: 'Type tags here',
            labelStyle: Theme.of(context).textTheme.bodyLarge,
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final text = _textController.text;
                if (text.isNotEmpty) {
                  _addTag(text);
                  Provider.of<AvailableTags>(context, listen: false).addTag(text);
                }
              },
            ),
          ),
          onChanged: (text) {
            setState(() {
             _isExpanded = _textController.text.isNotEmpty;
            }); // Trigger rebuild to show suggestions
          },
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isExpanded
              ? MediaQuery.of(context).size.height / widget.heightRatio
              : 0,
          width: double.infinity, // Largeur étendue
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.all(8.0),
          child: _isExpanded
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _getSuggestions(_textController.text).map((tag) {
                      return CustomButton(
                        label: Text(tag, style: Theme.of(context).textTheme.labelLarge),
                        onPressed: () {
                          _addTag(tag);
                          setState(() {
                            _isExpanded = _textController.text.isNotEmpty;
                          });
                        },
                        icon: Icon(Icons.delete),
                        onIconPressed: () => _deleteAvailableTag(tag),
                      );
                    }).toList(),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final Text label;
  final Icon icon;
  final VoidCallback onPressed;
  final VoidCallback onIconPressed;

  const CustomButton({super.key,
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
