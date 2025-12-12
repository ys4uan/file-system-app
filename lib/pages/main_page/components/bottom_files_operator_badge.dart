import 'package:flutter/material.dart';

class BottomFilesOperatorBadge extends StatefulWidget {
  const BottomFilesOperatorBadge({super.key});

  @override
  State<BottomFilesOperatorBadge> createState() => _BottomFilesOperatorBadge();
}

class _BottomFilesOperatorBadge extends State<BottomFilesOperatorBadge> {
  // 底部 badge 的列表数据
  final List<Map<String, dynamic>> _bottomIconList = [
    { 'iconUrl': 'lib/assets/images/delete.png', 'label': '删除', 'onTapFun': () {} },
    { 'iconUrl': 'lib/assets/images/copy.png', 'label': '复制', 'onTapFun': () {} },
    { 'iconUrl': 'lib/assets/images/cut.png', 'label': '剪切', 'onTapFun': () {} },
    { 'iconUrl': 'lib/assets/images/edit.png', 'label': '重命名', 'onTapFun': () {} },
  ];

  /// 底部 badge 中的操作按钮
  /// - [iconUrl] - icon的本地路径
  /// - [label] - 文本标题
  /// - [disabled] - 禁用状态，默认为 false
  /// - [onTapFun] - 点击事件
  Widget _bottomIconButtonComp({
    required String iconUrl,
    required String label,
    required Function onTapFun,
    bool disable = false,
  }) {
    return GestureDetector(
      onTap: () {
        onTapFun();
      },
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child:  Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: disable
                ? BoxDecoration(
              color: disable ? Color.fromARGB(30, 0, 0, 0) : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: BoxBorder.all(color: Colors.grey.shade400, width: 1),
            )
                : BoxDecoration(),
            child: Column(
              spacing: 4,
              children: [
                Image.asset(iconUrl),
                Text(label, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
      ),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 10),
      child: Badge(
        child: Flex(
          direction: Axis.horizontal,
          children: List.generate(_bottomIconList.length, (idx) {
            return Expanded(
              child: _bottomIconButtonComp(
                iconUrl: _bottomIconList[idx]['iconUrl'],
                label: _bottomIconList[idx]['label'],
                onTapFun: _bottomIconList[idx]['onTapFun'],
                disable: false,
              ),
            );
          }),
        ),
      ),
    );
  }
}
