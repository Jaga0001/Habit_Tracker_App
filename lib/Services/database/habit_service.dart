import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_tracker_app/Services/database/habit_model.dart';

class HabitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Habit>> getHabitsStream(String userId) {
    return _firestore
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Habit.fromDocument(doc)).toList());
  }

  Future<void> addHabit(Habit habit) async {
    await _firestore.collection('habits').add(habit.toJson());
  }

  Future<void> updateHabit(Habit habit) async {
    await _firestore.collection('habits').doc(habit.id).update(habit.toJson());
  }

  Future<void> deleteHabit(String habitId) async {
    await _firestore.collection('habits').doc(habitId).delete();
  }
}
