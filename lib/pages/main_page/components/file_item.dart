import 'package:file_system_app/components/icon_font.dart';
import 'package:flutter/material.dart';

class FileItem extends StatefulWidget {
  // 接口返回的文件数据
  final Map<String, dynamic> fileObj;
  // 是否打开全部 radio
  final bool isShowRadio;
  // 当前文件项索引
  final int idx;
  // 打开 Badge 的函数
  final VoidCallback? onShowBadge;
  // 选中 | 取消选中
  final void Function(int, bool) onChangeSelected;

  const FileItem({
    super.key,
    required this.fileObj,
    required this.isShowRadio,
    required this.idx,
    required this.onChangeSelected,
    this.onShowBadge,
  });

  @override
  State<FileItem> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  // 展示文件夹
  Widget _showDirectoryView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.isShowRadio) {
            widget.onChangeSelected(widget.idx, !widget.fileObj['isSelectedRow']);
          } else {
            // 1.先从路由中拿取当前的 path 参数
            final args = ModalRoute.of(context)?.settings.arguments;
            String newPath = '';

            // 2.如何路由中有 path 参数，拼接后赋予新的路由参数
            if (args is Map<String, dynamic>) {
              newPath = args['path'];
            }
            Navigator.pushNamed(context, '/', arguments: { 'path': '$newPath\\${widget.fileObj['name']}' });
          }
        });
      },
      onLongPress: () {
        if (widget.onShowBadge != null) {
          widget.onShowBadge!();
        }
        // 展示 radio
        widget.onChangeSelected(widget.idx, !widget.fileObj['isSelectedRow']);
      },
      child: Container(
        height: 80,
        color: widget.fileObj['isSelectedRow'] ? Color.fromRGBO(242, 249, 255, 1) : Theme.of(context).primaryColor,
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
                  Text(widget.fileObj['name'] ?? '-', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Text(
                    '${widget.fileObj['createTime']} - ${widget.fileObj['sonCount']}项',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.isShowRadio,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child:  Visibility(
                  visible: widget.isShowRadio,
                  child: Checkbox(
                    value: widget.fileObj['isSelectedRow'],
                    onChanged: (value) => widget.onChangeSelected(widget.idx, value!),
                  ),
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
            widget.onChangeSelected(widget.idx, !widget.fileObj['isSelectedRow']);
          }
        });
      },
      onLongPress: () {
        // 展示 badge
        if (widget.onShowBadge != null) {
          widget.onShowBadge!();
        }
        // 展示 radio
        widget.onChangeSelected(widget.idx, !widget.fileObj['isSelectedRow']);
      },
      child: Container(
        height: 80,
        color: widget.fileObj['isSelectedRow'] ? Color.fromRGBO(242, 249, 255, 1) : Colors.white,
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
              child: Checkbox(
                value: widget.fileObj['isSelectedRow'],
                onChanged: (value) => widget.onChangeSelected(widget.idx, value!),
              ),
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
