import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macitor/src/models/text_file.dart';
import 'package:path_provider/path_provider.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState([], 0)) {
    _intHomePage();
  }

  PageController pageController = PageController();

  void _intHomePage() async {
    var file = await _generateFile();
    emit(state.copyWith([TextFile(file: file)], 0));
  }

  void newFile({TextFile? textFile}) async {
    late TextFile newFile;

    if (textFile == null) {
      var file = await _generateFile();
      newFile = TextFile(file: file);
    } else {
      newFile = textFile;
    }
    emit(state.copyWith(
        state.allFiles..add(newFile), state.allFiles.length - 1));
    _changeFileView(state.allFiles.length - 1);
  }

  void closeFile(int index) {
    var data = state.allFiles;

    data.removeAt(index);
    var selectedFileIndex = state.currentIndex;
    selectedFileIndex = data.length - 1;

    _changeFileView(selectedFileIndex);
    emit(state.copyWith(data, selectedFileIndex));
  }

  void viewFile(
    int index,
  ) {
    final data = state.allFiles;
    final selectedFileIndex = index;
    _changeFileView(index);
    emit(state.copyWith(data, selectedFileIndex));
  }

  void saveFile() async {
    var targetFile = state.allFiles[state.currentIndex];
    log(targetFile.isTempFile.toString());
    if (targetFile.isTempFile) {
      String? selectedDirectory = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'untitled.text',
      );
      if (selectedDirectory != null) {
        var file = File(selectedDirectory);
        await file.writeAsString(targetFile.currentData ?? "");
        targetFile.file = file;
        var nameData = file.path.split("/");
        targetFile.name = nameData.last;
        log("viF");
        emit(state.copyWith(state.allFiles, 0));
      }
    } else {
      targetFile.file.writeAsString(targetFile.currentData ?? "");
    }
  }

  // HELPER

  void _changeFileView(int index) {
    pageController.jumpToPage(index);
  }

  Future<File> _generateFile() async {
    final Directory directory = await getTemporaryDirectory();
    final File file = File(
        '${directory.path}/${DateTime.now().microsecondsSinceEpoch}_temp_untitled_file.txt');
    await file.writeAsString("");
    return file;
  }
}
