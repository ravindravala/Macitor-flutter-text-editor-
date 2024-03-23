import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macitor/src/constant/app_color.dart';
import 'package:macitor/src/features/file_view.dart/view/file_view.dart';
import 'package:macitor/src/features/home_page/cubit/home_page_cubit.dart';
import 'package:macitor/src/models/text_file.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<HomePageCubit>(context, listen: false);
    
    return PlatformMenuBar(
      menus: [
        PlatformMenu(label: "apname", menus: [
          PlatformMenuItem(
              label: "About",
              onSelected: () {},
              shortcut: const CharacterActivator("A"))
        ]),
        PlatformMenu(label: "File", menus: [
          PlatformMenuItem(
            label: "Open File",
            onSelected: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['text', 'txt'],
              );
              if (result != null) {
                cubit.newFile(
                  textFile: TextFile(
                    file: File(result.files.first.path ?? ""),
                    name: result.files.first.name,
                  ),
                );
              }
            },
            shortcut: const CharacterActivator("o", meta: true),
          ),
          PlatformMenuItem(
            label: "Save File",
            onSelected: () async {
              cubit.saveFile();
            },
            shortcut: const CharacterActivator("s", meta: true),
          )
        ])
      ],
      child: CupertinoPageScaffold(
        backgroundColor: AppColor.background,
        child: BlocConsumer<HomePageCubit, HomePageState>(
          listener: (context, state) {},
          builder: (context, state) {
            log("UI Building");
            var data = state.allFiles;
            var selectedFileIndex = state.currentIndex;
            return Column(
              children: [
                Container(
                  color: AppColor.header,
                  height: 30,
                  padding: const EdgeInsets.only(left: 30, right: 10),
                  child: Row(children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) => GestureDetector(
                          onTap: () {
                            cubit.viewFile(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 120,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)
                              ),
                              color: index == selectedFileIndex
                                  ? AppColor.background
                                  : null,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      cubit.closeFile(index);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          cubit.newFile();
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ))
                  ]),
                ),
                Expanded(
                    child: _EditorView(
                  data: data,
                  cubit: cubit,
                ))
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EditorView extends StatefulWidget {
  const _EditorView({
    required this.data,
    required this.cubit,
  });

  final List<TextFile> data;
  final HomePageCubit cubit;

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.data.length,
      controller: widget.cubit.pageController,
      itemBuilder: (ctx, index) => FileView(file: widget.data[index]),
    );
  }
}
