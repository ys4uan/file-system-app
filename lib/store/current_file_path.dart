import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_file_path.g.dart';

@riverpod
class CurrentFilePath extends _$CurrentFilePath {
  // String _routerPath = '/';

  @override
  String build() => '/';

  // switch routerPath
  void switchRouterPath(String? routerPath) => state = routerPath ?? '/';
}