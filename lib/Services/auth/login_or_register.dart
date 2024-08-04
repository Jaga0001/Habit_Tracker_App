import 'package:flutter/material.dart';
import 'package:habit_tracker_app/Pages/login_page.dart';
import 'package:habit_tracker_app/Pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool isShowLogin = true;

  void toggleFunction() {
    setState(() {
      isShowLogin = !isShowLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isShowLogin) {
      return LoginPage(
        onTap: toggleFunction,
      );
    } else {
      return RegisterPage(
        onTap: toggleFunction,
      );
    }
  }
}
