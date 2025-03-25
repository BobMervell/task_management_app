import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/Providers/tags_provider.dart';
import 'package:task_management_app/Widgets/Components/custom_buttons.dart';

/// A screen widget for editing and managing tags.
///
/// This widget allows users to add, remove, and select tags from a list of available tags.
class TagEditorScreen extends StatefulWidget {
  final double heightRatio;
  final List<String> initialTags;
  final ValueChanged<List<String>> onTagsChanged;

  const TagEditorScreen({
    super.key,
    this.heightRatio = 3,
    required this.initialTags,
    required this.onTagsChanged,
  });

  @override
  TagEditorScreenState createState() => TagEditorScreenState();
}

/// State class for the TagEditorScreen widget.
///
/// Manages the state of selected tags and handles tag addition, removal, and suggestions.
class TagEditorScreenState extends State<TagEditorScreen> {
  late List<String> _selectedTags;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedTags = List<String>.from(widget.initialTags);
  }

  /// Adds a new tag to the list of selected tags.
  void _addTag(String tag) {
    if (!_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        widget.onTagsChanged(_selectedTags);
      });
      _textController.clear();
    }
  }

  /// Removes a tag from the list of selected tags.
  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
      widget.onTagsChanged(_selectedTags);
    });
  }

  /// Deletes a tag from the list of available tags.
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
              backgroundColor: MaterialStateProperty.all(Colors.redAccent.withAlpha(200)),
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

  /// Gets a list of suggested tags based on the user's input.
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
        // Title
        Text("Tags", style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8.0),
        wrapSelectedTags(context),
        SizedBox(height: 8.0),
        inputField(context),
        animatedTagsContainer(context),
      ],
    );
  }

  /// Wraps the selected tags in a Wrap widget with Chips.
  Wrap wrapSelectedTags(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: _selectedTags.map((tag) {
        return Chip(
          label: Text(tag, style: Theme.of(context).textTheme.labelLarge),
          backgroundColor: Theme.of(context).canvasColor,
          deleteIcon: Icon(Icons.close),
          onDeleted: () => _removeTag(tag),
        );
      }).toList(),
    );
  }

  /// Creates a text field for entering new tags.
  TextField inputField(BuildContext context) {
    return TextField(
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
              _isExpanded = false;
              _addTag(text);
              Provider.of<AvailableTags>(context, listen: false).addTag(text);
            }
          },
        ),
      ),
      onChanged: (text) {
        setState(() {
          _isExpanded = text.isNotEmpty;
        }); // Trigger rebuild to show suggestions
      },
    );
  }

  /// Creates an animated container for displaying tag suggestions.
  AnimatedContainer animatedTagsContainer(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded
          ? MediaQuery.of(context).size.height / widget.heightRatio
          : 0,
      width: double.infinity, // Full width
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(8.0),
      child: _isExpanded ? scrollTagsContainer(context) : null,
    );
  }

  /// Creates a scrollable container for displaying tag suggestions.
  SingleChildScrollView scrollTagsContainer(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _getSuggestions(_textController.text).map((tag) {
          return DualActionButton(
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
    );
  }
}
