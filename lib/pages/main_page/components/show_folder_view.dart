import 'package:file_system_app/store/active_file.dart';
import 'package:file_system_app/store/file_store.dart';
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
    final fileObj = state.fileList[widget.fileListIdx];

    return GestureDetector(
      onTap: () {
        // if (widget.isShowRadio) {
        //   widget.onChangeSelected(widget.idx, !widget.fileObj['selected']);
        // } else {

        // }

        if (state.isMulSelectStatus) {
          // show Multiple selected and bottom badge
        } else {
          // 1.get router path
          String routerPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.queryParameters['path'] ?? '';

          // 2.splicing params
          routerPath += '\\${fileObj['name']}';

          final uri = Uri(path: '/', queryParameters: { 'path': routerPath });
          context.go(uri.toString());
        }
      },
      onLongPress: () {
        if (!state.isMulSelectStatus) {
          ref.read(activeFileProvider).copyWith(isMulSelectStatus: true);
        }
        // // 展示 radio
        // widget.onChangeSelected(widget.idx, !widget.fileObj['selected']);
      },
      child: Container(
        height: 80,
        color: fileObj['selected'] ? Color.fromRGBO(242, 249, 255, 1) : Theme.of(context).primaryColor,
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
                  Text(fileObj['name'] ?? '-', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Text(
                    '${fileObj['createTime']} - ${fileObj['sonCount']} 项',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: state.isMulSelectStatus,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child:  Visibility(
                  visible: state.isMulSelectStatus,
                  child: Checkbox(
                    value: fileObj['selected'],
                    onChanged: (value) {
                      // widget.onChangeSelected(widget.idx, value!)
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: state.isMulSelectStatus,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(IconFont.arrowRight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

