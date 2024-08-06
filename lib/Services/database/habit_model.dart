import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String userId;
  final String name;
  final bool completed;
  final DateTime timestamp;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.completed,
    required this.timestamp,
  });

  factory Habit.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      completed: data['completed'] ?? false,
      timestamp: (data['timestamp'] as Timestamp)
          .toDate(), // Convert Firestore timestamp to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'completed': completed,
      'timestamp': Timestamp.fromDate(
          timestamp), // Convert DateTime to Firestore timestamp
    };
  }
}
