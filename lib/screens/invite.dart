import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For copy
import 'package:share_plus/share_plus.dart'; // Add to pubspec.yaml

import '../widgets/main_navigation_bar.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({super.key});

  final appLink = 'https://habittracker.app/invite';

  void _shareApp(BuildContext context) {
    Share.share('Join me on HabitFlow! Track your habits with me: $appLink');
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: appLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/invite_image.png',
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Build Habits Together! 🤝",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Invite your friends and family to join you on your habit-building journey. Everything is better when shared!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 18),
              _InviteFeatureCard(
                imagePath: "assets/splash_bg.png",
                label: "Stay Motivated Together",
                subtitle: "Share your progress and cheer each other on",
              ),

              _InviteFeatureCard(
                icon: Icons.emoji_events,
                label: "Celebrate Milestones",
                subtitle: "Achieve goals together and celebrate wins",
              ),
              _InviteFeatureCard(
                icon: Icons.volunteer_activism,
                label: "Build Accountability",
                subtitle: "Keep each other on track with gentle reminders",
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share App Link"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16C9E6),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () => _shareApp(context),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text("Copy Link"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF16C9E6),
                    side: const BorderSide(color: Color(0xFF16C9E6)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () => _copyLink(context),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFCFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Share this link:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(appLink, style: const TextStyle(color: Color(0xFF16C9E6))),
                  ],
                ),
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

class _InviteFeatureCard extends StatelessWidget {
  final String? imagePath; // optional custom image
  final IconData? icon;    // optional fallback icon
  final String label;
  final String subtitle;

  const _InviteFeatureCard({
    this.imagePath,
    this.icon,
    required this.label,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFECFCFF),
          child: imagePath != null
              ? Image.asset(imagePath!, width: 26, height: 26) // your logo here
              : Icon(icon, color: const Color(0xFF16C9E6)),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

