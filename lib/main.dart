import 'package:flutter/material.dart';
import 'package:forma_green/page/LoginPage.dart';
import 'package:forma_green/page/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forma_green/page/MainPage.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final mainPageState = new GlobalKey<MainPageState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


