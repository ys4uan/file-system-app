import 'package:flutter/material.dart';

class NoFilesView extends StatelessWidget {
  const NoFilesView({super.key});

  @override
  Widget build(BuildContext context) {
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
}
