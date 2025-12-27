// 功能调用状态
class OperationState {
  final bool isLoading;
  final bool hasCompleted;

  const OperationState({
    this.isLoading = false,
    this.hasCompleted = false,
  });

  factory OperationState.loading() => OperationState(isLoading: true);
  factory OperationState.complete() => OperationState(isLoading: false, hasCompleted: true);
  factory OperationState.reset() => OperationState();
}

// 文件
class CustomFiles {
  // 基础路由
  final String basicPath = 'D:\\MyFiles\\node-resources';

  // 文件列表
  final List<Map<String, dynamic>> fileList;
  // 获取文件列表时的相关状态
  final OperationState getFileStatus;
  // 删除/批量删除 文件 的相关状态
  final OperationState delFileStatus;
  // 新增文件夹的相关状态
  final OperationState newFolderStatus;

  // 当前路由层级
  final String curPath;
  // 是否是多选状态
  final bool isMulSelectStatus;

  CustomFiles({
    required this.getFileStatus,
    required this.delFileStatus,
    required this.newFolderStatus,
    this.curPath = 'home',
    this.fileList = const [],
    this.isMulSelectStatus = false,
  });

  CustomFiles copyWith({
    List<Map<String, dynamic>>? fileList,
    String? curPath,
    bool? delLoading,
    bool? isMulSelectStatus,
    OperationState? getFileStatus,
    OperationState? delFileStatus,
    OperationState? newFolderStatus,
  }) {
    return CustomFiles(
      fileList: fileList ?? this.fileList,
      curPath: curPath ?? this.curPath,
      isMulSelectStatus: isMulSelectStatus ?? this.isMulSelectStatus,
      getFileStatus: getFileStatus ?? this.getFileStatus,
      delFileStatus: delFileStatus ?? this.delFileStatus,
      newFolderStatus: newFolderStatus ?? this.newFolderStatus,
    );
  }

  factory CustomFiles.init() {
    return CustomFiles(
      getFileStatus: OperationState.reset(),
      delFileStatus: OperationState.reset(),
      newFolderStatus: OperationState.reset(),
    );
  }
}