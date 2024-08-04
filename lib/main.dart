import 'package:flutter/material.dart';
import 'package:habit_tracker_app/Services/auth/login_or_register.dart';
import 'package:habit_tracker_app/Themes/dark_mode.dart';
import 'package:habit_tracker_app/Themes/light_mode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: LoginOrRegister(),
    );
  }
}
