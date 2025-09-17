import 'package:flutter/material.dart';
import '../widgets/main_navigation_bar.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  // Example switches
  bool analytics = true;
  bool crashReports = true;
  bool ads = false;
  bool publicProfile = false;
  bool shareProgress = false;
  bool twoFactor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
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
              const SizedBox(height: 12),
              const Text("Manage your data and security settings", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 18),
              _SectionTitle(label: "Data Privacy", icon: Icons.data_usage),
              _SettingsSwitchTile(
                label: "Analytics",
                subtitle: "Help improve the app with usage data",
                value: analytics,
                onChanged: (val) => setState(() => analytics = val),
              ),
              _SettingsSwitchTile(
                label: "Crash Reports",
                subtitle: "Send crash reports to help fix bugs",
                value: crashReports,
                onChanged: (val) => setState(() => crashReports = val),
              ),
              _SettingsSwitchTile(
                label: "Personalized Ads",
                subtitle: "Show ads based on your interests",
                value: ads,
                onChanged: (val) => setState(() => ads = val),
              ),
              const SizedBox(height: 20),
              _SectionTitle(label: "Sharing", icon: Icons.share),
              _SettingsSwitchTile(
                label: "Public Profile",
                subtitle: "Make your profile visible to others",
                value: publicProfile,
                onChanged: (val) => setState(() => publicProfile = val),
              ),
              _SettingsSwitchTile(
                label: "Share Progress",
                subtitle: "Allow others to see your habit progress",
                value: shareProgress,
                onChanged: (val) => setState(() => shareProgress = val),
              ),
              const SizedBox(height: 20),
              _SectionTitle(label: "Security", icon: Icons.lock),
              Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: Icon(Icons.password, color: Color(0xFF16C9E6)),
                    title: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Update your account password"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                    onTap: () {
                      // TODO: Add change password workflow
                    },
                  )
              ),
              _SettingsSwitchTile(
                label: "Two-Factor Authentication",
                subtitle: "Add extra security to your account",
                value: twoFactor,
                onChanged: (val) => setState(() => twoFactor = val),
              ),
              const SizedBox(height: 20),
              _SectionTitle(label: "Data Management", icon: Icons.remove_red_eye),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  title: const Text("Download My Data", style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    // TODO: Add download my data logic
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  title: const Text("Delete All Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  onTap: () {
                    // TODO: Add delete all data logic
                  },
                ),
              ),
              const SizedBox(height: 14),
              const Text("Privacy Policy", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)),
              const SizedBox(height: 4),
              const Text("Terms of Service", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)),
              const SizedBox(height: 22),
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

// --- Reuse these helper widgets ---
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
