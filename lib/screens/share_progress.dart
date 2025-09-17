import 'package:flutter/material.dart';
import '../widgets/main_navigation_bar.dart';

class ShareProgressPage extends StatelessWidget {
  const ShareProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example stats; replace with actual data as needed
    final int streakDays = 15;
    final int totalHabits = 8;
    final int doneToday = 6;
    final int thisWeekPercent = 85;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Progress'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Progress Card", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF16C9E6), Color(0xFF37DCFF)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 34),
                    Text("$streakDays Days", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white)),
                    const Text("Current Streak!", style: TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 8),
                    const Text("Building better habits every day", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ProgressStat(label: "Total Habits", value: "$totalHabits"),
                        _ProgressStat(label: "Done Today", value: "$doneToday"),
                        _ProgressStat(label: "This Week", value: "$thisWeekPercent%"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text("Made with Habit Tracker App", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text("Share Options", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text("Save Image"),
                      onPressed: () {
                        // TODO: implement share/screenshot
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF16C9E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text("Share Link"),
                      onPressed: () {
                        // TODO: implement sharing link
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF16C9E6),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: const BorderSide(color: Color(0xFF16C9E6)),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 22),
              const Text("Share on Social", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              _SocialShareButton(platform: "Instagram", icon: Icons.camera_alt, color: Colors.pink),
              _SocialShareButton(platform: "Twitter", icon: Icons.alternate_email, color: Colors.lightBlue),
              _SocialShareButton(platform: "Facebook", icon: Icons.facebook, color: Colors.blue),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFECFCFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: const [
                    Icon(Icons.rocket_launch, color: Color(0xFF16C9E6)),
                    SizedBox(width: 6),
                    Expanded(child: Text("Keep Going! 🚀\nSharing your progress helps keep you accountable and inspires others to build better habits too.", style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
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

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProgressStat({required this.label, required this.value, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}

class _SocialShareButton extends StatelessWidget {
  final String platform;
  final IconData icon;
  final Color color;
  const _SocialShareButton({required this.platform, required this.icon, required this.color, super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text("Share on $platform"),
        onTap: () {
          // TODO: implement platform-specific sharing (url_launcher, share_plus, etc)
        },
      ),
    );
  }
}
