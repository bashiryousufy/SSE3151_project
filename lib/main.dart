import 'package:flutter/material.dart';
import 'package:project/Screens/auth_screen.dart';
import 'package:project/Screens/folders_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FolderScreen(),
    );
  }
}
