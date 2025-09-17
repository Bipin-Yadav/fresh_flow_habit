import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/habit_service.dart';
import '../models/habit.dart';
import '../widgets/main_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("ProfilePage build started");

    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? (user?.email?.split('@')[0] ?? 'User');
    final initials = (name.isNotEmpty)
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'U';
    final memberSince = user?.metadata.creationTime;
    final memberSinceStr =
    memberSince != null ? 'Member since ${_monthYear(memberSince)}' : '';

    final habitService = HabitService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF16C9E6),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 12),
              CircleAvatar(
                backgroundColor: const Color(0xFF16C9E6),
                radius: 40,
                child: Text(
                  initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                memberSinceStr,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              StreamBuilder<List<Habit>>(
                stream: habitService.streamAllHabits(),
                builder: (context, snapshot) {
                  print("Profile habits snapshot state: ${snapshot.connectionState}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Error loading habits: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  final habits = snapshot.data ?? [];
                  print("Habits loaded count: ${habits.length}");

                  final totalStreakDays =
                  habits.fold(0, (sum, h) => sum + h.currentStreak);
                  final longestStreak = habits.isEmpty
                      ? 0
                      : habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);
                  final completed = habits.fold(0, (sum, h) => sum + h.totalDone);
                  final activeHabits = habits.length;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatBlock(
                          icon: Icons.local_fire_department,
                          color: Colors.orange,
                          value: totalStreakDays,
                          label: "Total Streak Days"),
                      _StatBlock(
                          icon: Icons.emoji_events,
                          color: Colors.yellow[700]!,
                          value: longestStreak,
                          label: "Longest Streak"),
                      _StatBlock(
                          icon: Icons.check_box,
                          color: Colors.green,
                          value: completed,
                          label: "Habits Completed"),
                      _StatBlock(
                          icon: Icons.list_alt,
                          color: Colors.blue,
                          value: activeHabits,
                          label: "Active Habits"),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF16C9E6), Color(0xFF37DCFF)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.emoji_events, color: Colors.white, size: 30),
                    SizedBox(height: 6),
                    Text('Habit Hero! 🏆',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    Text("You're on fire! Keep up the amazing work.",
                        style:
                        TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _ProfileActionButton(
                label: "Edit Profile",
                icon: Icons.edit,
                onTap: () => Navigator.pushNamed(context, '/profile/edit'),
              ),
              _ProfileActionButton(
                label: "Share Progress",
                icon: Icons.share,
                onTap: () => Navigator.pushNamed(context, '/share'),
              ),
              _ProfileActionButton(
                label: "Settings",
                icon: Icons.settings,
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              _ProfileActionButton(
                label: "Logout",
                icon: Icons.logout,
                color: Colors.red,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/auth');
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Habit Tracker v1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: 2, // 0: Dashboard, 1: Habits, 2: Profile, 3: More
        onItemTapped: (index) {
          String route = '';
          switch (index) {
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
              route = '/more'; // Add when 'more' exists
              break;
          }
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        },
      ),
    );
  }

  static String _monthYear(DateTime dt) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return "${months[dt.month - 1]} ${dt.year}";
  }
}

class _StatBlock extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;

  const _StatBlock({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 3),
        Text(value.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ProfileActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = Colors.black,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label,
          style: TextStyle(
            color: color,
            fontWeight: label == "Logout" ? FontWeight.bold : FontWeight.normal,
          )),
      onTap: onTap,
    );
  }
}
