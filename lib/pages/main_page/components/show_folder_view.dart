import 'package:file_system_app/components/toggle_visibility.dart';
import 'package:file_system_app/models/file.dart';
import 'package:file_system_app/store/active_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../components/icon_font.dart';

class ShowFolderView extends ConsumerStatefulWidget {
  // the index in file list
  final int fileListIdx;

  const ShowFolderView({super.key, required this.fileListIdx});

  @override
  ConsumerState createState() => _ShowFolderViewState();
}

class _ShowFolderViewState extends ConsumerState<ShowFolderView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeFileProvider);
    // I have been validate fileObj type when I using ShowFolderView
    // so, that is real DirectoryType
    final DirectoryType fileObj = state.fileList[widget.fileListIdx] as DirectoryType;

    return GestureDetector(
      onTap: () {
        if (state.isMulSelectStatus) {
          // show Multiple selected and bottom badge
          ref.read(activeFileProvider.notifier).getMethods().onToggleFileSelected(widget.fileListIdx);
        } else {
          // 1.get router path
          String routerPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.queryParameters['path'] ?? '';

          // 2.splicing params
          routerPath += '\\${fileObj.name}';

          final uri = Uri(path: '/', queryParameters: { 'path': routerPath });
          context.go(uri.toString());
        }
      },
      onLongPress: () {
        if (!state.isMulSelectStatus) {
          ref.read(activeFileProvider.notifier).getMethods().onToggleMultiSelect();
        }
        // 展示 radio
        ref.read(activeFileProvider.notifier).getMethods().onToggleFileSelected(widget.fileListIdx);
      },
      child: Container(
        height: 80,
        color: fileObj.isSelected ? Color.fromRGBO(242, 249, 255, 1) : Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.asset('lib/assets/images/folder.png', width: 60, height: 60, fit: BoxFit.fill),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileObj.name, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Text(
                    '${fileObj.createTime} - ${fileObj.sonCount} 项',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            ToggleVisibility(
              visible: state.isMulSelectStatus,
              showChild: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Checkbox(
                  value: fileObj.isSelected,
                  onChanged: (value) {
                    ref.read(activeFileProvider.notifier).getMethods().onToggleFileSelected(widget.fileListIdx);
                  }
                ),
              ),
              hideChild: Padding(padding: EdgeInsets.only(left: 10), child: Icon(IconFont.arrowRight)),
            )
          ],
        ),
      ),
    );
  }
}

