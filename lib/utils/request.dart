import 'package:dio/dio.dart';

class DioUtil {
  late Dio _dio;
  static final DioUtil _instance = DioUtil._internal();
  factory DioUtil() => _instance;

  DioUtil._internal() {
    print('构造 DioUtil ');

    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:4800',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-type': 'application/json; charset=utf-8',
      }
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      // 请求拦截器
      onRequest: (options, handler) {
        handler.next(options);
      },
      // 响应拦截器
      onResponse: (options, handler) {
        handler.next(options);
      }
    ));
  }

  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('连接超时');
        break;
      case DioExceptionType.sendTimeout:
        print('发送超时');
        break;
      case DioExceptionType.receiveTimeout:
        print('接收超时');
        break;
      case DioExceptionType.badCertificate:
        print('证书错误');
        break;
      case DioExceptionType.badResponse:
        print('服务器响应错误: ${e.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        print('请求取消');
        break;
      case DioExceptionType.connectionError:
        print('连接错误');
        break;
      case DioExceptionType.unknown:
        print('未知错误: ${e.message}');
        break;
    }
  }

  Future<Response> get(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress
  }) async {
    try {
      Response response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress
      );

      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress
  }) async {
    try {
      final Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress
      );

      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
}