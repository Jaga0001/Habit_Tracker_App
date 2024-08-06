import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker_app/Components/my_add_habit.dart';
import 'package:habit_tracker_app/Services/auth/auth_services.dart';
import 'package:habit_tracker_app/Services/database/habit_service.dart';
import 'package:habit_tracker_app/Services/database/habit_model.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void signOut() {
    AuthServices _auth = AuthServices();
    _auth.signOut();
  }

  void _showAddHabitDialog(BuildContext context) {
    showAddHabitDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final habitService = HabitService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker',
            style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: Icon(Icons.add),
      ),
      body: user == null
          ? Center(child: Text('No user logged in'))
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Habit>>(
                    stream: habitService.getHabitsStream(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No habits found.'));
                      }

                      final habits = snapshot.data!;
                      final habitData = getHabitData(habits);

                      return Column(
                        children: [
                          // HeatMap widget
                          Expanded(
                            flex: 2,
                            child: HeatMap(
                              startDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              endDate: DateTime.now(),
                              datasets: habitData,
                              colorsets: const {
                                1: Colors.green,
                                2: Colors.greenAccent,
                                3: Colors.lightGreen,
                                4: Colors.lightGreenAccent,
                              },
                              colorMode: ColorMode.opacity,
                              textColor: Colors.black,
                              showColorTip: true,
                              scrollable: true,
                              onClick: (date) {
                                final value = habitData[date] ?? 0;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '$value habits on ${date.toLocal()}')),
                                );
                              },
                            ),
                          ),
                          // List of habits
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              itemCount: habits.length,
                              itemBuilder: (context, index) {
                                final habit = habits[index];
                                return ListTile(
                                  title: Text(habit.name),
                                  subtitle: Text(habit.completed
                                      ? 'Completed'
                                      : 'Not Completed'),
                                  trailing: Icon(
                                    habit.completed ? Icons.check : Icons.close,
                                    color: habit.completed
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Map<DateTime, int> getHabitData(List<Habit> habits) {
    final Map<DateTime, int> data = {};
    for (var habit in habits) {
      if (habit.completed) {
        final date = DateTime(
            habit.timestamp.year, habit.timestamp.month, habit.timestamp.day);
        data[date] = (data[date] ?? 0) + 1;
      }
    }
    return data;
  }
}
