import 'package:file_system_app/store/active_file.dart';
import 'package:file_system_app/store/file_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/common.dart';

enum PhotoRadioValues { alone, all, recursionAll, undefined }

class ShowFileView extends ConsumerStatefulWidget {
  // the index in file list
  final int fileListIdx;

  const ShowFileView({super.key, required this.fileListIdx});

  @override
  ConsumerState createState() => _ShowFileViewState();
}

class _ShowFileViewState extends ConsumerState<ShowFileView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeFileProvider);
    final Map<String, dynamic> fileObj = state.fileList[widget.fileListIdx];

    return GestureDetector(
      onTap: () {
        // if (state.isMulSelectStatus) {
        //   state.fileList[widget.fileListIdx]['selected'] = true;
        //   ref.read(fileStoreProvider).copyWith(fileList: state.fileList);
        // }
      },
      onLongPress: () {
        // 展示 badge
        // if (!state.isMulSelectStatus) {
        //   ref.read(fileStoreProvider).copyWith(isMulSelectStatus: true);
        // }
      },
      child: Container(
        height: 80,
        color: fileObj['selected'] ? Color.fromRGBO(242, 249, 255, 1) : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          spacing: 10,
          children: [
            Image.asset('lib/assets/images/file.png', width: 60, height: 60, fit: BoxFit.fill),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileObj['name'], style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Text(
                    '${fileObj['createTime']} - ${fileObj['size']}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: state.isMulSelectStatus,
              child: Checkbox(
                value: fileObj['selected'],
                onChanged: (value) {
                  // state.fileList[widget.fileListIdx]['selected'] = value;
                  // ref.read(fileStoreProvider).copyWith(fileList: state.fileList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
