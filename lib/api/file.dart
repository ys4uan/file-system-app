import 'package:dio/dio.dart';
import 'package:file_system_app/utils/request.dart';

final request = DioUtil();

typedef InterfaceCallBack = List<Map<String, dynamic>>;

/// 新建文件夹
/// - [path] 文件路径
Future<Response> mkdirFile(String path) {
  return request.post('/createDir', data: { 'path': path });
}

/// 获取目录下所有文件信息
/// - [path] 文件路径
Future<Response> getFileList(String path) {
  return request.post('/getDirDetails', data: { 'path': path });
}

/// 删除文件或目录
/// - [path] 文件路径
Future<Response> deleteFile(String path) {
  return request.post('/deleteFile', data: { 'path': path });
}

/// 批量删除文件或目录
/// - [pathList] 文件路径列表
Future<Response> batchDelFils(List<String> pathList) {
  return request.post('/batchDelFiles', data: { 'pathList': pathList });
}

/// 文件或目录重命名
/// - [oldPath] - 旧文件路径
/// - [newPath] - 新文件路径
Future<Response> renameFile(String oldPath, String newPath) {
  return request.post('/rename', data: { 'oldPath': oldPath, 'newPath': newPath });
}

// needDelOrigin 枚举类型
enum NeedDelOriginType {
  yes(1),
  no(2);

  final int value;
  const NeedDelOriginType(this.value);
}

/// 复制文件或目录
/// - [oldPath] 旧文件路径
/// - [newPath] 新文件路径
/// - [needDelOrigin] 是否需要删除原文件（1：需要、0：不需要），默认值是 0
Future<Response> copyFile(
  String oldPath,
  String newPath,
  { NeedDelOriginType needDelOrigin = NeedDelOriginType.no }
) {
  return request.post(
    '/copyFile',
    data: {
      'oldPath': oldPath,
      'newPath': newPath,
      'needDelOrigin': needDelOrigin,
    }
  );
}