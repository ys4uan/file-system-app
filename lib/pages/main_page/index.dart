import 'package:date_format/date_format.dart';
import 'package:file_system_app/api/file.dart';
import 'package:file_system_app/pages/main_page/components/file_item.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final String? argsPath;

  const MainPage({super.key, this.argsPath});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 是否展示 badge
  bool _isShowBadge = false;
  // 是否展示子组件中的 radio
  bool _isShowRadio = false;
  // 访问文件的基础路径
  String _basicPath = 'D:\\MyFiles\\node-resources';
  // 文件列表
  List<Map<String, dynamic>> _fileList = [];
  // 页面是否展示 loading
  bool _isShowLoading = false;

  @override
  void initState() {
    super.initState();

    // 获取文件列表
    _getFileList();
  }

  // 获取文件列表方法
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

  /// 展示文件项
  Widget _showFileItemView() {
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
                    if (!value) {
                      // 如果所有项都没有选中，则取消多选框
                      final bool haveSelected = _fileList.where((item) => item['isSelectedRow']).isNotEmpty;

                      if (!haveSelected) {
                        _isShowRadio = false;
                      }
                    } else {
                      _isShowRadio ? '' : _isShowRadio = true;
                    }

                    _fileList[idx]['isSelectedRow'] = value;
                  });
                },
                onLoadNewFolder: (String path) {
                  setState(() {
                    _basicPath = path;
                    _getFileList();
                  });
                },
              );
            },
          ),
        ),
        Visibility(
          visible: _isShowBadge,
          child: _getBadge(),
        ),
      ],
    );
  }

  /// 展示空文件页面
  Widget _showNoFileView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: constraints.maxHeight * 0.25),
          child: Column(
            children: [
              Image.asset('lib/assets/images/noFile.png', width: 200, height: 200),
              Text('空文件夹', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: _isShowLoading
            ? CircularProgressIndicator()
            : _fileList.isEmpty ? _showNoFileView() : _showFileItemView(),
        ),
      ),
    );
  }
}

Widget _getBadge() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
    ),
    padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
    child: Badge(
      child: Container(
        child: Text('Badge'),
      ),
    ),
  );
}
