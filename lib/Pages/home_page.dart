import 'package:flutter/material.dart';
import 'package:habit_tracker_app/Services/auth/auth_services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void signOut() {
    //* Get AuthServices
    AuthServices _auth = AuthServices();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker',
            style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
    );
  }
}
