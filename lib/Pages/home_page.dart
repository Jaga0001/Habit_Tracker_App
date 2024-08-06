import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker_app/Components/my_add_habit.dart';
import 'package:habit_tracker_app/Services/auth/auth_services.dart';
import 'package:habit_tracker_app/Services/database/habit_service.dart';
import 'package:habit_tracker_app/Services/database/habit_model.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HabitService _habitService = HabitService();

  void signOut() {
    AuthServices _auth = AuthServices();
    _auth.signOut();
  }

  void _showAddHabitDialog(BuildContext context) {
    showAddHabitDialog(context);
  }

  void _updateHabit(BuildContext context, Habit habit) async {
    final TextEditingController _nameController =
        TextEditingController(text: habit.name);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Habit'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Habit Name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedName = _nameController.text.trim();
                if (updatedName.isNotEmpty) {
                  final updatedHabit = habit.copyWith(name: updatedName);
                  await _habitService.updateHabit(updatedHabit);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteHabit(BuildContext context, Habit habit) async {
    await _habitService.deleteHabit(habit.id);
  }

  void _toggleCompletion(Habit habit, bool? value) async {
    final updatedHabit = habit.copyWith(
      completed: value ?? !habit.completed,
    );
    await _habitService.updateHabit(updatedHabit);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
          : StreamBuilder<List<Habit>>(
              stream: _habitService.getHabitsStream(user.uid),
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
                    // Custom HeatMap widget
                    Expanded(
                      child: Column(
                        children: [
                          // Month header
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              DateFormat('MMMM yyyy').format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // HeatMap widget
                          Expanded(
                            child: HeatMap(
                              startDate:
                                  DateTime.now().subtract(Duration(days: 7)),
                              endDate: DateTime.now(),
                              datasets: habitData,
                              colorMode: ColorMode.color,
                              size: 30,
                              colorsets: const {
                                1: Color.fromARGB(255, 212, 250, 169),
                                2: Colors.lightGreen,
                                3: Color.fromARGB(255, 121, 188, 46),
                                4: Color.fromARGB(255, 136, 255, 0),
                                5: Color.fromARGB(255, 0, 255, 8)
                              },
                              textColor: Colors.black,
                              showColorTip: false,
                              showText: true,
                              scrollable: true,
                              onClick: (date) {
                                final value = habitData[date] ?? 0;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '$value habits on ${DateFormat('dd MMM yyyy').format(date.toLocal())}')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // List of habits
                    Expanded(
                      child: ListView.builder(
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          final habit = habits[index];
                          return Slidable(
                            key: Key(habit.id),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) =>
                                      _updateHabit(context, habit),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Update',
                                ),
                                SlidableAction(
                                  onPressed: (context) =>
                                      _deleteHabit(context, habit),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ListTile(
                                leading: Checkbox(
                                  value: habit.completed,
                                  onChanged: (value) =>
                                      _toggleCompletion(habit, value),
                                ),
                                title: Text(habit.name),
                                subtitle: Text(habit.completed
                                    ? 'Completed'
                                    : 'Not Completed'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
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
