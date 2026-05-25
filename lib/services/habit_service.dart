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

  // Mark habit as completed/uncompleted for today and dynamically calculate streaks & metrics
  Future<void> toggleHabitCompletion(Habit habit) async {
    final todayStr = _getFormattedDate(DateTime.now());
    List<String> completedDates = List.from(habit.completedDates);

    if (completedDates.contains(todayStr)) {
      completedDates.remove(todayStr);
    } else {
      completedDates.add(todayStr);
    }

    // Dynamic calculations
    final int currentStreak = _calculateCurrentStreak(completedDates);
    final int bestStreak = _calculateBestStreak(completedDates);
    final int totalDone = completedDates.length;

    await userHabitsRef.doc(habit.id).update({
      'completedDates': completedDates,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalDone': totalDone,
    });
  }

  // Calculate the current consecutive streak (must end today or yesterday)
  int _calculateCurrentStreak(List<String> completedDates) {
    if (completedDates.isEmpty) return 0;

    final today = DateTime.now();
    final todayStr = _getFormattedDate(today);
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = _getFormattedDate(yesterday);

    if (!completedDates.contains(todayStr) && !completedDates.contains(yesterdayStr)) {
      return 0;
    }

    int currentStreak = 0;
    DateTime checkDate = completedDates.contains(todayStr) ? today : yesterday;

    while (completedDates.contains(_getFormattedDate(checkDate))) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return currentStreak;
  }

  // Calculate the best consecutive streak of all-time (normalized to UTC noon to be timezone/DST-proof)
  int _calculateBestStreak(List<String> completedDates) {
    if (completedDates.isEmpty) return 0;

    // Parse and normalize to UTC noon to eliminate timezone/DST rounding bugs
    final List<DateTime> dates = completedDates.map((d) {
      final parts = d.split('-');
      return DateTime.utc(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]), 12, 0, 0);
    }).toList();

    // Sort in ascending order
    dates.sort();

    int maxStreak = 1;
    int currentBlock = 1;

    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        currentBlock++;
      } else if (diff > 1) {
        if (currentBlock > maxStreak) {
          maxStreak = currentBlock;
        }
        currentBlock = 1;
      }
    }

    if (currentBlock > maxStreak) {
      maxStreak = currentBlock;
    }

    return maxStreak;
  }

  String _getFormattedDate(DateTime date) {
    return "${date.year.toString().padLeft(4,'0')}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
  }
}
