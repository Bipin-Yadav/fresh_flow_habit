import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/habit_service.dart';
import '../models/habit.dart';
import '../widgets/main_navigation_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final HabitService habitService = HabitService();
  final List<String> _quotes = [
    "You're building something amazing! 🚀",
    "Small steps every day lead to big changes.",
    "Consistency is the key to success!",
    "Your future self will thank you.",
    "Keep going—you’re on the right track!",
    "Habit is the daily battleground of character.",
    "Every accomplishment starts with the decision to try."
  ];

  late String _motivationMessage;

  @override
  void initState() {
    super.initState();
    _motivationMessage = _getRandomQuote();
  }

  String _getRandomQuote() {
    _quotes.shuffle();
    return _quotes.first;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning! 👋";
    if (hour >= 12 && hour < 17) return "Good Afternoon! 🌞";
    if (hour >= 17 && hour < 21) return "Good Evening! 🌅";
    return "Good Night! 🌙";
  }

  String _getFormattedDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Habit>>(
          stream: habitService.streamTodaysHabits(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading habits: ${snapshot.error}'));
            }

            final habits = snapshot.data ?? [];
            final totalHabits = habits.length;
            final completedCount =
                habits.where((h) => h.completedDates.contains(_today())).length;

            final progressPercent =
            totalHabits == 0 ? 0.0 : completedCount / totalHabits;
            final dayStreak = habits.isEmpty
                ? 0
                : habits
                .map((h) => h.currentStreak)
                .reduce((a, b) => a > b ? a : b);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _getFormattedDate(DateTime.now()),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: progressPercent,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF16C9E6)),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${(progressPercent * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text(
                                "Today's Progress",
                                style:
                                TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCard(
                          icon: Icons.local_fire_department,
                          label: "Day Streak",
                          value: dayStreak.toString()),
                      _StatCard(
                          icon: Icons.check_circle,
                          label: "Completed",
                          value: completedCount.toString()),
                      _StatCard(
                          icon: Icons.list,
                          label: "Total Habits",
                          value: totalHabits.toString()),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF16C9E6), Color(0xFF37DCFF)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _motivationMessage,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Today's Focus",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/habits');
                        },
                        child: const Text(
                          "View All",
                          style: TextStyle(
                              color: Color(0xFF16C9E6),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: habits.map((habit) {
                      final bool isDoneToday =
                      habit.completedDates.contains(_today());
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(
                            Icons.circle,
                            color: Color(_hexToInt(habit.color)),
                            size: 18,
                          ),
                          title: Text(habit.name),
                          trailing: Icon(
                            isDoneToday
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isDoneToday ? Colors.green : Colors.grey,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/habits/${habit.id}',
                                arguments: habit);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add-habit');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Habit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16C9E6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: 0, // 0: Dashboard
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/habits');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/more');
              break;
          }
        },
      ),
    );
  }

  String _today() {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  int _hexToInt(String hex) {
    return int.parse(hex.replaceFirst('#', '0xff'));
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard(
      {required this.icon, required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.orange),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
