import 'package:flutter/material.dart';
import 'package:macitor/src/models/text_file.dart';
import 'package:re_editor/re_editor.dart';

class FileView extends StatefulWidget {
  const FileView({super.key, required this.file});

  final TextFile file;

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView>  with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CodeEditor(
      controller: widget.file.currentData == null ? CodeLineEditingController.fromFile(widget.file.file) : CodeLineEditingController.fromText(widget.file.currentData),
      style: const CodeEditorStyle(textColor: Colors.white),
      onChanged: (value) {
        widget.file.currentData = value.codeLines.toList().join("\n");
      },
      indicatorBuilder:
          (context, editingController, chunkController, notifier) {
        return Row(
          children: [
            DefaultCodeLineNumber(
              controller: editingController,
              notifier: notifier,
              textStyle: const TextStyle(color: Colors.white24),
              focusedTextStyle: const TextStyle(color: Colors.white60),
            ),
            DefaultCodeChunkIndicator(
              width: 20,
              controller: chunkController,
              notifier: notifier,
            )
          ],
        );
      },
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
