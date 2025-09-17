import 'package:flutter/material.dart';
import '../widgets/main_navigation_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Main
  bool allNotifications = true;

  // Daily Reminders
  bool morningReminder = true;
  TimeOfDay morningTime = const TimeOfDay(hour: 9, minute: 0);

  bool eveningReminder = true;
  TimeOfDay eveningTime = const TimeOfDay(hour: 20, minute: 0);

  // Progress Notifications
  bool streakMilestones = true;
  bool habitCompletion = true;
  bool weeklySummary = false;

  // Motivation
  bool dailyQuotes = true;
  bool encouragement = true;

  // Sound & Vibration
  bool sound = true;

  // Helper for picking times
  Future<void> _pickTime(BuildContext context, bool isMorning) async {
    final initialTime = isMorning ? morningTime : eveningTime;
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (isMorning) {
          morningTime = picked;
        } else {
          eveningTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatTime(TimeOfDay t) {
      final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
      final minute = t.minute.toString().padLeft(2, '0');
      final period = t.period == DayPeriod.am ? 'AM' : 'PM';
      return "$hour:$minute $period";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Customize your reminder settings",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: Color(0xFF16C9E6)),
                  title: const Text("All Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Turn all notifications on/off"),
                  value: allNotifications,
                  onChanged: (val) => setState(() => allNotifications = val),
                  activeColor: const Color(0xFF16C9E6),
                ),
              ),
              const SizedBox(height: 12),
              _SectionTitle(label: "Daily Reminders", icon: Icons.today),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Morning Reminder", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Start your day with habits"),
                      value: morningReminder,
                      onChanged: (val) => setState(() => morningReminder = val),
                      activeColor: const Color(0xFF16C9E6),
                    ),
                    // Time picker
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: GestureDetector(
                        onTap: () => _pickTime(context, true),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                              color: const Color(0xFFECFCFF),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatTime(morningTime), style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Evening Reminder", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Review your daily progress"),
                      value: eveningReminder,
                      onChanged: (val) => setState(() => eveningReminder = val),
                      activeColor: const Color(0xFF16C9E6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: GestureDetector(
                        onTap: () => _pickTime(context, false),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                              color: const Color(0xFFECFCFF),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatTime(eveningTime), style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionTitle(label: "Progress Notifications", icon: Icons.flash_on),
              _NotiSwitch(
                  label: "Streak Milestones",
                  subtitle: "Celebrate when you reach 7, 30, 100 days",
                  value: streakMilestones,
                  onChanged: (val) => setState(() => streakMilestones = val)),
              _NotiSwitch(
                  label: "Habit Completion",
                  subtitle: "Get notified when you complete all habits",
                  value: habitCompletion,
                  onChanged: (val) => setState(() => habitCompletion = val)),
              _NotiSwitch(
                  label: "Weekly Summary",
                  subtitle: "Sunday summary of your week",
                  value: weeklySummary,
                  onChanged: (val) => setState(() => weeklySummary = val)),
              const SizedBox(height: 12),
              _SectionTitle(label: "Motivation", icon: Icons.mood),
              _NotiSwitch(
                  label: "Daily Quotes",
                  subtitle: "Inspirational quotes to keep you going",
                  value: dailyQuotes,
                  onChanged: (val) => setState(() => dailyQuotes = val)),
              _NotiSwitch(
                  label: "Encouragement",
                  subtitle: "Motivational messages when you miss a day",
                  value: encouragement,
                  onChanged: (val) => setState(() => encouragement = val)),
              const SizedBox(height: 12),
              _SectionTitle(label: "Sound & Vibration", icon: Icons.volume_up),
              _NotiSwitch(
                  label: "Sound",
                  subtitle: "Play sound for notifications",
                  value: sound,
                  onChanged: (val) => setState(() => sound = val)),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: 3,
        onItemTapped: (index) {
          String route = '';
          switch (index) {
            case 0: route = '/dashboard'; break;
            case 1: route = '/habits'; break;
            case 2: route = '/profile'; break;
            case 3: route = '/more'; break;
          }
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionTitle({required this.label, required this.icon, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF16C9E6)),
        const SizedBox(width: 7),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ],
    );
  }
}

class _NotiSwitch extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _NotiSwitch({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF16C9E6),
      ),
    );
  }
}
