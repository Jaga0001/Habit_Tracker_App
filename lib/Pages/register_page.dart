import 'package:flutter/material.dart';
import 'package:habit_tracker_app/Components/my_button.dart';
import 'package:habit_tracker_app/Components/my_textfield.dart';
import 'package:habit_tracker_app/Services/auth/auth_services.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  RegisterPage({super.key, this.onTap});

  //* Intialize Text Editing Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //* Register Function
  void register(BuildContext context) async {
    //* Get Auth Services
    AuthServices _auth = AuthServices();

    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        await _auth.signUp(_emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(e.toString()),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //* Welcome Text
            Text(
              'Let\'s Create a Account For You',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
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

            //* Confirm Password Textfield
            MyTextfield(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),

            const SizedBox(
              height: 20,
            ),

            //* SignUp Button
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),

            const SizedBox(
              height: 10,
            ),

            //* Already a Member SignIn Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a Member? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Sign In',
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
