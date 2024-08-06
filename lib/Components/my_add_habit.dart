import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/Services/database/habit_service.dart';
import 'package:habit_tracker_app/Services/database/habit_model.dart';

class AddHabitDialog extends StatefulWidget {
  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  String _habitName = '';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final habitService = HabitService();

    return AlertDialog(
      title: Text('Add New Habit'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Habit Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a habit name';
            }
            return null;
          },
          onSaved: (value) {
            _habitName = value!;
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              if (user != null) {
                try {
                  final habit = Habit(
                    id: '', // ID can be empty as Firestore will generate it
                    userId: user.uid,
                    name: _habitName,
                    completed: false,
                    timestamp:
                        DateTime.now(), // Use DateTime.now() for timestamp
                  );

                  await habitService.addHabit(habit);
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add habit: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User not logged in')),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

void showAddHabitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AddHabitDialog();
    },
  );
}
