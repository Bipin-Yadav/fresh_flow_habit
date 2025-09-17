import 'package:flutter/material.dart';
import '../widgets/main_navigation_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dailyReminders = true;
  bool streakAlerts = true;
  bool weeklySummary = false;
  bool darkMode = false;
  bool hapticFeedback = true;
  bool soundEffects = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
              const SizedBox(height: 8),
              const Text("Customize your app experience", style: TextStyle(color: Colors.grey, fontSize: 15)),
              const SizedBox(height: 18),
              _SectionTitle(label: "Notifications", icon: Icons.notifications),
              _SettingsSwitchTile(
                label: "Daily Reminders",
                subtitle: "Get reminded to complete your habits",
                value: dailyReminders,
                onChanged: (val) => setState(() => dailyReminders = val),
              ),
              _SettingsSwitchTile(
                label: "Streak Alerts",
                subtitle: "Celebrate when you reach milestones",
                value: streakAlerts,
                onChanged: (val) => setState(() => streakAlerts = val),
              ),
              _SettingsSwitchTile(
                label: "Weekly Summary",
                subtitle: "Get your weekly progress report",
                value: weeklySummary,
                onChanged: (val) => setState(() => weeklySummary = val),
              ),
              const SizedBox(height: 22),
              _SectionTitle(label: "Appearance", icon: Icons.brightness_4),
              _SettingsSwitchTile(
                label: "Dark Mode",
                subtitle: "Switch to dark theme",
                value: darkMode,
                onChanged: (val) => setState(() => darkMode = val),
              ),
              const SizedBox(height: 22),
              _SectionTitle(label: "Privacy", icon: Icons.lock),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: Icon(Icons.security, color: Color(0xFF16C9E6)),
                  title: const Text("Privacy & Security", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Manage your data and security"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/privacy');
                  },
                ),
              ),
              const SizedBox(height: 22),
              _SectionTitle(label: "Advanced", icon: Icons.phone_android),
              _SettingsSwitchTile(
                label: "Haptic Feedback",
                subtitle: "Feel vibrations on interactions",
                value: hapticFeedback,
                onChanged: (val) => setState(() => hapticFeedback = val),
              ),
              _SettingsSwitchTile(
                label: "Sound Effects",
                subtitle: "Play sounds for actions",
                value: soundEffects,
                onChanged: (val) => setState(() => soundEffects = val),
              ),
              const SizedBox(height: 30),
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

class _SettingsSwitchTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsSwitchTile({
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
        activeColor: Color(0xFF16C9E6),
      ),
    );
  }
}
