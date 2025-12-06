import 'package:dio/src/response.dart';
import 'package:file_system_app/api/file.dart';
import 'package:file_system_app/pages/main_page/components/file_item.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 是否展示 badge
  bool _isShowBadge = false;
  // 是否展示子组件中的 radio
  bool _isShowRadio = false;
  // 访问文件的默认路径
  final String _path = 'D:\\MyFiles\\node-resources\\';
  // 文件列表
  List<Map<String, dynamic>> _fileList = [];

  @override
  void initState() {
    super.initState();

    _getFileList();
  }

  void _getFileList() {
    getFileList(_path).then((res) {
      print('-=-=-=-=-=');
      print(res);

      print('11221212121212');
      print(res.data);

      print('890808080980');
      print(res.data['data']);

      if (res.statusCode == 200) {
        List<Map<String, dynamic>> myData = (res.data as List).cast<Map<String, dynamic>>();
        print(myData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(248, 248, 248, 1),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return FileItem(
                      fileObj: { '11': 11, 'fileType': 'dic' },
                      isShowRadio: _isShowRadio,
                      onShowBadge: () {
                        setState(() {
                          _isShowBadge = true;
                          _isShowRadio = true;
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
          ),
        ),
      ),
    );
  }
}

Widget _getBadge() {
  return  Container(
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
