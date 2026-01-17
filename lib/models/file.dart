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

class BasicFileType {
  // 文件名称
  final String name;
  // 文件全路径
  final String fullPath;
  // 文件目录路径
  final String basicPath;
  // 创建时间
  final String createTime;
  // 是否选中
  bool isSelected;

  BasicFileType({
    required this.name,
    required this.fullPath,
    required this.basicPath,
    required this.createTime,
    required this.isSelected,
  });
}

class FileExpansionType {
  // 文件后缀
  final String ext;
  // 文件 mime 后缀
  final String mime;

  const FileExpansionType({
    required this.ext,
    required this.mime,
});
}

class DirectoryType extends BasicFileType {
  // 文件类型
  final String type = 'directory';
  // 子文件数量
  final int sonCount;

  DirectoryType({
    required super.name,
    required super.fullPath,
    required super.basicPath,
    required super.createTime,
    required this.sonCount,
    required super.isSelected,
  });

  factory DirectoryType.fromJson(Map<String, dynamic> json) {
    return DirectoryType(
      name: json['name'] ?? '',
      fullPath: json['fullPath'] ?? '',
      basicPath: json['basicPath'] ?? '',
      createTime: json['createTime'] ?? '',
      sonCount: json['sonCount'] ?? 0,
      isSelected: false,
    );
  }
}

class FileType extends BasicFileType {
  // 文件类型
  final String type = 'file';
  // 文件拓展类型
  final FileExpansionType expansionType;
  // 文件大小（例：xx B、xx KB）
  final String size;

  FileType({
    required super.name,
    required super.fullPath,
    required super.basicPath,
    required super.createTime,
    required this.expansionType,
    required this.size,
    required super.isSelected,
  });

  factory FileType.fromJson(Map<String, dynamic> json) {
    return FileType(
      name: json['name'] ?? '',
      fullPath: json['fullPath'] ?? '',
      basicPath: json['basicPath'] ?? '',
      createTime: json['createTime'] ?? '',
      expansionType: FileExpansionType(
        ext: json['ext'] ?? '',
        mime: json['mime'] ?? '',
      ),
      size: json['size'] ?? '',
      isSelected: false,
    );
  }
}

class ConvertFileType {
  static BasicFileType fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'file') {
      return FileType.fromJson(json);
    } else {
      return DirectoryType.fromJson(json);
    }
  }
}

// 文件
class CustomFiles {
  // 基础路由
  final String basicPath = 'D:\\YyFiles\\fileSystemResource';

  // 文件列表
  final List<BasicFileType> fileList;
  // 获取文件列表时的相关状态
  final OperationState getFileStatus;
  // 删除/批量删除 文件 的相关状态
  final OperationState delFileStatus;
  // 新增文件夹的相关状态
  final OperationState newFolderStatus;

  // 当前路由层级
  final String curPath;
  // 是否是多选状态
  bool isMulSelectStatus;

  CustomFiles({
    required this.getFileStatus,
    required this.delFileStatus,
    required this.newFolderStatus,
    required this.curPath,
    this.fileList = const [],
    this.isMulSelectStatus = false,
  });

  CustomFiles copyWith({
    List<BasicFileType>? fileList,
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

  factory CustomFiles.init({ required String curPath }) {
    return CustomFiles(
      getFileStatus: OperationState.reset(),
      delFileStatus: OperationState.reset(),
      newFolderStatus: OperationState.reset(),
      curPath: curPath
    );
  }
}