import 'package:file_system_app/pages/main_page/index.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> _getRoutes() {
  return {
    '/': (context) {
      final args = ModalRoute.of(context)?.settings.arguments;

      return MainPage(argsPath: args is Map<String, dynamic> ? args['path'] : null);
    },
  };
}

ThemeData globalTheme = ThemeData(
  useMaterial3: true,
  textTheme: TextTheme(
    titleMedium: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w800),
    titleSmall: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.4), fontWeight: FontWeight.w600),
    labelLarge: TextStyle(fontSize: 20, color: Color.fromRGBO(161, 161, 161,1), fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 16, color: Color.fromRGBO(161, 161, 161,1)),
    labelSmall: TextStyle(fontSize: 12, color: Color.fromRGBO(161, 161, 161,1)),
  ),
  fontFamily: 'SourceHanSansCN',
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Color.fromRGBO(248, 248, 248, 1),
);

Widget getRootWidget() {
  return MaterialApp(
    initialRoute: '/',
    routes: _getRoutes(),
    theme: globalTheme,
  );
}