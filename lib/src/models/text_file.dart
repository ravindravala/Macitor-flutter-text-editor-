import 'dart:io';

class TextFile {
  String name;
  File file;
  String? currentData;

  bool get isTempFile => file.path.contains("temp_untitled_file");

  TextFile({this.name = "Untitled", required this.file, this.currentData});
}
