import 'package:dio/dio.dart';
import 'package:file_system_app/utils/request.dart';

final request = DioUtil();

typedef InterfaceCallBack = List<Map<String, dynamic>>;

/// 获取目录下所有文件信息
///
/// [path] 文件路径
Future<Response> getFileList(String path) {
  return request.post('/getDirDetails', data: { 'path': path });
}
