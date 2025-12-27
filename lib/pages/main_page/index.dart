import 'package:file_system_app/components/loading_button.dart';
import 'package:file_system_app/store/active_file.dart';
import 'package:file_system_app/store/current_file_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'components/bottom_files_operator_badge.dart';
import 'components/no_files.dart';
import 'components/show_file_view.dart';
import 'components/show_folder_view.dart';

class MainPage extends ConsumerStatefulWidget {
  // The router params of fetch file list
  final String routerPath;

  const MainPage({super.key, required this.routerPath});

  @override
  ConsumerState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  /// add folder dialog
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
            extentOffset: addFolderControl.text.length,
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
                      color: Theme.of(context).colorScheme.error,
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
                    ),
                  ),
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
                      // String curFilePath = '$_basicPath$routerPath\\${addFolderControl.text}';

                      // TODO：调新增文件夹的接口
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
          },
        );
      },
    );
  }

  /// loading pages widget
  Widget _showLoadingView() {
    return Center(child: const CircularProgressIndicator());
  }

  /// show file item widget
  /// - [fileList] the file data from interface
  Widget _showFiles(List<Map<String, dynamic>>fileList) {
    return  Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: fileList.length,
            itemExtent: 80,
            itemBuilder: (context, index) {
              final String fileType = fileList[index]['type'];

              return fileType == 'directory' ? ShowFolderView(fileListIdx: index,) : ShowFileView(fileListIdx: index,);
            },
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // TODO: 【optimize】The page will fetch twice when initial, and the first must be fetch by using '/' params
    if (oldWidget.routerPath != widget.routerPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // get router path again, to change file store
          ref.read(currentFilePathProvider.notifier).switchRouterPath(widget.routerPath);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeFileProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
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
                child: state.getFileStatus.isLoading
                  ? _showLoadingView()
                  : state.fileList.isEmpty ? const NoFilesView() : _showFiles(state.fileList),
              ),
              Visibility(
                visible: state.isMulSelectStatus,
                child: BottomFilesOperatorBadge(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
