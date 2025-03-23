import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class RichTextEditor extends StatefulWidget {

  final String editorTitle;

  const RichTextEditor({
    super.key,
    this.editorTitle = "",
    });


  @override
  RichTextEditorState createState() => RichTextEditorState();
}

class RichTextEditorState extends State<RichTextEditor> with SingleTickerProviderStateMixin {
  final quill.QuillController _controller = quill.QuillController.basic();
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


  quill.QuillSimpleToolbarConfig toolbarConfig(BuildContext context) {

  return quill.QuillSimpleToolbarConfig(
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
        AnimatedBuilder(
          animation: _heightAnimation,
          builder: (context, child) {
            return Container(
              alignment: Alignment.bottomLeft,
              height: _heightAnimation.value,
              child: child,
            );
          },
          child: quill.QuillSimpleToolbar(
            controller: _controller,
            config: toolbarConfig(context),
          ),
        ),

        Container(
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
                child: quill.QuillEditor.basic(
                  controller: _controller,
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                  config : quill.QuillEditorConfig(
                    minHeight: MediaQuery.of(context).size.height/heightRatio ,
                    maxHeight: MediaQuery.of(context).size.height/heightRatio ,
                    padding: EdgeInsets.all(8)
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

