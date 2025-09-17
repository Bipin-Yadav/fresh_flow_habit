import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String name;
  final String category;
  final String color;
  final String frequency;
  final int currentStreak;
  final int bestStreak;
  final int totalDone;
  final int perWeek;
  final String notes;
  final List<String> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.frequency,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalDone,
    required this.perWeek,
    required this.notes,
    required this.completedDates,
  });

  factory Habit.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      color: data['color'] ?? '#16C9E6',
      frequency: data['frequency'] ?? 'Daily',
      currentStreak: data['currentStreak'] ?? 0,
      bestStreak: data['bestStreak'] ?? 0,
      totalDone: data['totalDone'] ?? 0,
      perWeek: data['perWeek'] ?? 0,
      notes: data['notes'] ?? '',
      completedDates: List<String>.from(data['completedDates'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'color': color,
      'frequency': frequency,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalDone': totalDone,
      'perWeek': perWeek,
      'notes': notes,
      'completedDates': completedDates,
    };
  }
}
