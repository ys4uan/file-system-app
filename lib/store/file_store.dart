import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:file_system_app/api/file.dart';
import 'package:file_system_app/models/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_store.g.dart';

@riverpod
class FileStore extends _$FileStore {
  @override
  CustomFiles build(String path) {
    Future.microtask(() {
      _getList();
    });

    return CustomFiles.init(curPath: path);
  }

  /// 获取文件列表
  void _getList() async {
    state = state.copyWith(getFileStatus: OperationState.loading());

    final String finalPath = '${state.basicPath}${state.curPath}';
    final res = await getFileList(finalPath);

    if (res.statusCode == 200 && res.data['statusCode'] == 200) {
      List<Map<String, dynamic>> myData = (res.data['data'] as List).cast<Map<String, dynamic>>();
      List<BasicFileType> realDate = myData.map((item) {
        item['createTime'] = formatDate(DateTime.parse(item['createTime']), [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm]);

        return ConvertFileType.fromJson(item);
      }).toList();

      state = state.copyWith(fileList: realDate);
    }

    state = state.copyWith(getFileStatus: OperationState.complete());
  }

  /// 删除/批量删除 文件、目录
  void delFiles() async {
    state = state.copyWith(delFileStatus: OperationState.loading());
    List<String> selectedFilesFullPathList = [];
    for (var item in state.fileList) {
      if (item.isSelected) selectedFilesFullPathList.add(item.fullPath);
    }
    late Response res;

    if (selectedFilesFullPathList.isNotEmpty) {
      if (selectedFilesFullPathList.length == 1) {
        // 删除
        res = await deleteFile(selectedFilesFullPathList[0]);
      } else {
        // 批量删除
        res = await batchDelFils(selectedFilesFullPathList);
      }

      if (res.statusCode == 200 && res.data['statusCode'] == 200) {
        _getList();
      }
    }

    state = state.copyWith(delFileStatus: OperationState.complete());
  }

  /// 新增文件夹
  /// - [filePath] 文件路径
  void newFolder(String filePath) async {
    state = state.copyWith(newFolderStatus: OperationState.loading());
    final Response res = await mkdirFile(filePath);

    if (res.statusCode == 200 && res.data['statusCode'] == 200) {
      _getList();
    }

    state = state.copyWith(newFolderStatus: OperationState.complete());
  }

  /// 改变文件选中状态
  /// - [fileIndex] 文件位置索引
  void onToggleFileSelected(int fileIndex) {
    List<BasicFileType> newFileList = List<BasicFileType>.from(state.fileList);
    newFileList[fileIndex].isSelected = !(newFileList[fileIndex].isSelected);

    print('1: ${(!newFileList[fileIndex].isSelected) == false}');
    print('2: ${state.fileList.every((item) => item.isSelected == false)}');

    if ((!newFileList[fileIndex].isSelected) == false && state.fileList.every((item) => item.isSelected == false)) {
      onToggleMultiSelect();
      print('????');
    }

    state = state.copyWith(fileList: newFileList);
  }

  /// 改变多选状态
  void onToggleMultiSelect() {
    state = state.copyWith(isMulSelectStatus: !state.isMulSelectStatus);
  }
}