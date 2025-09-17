import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../widgets/main_navigation_bar.dart';

class HabitsPage extends StatelessWidget {
  final HabitService habitService = HabitService();

  HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
      ),
      body: StreamBuilder<List<Habit>>(
        stream: habitService.streamTodaysHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final habits = snapshot.data ?? [];
          if (habits.isEmpty) {
            return const Center(child: Text('No habits found.'));
          }
          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return HabitListTile(habit: habit, habitService: habitService);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-habit');
        },
        label: const Text('Add Habit'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF16C9E6),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: 2, // 0: Dashboard, 1: Habits, 2: Profile, 3: More
        onItemTapped: (index) {
          String route = '';
          switch(index) {
            case 0:
              route = '/dashboard';
              break;
            case 1:
              route = '/habits';
              break;
            case 2:
              route = '/profile';
              break;
            case 3:
              route = '/more'; // Add this route when more screen exists
              break;
          }
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        },

      ),

    );
  }
}

class HabitListTile extends StatelessWidget {
  final Habit habit;
  final HabitService habitService;

  const HabitListTile({required this.habit, required this.habitService, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isCompleteToday = habit.completedDates.contains(_getToday());

    return Slidable(
      key: Key(habit.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (ctx) async {
              await habitService.toggleHabitCompletion(habit);
            },
            backgroundColor: isCompleteToday ? Colors.grey : Colors.green,
            foregroundColor: Colors.white,
            icon: isCompleteToday ? Icons.undo : Icons.check,
            label: isCompleteToday ? 'Undo' : 'Complete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        children: [
          SlidableAction(
            onPressed: (ctx) {
              Navigator.pushNamed(context, '/habits/${habit.id}/edit', arguments: habit);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (ctx) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Habit'),
                  content: Text('Are you sure you want to delete "${habit.name}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await habitService.deleteHabit(habit.id);
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(_hexToInt(habit.color)),
          child: const Icon(Icons.bolt, color: Colors.white),
        ),
        title: Text(habit.name),
        subtitle: Row(
          children: [
            const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text('${habit.currentStreak} days'),
            const SizedBox(width: 16),
            Text(habit.frequency),
          ],
        ),
        trailing: Icon(
          isCompleteToday ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleteToday ? Colors.green : Colors.grey,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/habits/${habit.id}', arguments: habit);
        },
      ),
    );
  }

  String _getToday() {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  int _hexToInt(String hex) {
    // Parse hex color string like '#16C9E6' to integer
    return int.parse(hex.replaceFirst('#', '0xff'));
  }
}
