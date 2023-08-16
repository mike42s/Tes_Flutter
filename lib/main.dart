import 'package:flutter/material.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/view/Menu.dart';
import 'package:tesflutter/view/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: material,
      ),
      // home: const Login(),
      home: SplashScreen(),
      // home: Login(),
    );
  }
}
