import 'package:file_system_app/pages/main_page/components/show_files.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final String? argsPath;

  const MainPage({super.key, this.argsPath});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ShowFilesView(argsPath: widget.argsPath),
        ),
      ),
    );
  }
}
