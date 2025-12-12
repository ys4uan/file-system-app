import 'package:date_format/date_format.dart';
import 'package:file_system_app/api/file.dart';
import 'package:file_system_app/pages/main_page/components/bottom_files_operator_badge.dart';
import 'package:file_system_app/pages/main_page/components/no_files.dart';
import 'package:flutter/material.dart';

import 'file_item.dart';

class ShowFilesView extends StatefulWidget {
  final String? argsPath;

  const ShowFilesView({super.key, this.argsPath});

  @override
  State<ShowFilesView> createState() => _ShowFilesViewState();
}

class _ShowFilesViewState extends State<ShowFilesView> {
  final String _basicPath = 'D:\\MyFiles\\node-resources';
  // 是否展示 radio
  bool _isShowRadio = false;
  // 是否展示底部 badge
  bool _isShowBadge = false;
  // 是否正在加载文件列表
  bool _isShowLoading = false;
  // 访问文件的基础路径

  // 文件列表
  List<Map<String, dynamic>> _fileList = [];

  /// 获取文件列表方法
  void _getFileList() async {
    setState(() => _isShowLoading = true);

    final String realPath = '$_basicPath${widget.argsPath ?? ''}';

    final res = await getFileList(realPath);
    if (res.statusCode == 200) {
      List<Map<String, dynamic>> myData = (res.data['data'] as List).cast<Map<String, dynamic>>();
      setState(() {
        _fileList = myData.map((item) {
          item['isSelectedRow'] = false;
          if (item['createTime'] != null) {
            item['createTime'] = formatDate(DateTime.parse(item['createTime']), [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm]);
          }

          return item;
        }).toList();
      });
    }
    setState(() => _isShowLoading = false);
  }

  Widget _showFiles() {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _fileList.length,
            itemExtent: 80,
            itemBuilder: (context, index) {
              return FileItem(
                fileObj: _fileList[index],
                isShowRadio: _isShowRadio,
                idx: index,
                onShowBadge: () {
                  setState(() {
                    _isShowBadge = true;
                  });
                },
                onChangeSelected: (int idx, bool value) {
                  setState(() {
                    _fileList[idx]['isSelectedRow'] = value;

                    if (!value) {
                      // 如果所有项都没有选中，则取消多选框 和 badge
                      final bool haveSelected = _fileList.where((item) => item['isSelectedRow']).isNotEmpty;

                      if (!haveSelected) {
                        _isShowRadio = false;
                        _isShowBadge = false;
                      }
                    } else {
                      _isShowRadio ? '' : _isShowRadio = true;
                    }
                  });
                },
              );
            },
          ),
        ),
        Visibility(
          visible: _isShowBadge,
          child: BottomFilesOperatorBadge(),
        ),
      ],
    );
  }
  
  Widget _showLoading() {
    return Center(child: const CircularProgressIndicator());
  }

  @override
  void initState() {
    super.initState();

    _getFileList();
  }
  
  @override
  Widget build(BuildContext context) {
    return _isShowLoading
      ? _showLoading()
      : _fileList.isEmpty ? const NoFilesView() : _showFiles();
  }
}
