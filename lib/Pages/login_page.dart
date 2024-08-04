import 'package:flutter/material.dart';
import 'package:habit_tracker_app/Components/my_button.dart';
import 'package:habit_tracker_app/Components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, this.onTap});

  //* Intialize Text Editing Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //* Login Function
  void login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //* Logo
            Icon(
              Icons.track_changes_outlined,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(
              height: 20,
            ),
            //* Welcome Text

            Text(
              'Welcome Back, You\'ve been Missed',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),

            const SizedBox(
              height: 50,
            ),

            //* Email TextField
            MyTextfield(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(
              height: 20,
            ),

            //* Password TextField
            MyTextfield(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(
              height: 20,
            ),

            //* SignIn Button
            MyButton(
              text: 'Login',
              onTap: login,
            ),

            const SizedBox(
              height: 10,
            ),

            //* Don't You have a account register now Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dont Have a Account? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register Now',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
