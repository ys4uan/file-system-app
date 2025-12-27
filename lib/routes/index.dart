import 'package:file_system_app/pages/main_page/index.dart';
import 'package:file_system_app/pages/picture_viewer/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessageKey = GlobalKey<ScaffoldMessengerState>();
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final path = state.uri.queryParameters['path'] ?? '';

        return MainPage(routerPath: path);
      },
    ),
    GoRoute(
      path: '/picture',
      builder: (context, state) {
        final pictureList = state.extra as Map<String, dynamic>;

        return PictureViewer(pictureList: pictureList['pictureList']);
      }
    ),
  ]
);

ThemeData globalTheme = ThemeData(
  useMaterial3: true,
  textTheme: TextTheme(
    titleLarge: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w800),
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
  return MaterialApp.router(
    scaffoldMessengerKey: scaffoldMessageKey,
    routerConfig: _router,
    theme: globalTheme,
  );
}