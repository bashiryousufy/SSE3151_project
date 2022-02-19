import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/auth_screen.dart';
import 'package:project/Screens/cloud_docs_screen.dart';
import 'package:project/Screens/folders_screen.dart';
import 'package:project/Screens/home_screen.dart';
import 'package:project/Screens/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (context) => AuthenticateScreen(),
        '/home': (context) => HomeScreen(),
        '/folder': (context) => FolderScreen(),
        '/login': (context) => SignInScreen(),
        '/cloudDoc': (context) => CloudDocsScreen()
      },
    );
  }
}
