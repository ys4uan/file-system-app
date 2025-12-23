import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:file_system_app/api/file.dart';
import 'package:file_system_app/components/loading_button.dart';
import 'package:file_system_app/pages/main_page/components/bottom_files_operator_badge.dart';
import 'package:file_system_app/pages/main_page/components/no_files.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'file_item.dart';

class ShowFilesView extends StatefulWidget {
  const ShowFilesView({super.key});

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

  /// 获取所有被选中的文件
  /// - [attrName] 返回被选中文件的指定属性，如不填则返回整个文件对象
  List<dynamic> _getSelectedFiles({ String? attrName }) {
    List<dynamic> returnParams = [];
    
    for (int i = 0; i < _fileList.length; i++) {
      final curFile = _fileList[i];
      if (curFile['selected']) {
        if (attrName != null && curFile.containsKey(attrName)) {
          returnParams.add(curFile[attrName]);
        } else {
          returnParams.add(curFile);
        }
      }
    }

    return returnParams;
  }

  // 文件列表
  List<Map<String, dynamic>> _fileList = [];

  /// 获取文件列表方法
  void _getFileList() async {
    setState(() => _isShowLoading = true);

    final String routerPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.queryParameters['path'] ?? '';
    final String realPath = '$_basicPath$routerPath';
    try {
      final res = await getFileList(realPath);

      if (res.statusCode == 200) {
        List<Map<String, dynamic>> myData = (res.data['data'] as List).cast<Map<String, dynamic>>();
        setState(() {
          _fileList = myData.map((item) {
            item['selected'] = false;
            if (item['createTime'] != null) {
              item['createTime'] = formatDate(DateTime.parse(item['createTime']), [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm]);
            }

            return item;
          }).toList();
        });
      }
    } finally {
      setState(() => _isShowLoading = false);
    }
  }

  /// 删除/批量删除 文件、目录
  void _delFiles() async {
    setState(() => _isShowLoading = true);

    final List<String> params = _getSelectedFiles(attrName: 'fullPath').cast<String>();
    late Response res;

    if (params.isNotEmpty) {
      if (params.length == 1) {
        // 删除
        res = await deleteFile(params[0]);
      } else {
        // 批量删除
        res = await batchDelFils(params);
      }

      if (res.statusCode == 200) {
        _getFileList();
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error: ${res.data}')));
      }
    }

    setState(() {
      _isShowRadio = false;
      _isShowLoading = false;
    });
  }

  /// 复制/剪切 文件
  void _copyFiles() async {

  }

  /// 新增文件夹弹窗
  void _addFolderAlertDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController addFolderControl = TextEditingController(text: '新建文件夹');
    bool addLoading = false;
    // 是否展示错误提示
    bool isShowErrTip = false;
    // 错误提示文本
    String? errText = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // 当实例创建成功后，给下面的 TextField 添加文本值全选功能
        WidgetsBinding.instance.addPostFrameCallback((_) {
          addFolderControl.selection = TextSelection(
            baseOffset: 0,
            extentOffset: addFolderControl.text.length
          );
        });

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text('新建文件夹', style: Theme.of(context).textTheme.titleLarge),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: addFolderControl,
                    autofocus: true,
                  ),
                  Visibility(
                    visible: isShowErrTip,
                    child: Text(errText ?? '', style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.error
                    )),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxWidth: screenWidth - 60,
                minWidth: screenWidth - 60,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '取消',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error
                    )
                  )
                ),
                LoadingButton(
                  loading: addLoading,
                  loadingColor: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    if (addLoading) return;
                    if (addFolderControl.text.isEmpty) {
                      setState(() {
                        isShowErrTip = true;
                        errText = '文件名不能为空！';
                      });
                    } else {
                      setState(() {
                        isShowErrTip = false;
                        errText = '';
                        addLoading = true;
                      });

                      String routerPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.queryParameters['path'] ?? '';
                      String curFilePath = '$_basicPath$routerPath\\${addFolderControl.text}';

                      final Response res = await mkdirFile(curFilePath);

                      if (res.data['statusCode'] == 200) {
                        _getFileList();
                        if (context.mounted) Navigator.of(context).pop();
                        setState(() => addLoading = false);
                      } else {
                        setState(() {
                          isShowErrTip = true;
                          errText = res.data.toString();
                          addLoading = false;
                        });
                      }
                    }
                  },
                  text: '确定',
                  textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ],
              backgroundColor: Theme.of(context).primaryColor,
            );
          }
        );
      }
    );
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
                    _fileList[idx]['selected'] = value;

                    if (!value) {
                      // 如果所有项都没有选中，则取消多选框 和 badge
                      final bool haveSelected = _fileList.where((item) => item['selected']).isNotEmpty;

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
          child: BottomFilesOperatorBadge(
            operationMap: { 'delete': _delFiles }
          ),
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
    return Column(
      children: [
        Container(
          height: 60,
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () => _addFolderAlertDialog(),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Image.asset('lib/assets/images/newFolder.png'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text('home', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Image.asset('lib/assets/images/search.png'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isShowLoading
            ? _showLoading()
            : _fileList.isEmpty ? const NoFilesView() : _showFiles()
        ),
      ],
    );
  }
}
