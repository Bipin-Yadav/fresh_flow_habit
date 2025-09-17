import 'package:flutter/material.dart';
import '../widgets/main_navigation_bar.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                "Settings, help, and additional features",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 18),
              _MoreMenuItem(
                icon: Icons.settings,
                label: "Settings",
                subtitle: "App preferences and notifications",
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              _MoreMenuItem(
                icon: Icons.person_add_alt_1,
                label: "Invite Friends",
                subtitle: "Share the app with friends",
                onTap: () {
                  Navigator.pushNamed(context, '/invite');
                  // Or use share plugin for direct share
                },
              ),
              _MoreMenuItem(
                icon: Icons.share,
                label: "Share Progress",
                subtitle: "Share your achievements",
                onTap: () {
                  Navigator.pushNamed(context, '/progress');
                },
              ),
              _MoreMenuItem(
                icon: Icons.lock,
                label: "Privacy & Security",
                subtitle: "Manage your account security",
                onTap: () {
                  Navigator.pushNamed(context, '/privacy');
                },
              ),
              _MoreMenuItem(
                icon: Icons.notifications,
                label: "Notifications",
                subtitle: "Reminder settings",
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              _MoreMenuItem(
                icon: Icons.help_outline,
                label: "Help & Support",
                subtitle: "Get help and contact support",
                onTap: () {
                  Navigator.pushNamed(context, '/help');
                },
              ),
              _MoreMenuItem(
                icon: Icons.info_outline,
                label: "About HabitFlow",
                subtitle: "Learn more about the app",
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: const [
                    Text(
                      "Made with ❤️ for better habits",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Version 1.0.0 • © 2024 Habit Tracker",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: 3,
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
              route = '/more';
              break;
          }
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        },
      ),
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _MoreMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFECFCFF),
          child: Icon(icon, color: Color(0xFF16C9E6)),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
