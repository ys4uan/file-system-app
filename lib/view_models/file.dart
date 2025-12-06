// 文件基类
class BaseFile {
  // 文件名称
  final String fileName;
  // 文件创建时间
  final String createTime;
  // 文件路径
  final String filePath;

  BaseFile({ required this.fileName, required this.createTime, required this.filePath });

  // 重命名
  void changeFileName() {
    // TODO:
  }

  // 复制/剪切
  void cropFile() {}

  // 删除
  void deleteFile() {}
}

// 文件夹类
class MyDirectory extends BaseFile {
  // 文件夹子项数量
  final int childrenCount;

  MyDirectory({
    required super.fileName,
    required super.createTime,
    required super.filePath,
    required this.childrenCount,
  });
}

// 文件类
class MyFile extends BaseFile {
  // 文件大小
  final String fileSize;
  // 文件类型
  final String? fileType;

  MyFile({
    required super.fileName,
    required super.createTime,
    required super.filePath,
    required this.fileSize,
    this.fileType,
  });
}