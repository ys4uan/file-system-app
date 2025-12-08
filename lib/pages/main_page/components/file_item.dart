import 'package:file_system_app/components/icon_font.dart';
import 'package:flutter/material.dart';

class FileItem extends StatefulWidget {
  // 接口返回的文件数据
  final Map<String, dynamic> fileObj;
  // 是否打开全部 radio
  final bool isShowRadio;
  // 打开 Badge 的函数
  final VoidCallback? onShowBadge;
  // 进入一个新的文件夹的回调函数
  final VoidCallback? onLoadNewFolder;

  const FileItem({
    super.key,
    required this.fileObj,
    required this.isShowRadio,
    this.onShowBadge,
    this.onLoadNewFolder
  });

  @override
  State<FileItem> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  // 文件 radio 选中值
  bool _selectedRow = false;

  // 展示文件夹
  Widget _showDirectoryView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.isShowRadio) {
            _selectedRow = !_selectedRow;
          } else {
            if (widget.onLoadNewFolder != null) {
              // widget.onLoadNewFolder();
            }
          }
        });
      },
      onLongPress: () {
        setState(() {
          // 展示 badge
          if (widget.onShowBadge != null) {
            widget.onShowBadge!();
          }
          // 展示 radio
          setState(() {
            _selectedRow = true;
          });
        });
      },
      child: Container(
        height: 80,
        color: _selectedRow ? Color.fromRGBO(242, 249, 255, 1) : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.asset('lib/assets/images/folder.png', width: 60, height: 60, fit: BoxFit.fill),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.fileObj['name'] ?? '-', style: TextStyle(fontFamily: 'SourceHanSansCN', fontSize: 16, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text(
                    '${widget.fileObj['createTime']} - ${widget.fileObj['sonCount']}项',
                    style: TextStyle(
                      fontFamily: 'SourceHanSansCN',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(0, 0, 0, 0.4)
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.isShowRadio,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: RadioGroup(
                  onChanged: (value) {
                    print('点击了 radio');
                  },
                  groupValue: _selectedRow,
                  child: Radio(value: true)
                ),
              ),
            ),
            Visibility(
              visible: !widget.isShowRadio,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(IconFont.arrowRight),
              )
            ),
          ],
        ),
      ),
    );
  }

  // 展示文件
  Widget _showFileView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.isShowRadio) {
            _selectedRow = !_selectedRow;
          }
        });
      },
      onLongPress: () {
        setState(() {
          // 展示 badge
          if (widget.onShowBadge != null) {
            widget.onShowBadge!();
          }
          // 展示 radio
          setState(() {
            _selectedRow = true;
          });
        });
      },
      child: Container(
        height: 80,
        color: _selectedRow ? Color.fromRGBO(242, 249, 255, 1) : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Image.asset('lib/assets/images/file.png', width: 60, height: 60, fit: BoxFit.fill),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.fileObj['name'], style: TextStyle(fontFamily: 'SourceHanSansCN', fontSize: 16, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text(
                    '${widget.fileObj['createTime']} - ${widget.fileObj['size']}',
                    style: TextStyle(
                      fontFamily: 'SourceHanSansCN',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(0, 0, 0, 0.4)
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Visibility(
              visible: widget.isShowRadio,
              child: RadioGroup(
                onChanged: (value) {
                  print('点击了 radio');
                },
                groupValue: _selectedRow,
                child: Radio(value: true)
              )
            ),
          ],
        ),
      ),
    );
  }

  // 展示正确的文件
  Widget _showCorrectFile() {
    return widget.fileObj['type'] != null && widget.fileObj['type'] == 'directory'
      ? _showDirectoryView()
      : _showFileView();
  }

  @override
  Widget build(BuildContext context) {
    return _showCorrectFile();
  }
}
