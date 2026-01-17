import 'package:file_system_app/models/file.dart';
import 'package:file_system_app/store/current_file_path.dart';
import 'package:file_system_app/store/file_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_file.g.dart';

@riverpod
class ActiveFile extends _$ActiveFile {
  @override
  CustomFiles build() {
    String curPath = ref.watch(currentFilePathProvider);

    return ref.watch(fileStoreProvider(curPath));
  }

  FileStore getMethods() {
    return ref.read(fileStoreProvider(state.curPath).notifier);
  }
}