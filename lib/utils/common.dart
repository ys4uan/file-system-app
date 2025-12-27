enum ReturnFileExpansionType {
  photo('photo'),
  video('video'),
  audio('audio'),
  txt('txt'),
  pdf('pdf'),
  rar('rar'),
  undefined('undefined');

  final String value;
  const ReturnFileExpansionType(this.value);
}

/// 获取文件的拓展类型
/// - [expansionType] 接口返回的拓展类型
ReturnFileExpansionType getFileExpansionType(String? expansionType) {
  if (expansionType == 'jpg' || expansionType == 'png') {
    return ReturnFileExpansionType.photo;
  } else if (expansionType == 'mp4') {
    return ReturnFileExpansionType.video;
  } else if (expansionType == 'mp3') {
    return ReturnFileExpansionType.audio;
  } else if (expansionType == 'txt') {
    return ReturnFileExpansionType.txt;
  } else if (expansionType == 'pdf') {
    return ReturnFileExpansionType.pdf;
  } else if (expansionType == 'rar' || expansionType == 'zip' || expansionType == '7z') {
    return ReturnFileExpansionType.rar;
  } else {
    return ReturnFileExpansionType.undefined;
  }
}