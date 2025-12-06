import 'package:file_system_app/pages/main_page/index.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> _getRoutes() {
  return {
    '/': (context) => MainPage(),
  };
}

Widget getRootWidget() {
  return MaterialApp(
    initialRoute: '/',
    routes: _getRoutes(),
  );
}