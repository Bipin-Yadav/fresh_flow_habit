import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';

class HabitService {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference userHabitsRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('habits');

  // Stream today's habits only (with real-time updates)
  Stream<List<Habit>> streamTodaysHabits() {
    final todayStr = _getFormattedDate(DateTime.now());
    return userHabitsRef
        .where('frequency', isEqualTo: 'Daily')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Habit.fromDocument(doc)).toList());
  }

  // Stream all habits (optionally filtered by category)
  Stream<List<Habit>> streamAllHabits({String? category}) {
    Query query = userHabitsRef;
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Habit.fromDocument(doc)).toList());
  }

  Future<void> addHabit(Habit habit) async {
    await userHabitsRef.add(habit.toMap());
  }

  Future<void> updateHabit(Habit habit) async {
    await userHabitsRef.doc(habit.id).update(habit.toMap());
  }

  Future<void> deleteHabit(String habitId) async {
    await userHabitsRef.doc(habitId).delete();
  }

  // Mark habit as completed/uncompleted for today
  Future<void> toggleHabitCompletion(Habit habit) async {
    final todayStr = _getFormattedDate(DateTime.now());
    List<String> completedDates = List.from(habit.completedDates);

    if (completedDates.contains(todayStr)) {
      completedDates.remove(todayStr);
    } else {
      completedDates.add(todayStr);
    }

    // Optional: You would calculate streaks here before saving,
    // but for initial version just update completedDates
    await userHabitsRef.doc(habit.id).update({'completedDates': completedDates});
  }

  String _getFormattedDate(DateTime date) {
    return "${date.year.toString().padLeft(4,'0')}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
  }
}
