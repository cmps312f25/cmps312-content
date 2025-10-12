import 'package:flutter/material.dart';
import 'package:widgets/router/app_router.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Widget Demos',
      theme: ThemeData(colorSchemeSeed: Colors.lightGreen, useMaterial3: true),
      routerConfig: AppRouter.router,
    );
  }
}
