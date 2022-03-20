import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_projects/screens/auth_screens/login_screen.dart';
import 'package:new_projects/screens/custom_splash_screen.dart';
import 'package:new_projects/utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dooc app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SizeConfig.init(
        MediaQuery.of(context).size, MediaQuery.of(context).orientation);

    return const CustomSplashScreen();
  }
}

