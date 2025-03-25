import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextEditor extends StatefulWidget {
  final String editorTitle;
  final QuillController controller;

  const RichTextEditor({
    super.key,
    required this.editorTitle,
    required this.controller,
    });


  @override
  RichTextEditorState createState() => RichTextEditorState();
}

class RichTextEditorState extends State<RichTextEditor> with SingleTickerProviderStateMixin {
  final double heightRatio;
  bool _isToolbarVisible = false;
  late AnimationController _heightAnimationController;
  late Animation<double> _heightAnimation;
  RichTextEditorState({
    this.heightRatio = 3,
  });

  
@override
  void initState() {
    super.initState();
    _heightAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 0.0, end: 40.0).animate(
      CurvedAnimation(parent: _heightAnimationController, curve: Curves.easeInOut),
    );
    if (_isToolbarVisible) {
      _heightAnimationController.forward();
    }
  }

  void _toggleToolbar() {
    setState(() {
      _isToolbarVisible = !_isToolbarVisible;
      if (_isToolbarVisible) {
        _heightAnimationController.forward();
      } else {
        _heightAnimationController.reverse();
      }
    });
  }


  QuillSimpleToolbarConfig toolbarConfig(BuildContext context) {
    return QuillSimpleToolbarConfig(
    showFontFamily: false,
    showLineHeightButton: true,
    showClearFormat: false,
    showAlignmentButtons: true,
    showSearchButton: false,
    showInlineCode: false,
    showQuote: false,
    showListBullets: false,
    showUndo: false,
    showRedo: false,
    sectionDividerColor: Theme.of(context).dividerColor,
  );
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.editorTitle,style:Theme.of(context).textTheme.headlineSmall,),
            IconButton(
              icon: Icon(_isToolbarVisible ? Icons.expand_less : Icons.expand_more),
              onPressed: () { _toggleToolbar();},
            ),
          ],
        ),
        animatedToolbarContainer(context),
        textEditorContainer(context),
      ],
    );
  }

  AnimatedBuilder animatedToolbarContainer(BuildContext context) {
    return AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          return Container(
            alignment: Alignment.bottomLeft,
            height: _heightAnimation.value,
            child: child,
          );
        },
        child: QuillSimpleToolbar(
          controller: widget.controller,
          config: toolbarConfig(context),
        ),
      );
  }

  Container textEditorContainer(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color:Theme.of(context).dividerColor ,
            width: 2.0
          ),
        ),
        child: Row(
          children: [
            Flexible(
              child: QuillEditor.basic(
                controller: widget.controller,
                scrollController: ScrollController(),
                focusNode: FocusNode(),
                config : QuillEditorConfig(
                  minHeight: MediaQuery.of(context).size.height/heightRatio ,
                  maxHeight: 3 * MediaQuery.of(context).size.height/heightRatio ,
                  padding: EdgeInsets.all(8)
                ),
              ),
            ),
          ],
        ),
      );
  }
}

