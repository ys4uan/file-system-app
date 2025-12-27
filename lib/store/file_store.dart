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
    print('111');

    Future.microtask(() {
      print('222');

      getList(params: path);
    });

    return CustomFiles.init();
  }

  /// 获取文件列表
  /// - [params] 路由中的路由参数
  void getList({String? params}) async {
    state = state.copyWith(getFileStatus: OperationState.loading());

    final String finalPath = '${state.basicPath}$params';
    final res = await getFileList(finalPath);

    if (res.statusCode == 200) {
      List<Map<String, dynamic>> myData = (res.data['data'] as List).cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> realDate = myData.map((item) {
        item['selected'] = false;
        if (item['createTime'] != null) {
          item['createTime'] = formatDate(DateTime.parse(item['createTime']), [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm]);
        }

        return item;
      }).toList();

      state = state.copyWith(fileList: realDate);
    }

    state = state.copyWith(getFileStatus: OperationState.complete());
  }

  /// 删除/批量删除 文件、目录
  void delFiles() async {
    state = state.copyWith(delFileStatus: OperationState.loading());
    final List<String> params = _getSelectedFiles(attrName: 'fullPath').cast<String>();
    late Response res;

    if (params.isNotEmpty) {
      if (params.length == 1) {
        // 删除
        res = await deleteFile(params[0]);
      } else {
        // 批量删除
        res = await batchDelFils(params);
      }

      if (res.statusCode == 200) {
        getList();
      }
    }

    state = state.copyWith(delFileStatus: OperationState.complete());
  }

  /// 新增文件夹
  /// - [filePath] 文件路径
  void newFolder(String filePath) async {
    state = state.copyWith(newFolderStatus: OperationState.loading());
    final Response res = await mkdirFile(filePath);

    if (res.data['statusCode'] == 200) {
      getList();
    }

    state = state.copyWith(newFolderStatus: OperationState.complete());
  }

  /// 获取所有被选中的文件
  /// - [attrName] 返回被选中文件的指定属性，如不填则返回整个文件对象
  List<dynamic> _getSelectedFiles({ String? attrName }) {
    List<dynamic> returnParams = [];

    for (int i = 0; i < state.fileList.length; i++) {
      final curFile = state.fileList[i];
      if (curFile['selected']) {
        if (attrName != null && curFile.containsKey(attrName)) {
          returnParams.add(curFile[attrName]);
        } else {
          returnParams.add(curFile);
        }
      }
    }

    return returnParams;
  }
}