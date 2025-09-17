import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class HabitDetailPage extends StatefulWidget {
  final Habit habit;

  const HabitDetailPage({required this.habit, super.key});

  @override
  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  late Habit habit;
  final HabitService habitService = HabitService();

  @override
  void initState() {
    super.initState();
    habit = widget.habit;
  }

  bool isCompleteOnDay(DateTime day) {
    final dayStr = _formatDate(day);
    return habit.completedDates.contains(dayStr);
  }

  String _formatDate(DateTime day) {
    return "${day.year.toString().padLeft(4,'0')}-${day.month.toString().padLeft(2,'0')}-${day.day.toString().padLeft(2,'0')}";
  }

  double get completionRate {
    final totalDays = habit.completedDates.length;
    final totalPossible = habit.frequency == 'Daily' ? 7 : 1; // for a week
    return totalPossible > 0 ? (totalDays / totalPossible) : 0;
  }

  Future<void> markComplete() async {
    await habitService.toggleHabitCompletion(habit);
    final updatedHabit = await habitService.userHabitsRef.doc(habit.id).get();
    setState(() {
      habit = Habit.fromDocument(updatedHabit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = List.generate(7, (index) {
      final now = DateTime.now();
      return now.subtract(Duration(days: now.weekday - 1 - index));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        backgroundColor: const Color(0xFF16C9E6),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/habits/${habit.id}/edit', arguments: habit);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  // Circular progress
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: completionRate,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ),
                        Center(
                          child: Text('${(completionRate * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Completion Rate", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(icon: Icons.local_fire_department, label: 'Current Streak', value: habit.currentStreak.toString()),
                _StatCard(icon: Icons.emoji_events, label: 'Best Streak', value: habit.bestStreak.toString()),
                _StatCard(icon: Icons.done_all, label: 'Total Done', value: habit.totalDone.toString()),
                _StatCard(icon: Icons.calendar_today, label: 'Per Week', value: habit.perWeek.toString()),
              ],
            ),
            const SizedBox(height: 20),
            const Text("This Week", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: daysOfWeek.map((day) {
                final isDone = isCompleteOnDay(day);
                final dayLabel = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1];
                return Column(
                  children: [
                    Text(dayLabel),
                    const SizedBox(height: 4),
                    Icon(Icons.check_circle, color: isDone ? Colors.green : Colors.grey),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(habit.notes.isEmpty ? 'No notes added.' : habit.notes),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: markComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16C9E6),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Mark as Complete', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/habits/${habit.id}/edit', arguments: habit);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFF16C9E6)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Edit Habit', style: TextStyle(fontSize: 18, color: Color(0xFF16C9E6))),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({required this.icon, required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    const iconSize = 30.0;
    return Column(
      children: [
        Icon(icon, size: iconSize, color: Colors.orange),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
