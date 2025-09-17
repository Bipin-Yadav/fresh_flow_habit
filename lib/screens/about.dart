import 'package:flutter/material.dart';
import '../widgets/main_navigation_bar.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About HabitFlow'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Container(
                        width: 130,  // increase as needed
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF16C9E6).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/splash_bg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text("HabitFlow",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                      const Text("Version 1.0.0",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 12),
                      const Text(
                        "HabitFlow is designed to help you build and maintain healthy habits through consistent tracking, motivation, and progress visualization.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Icon(Icons.info_outlined, color: Color(0xFF16C9E6)),
                        SizedBox(width: 8),
                        Text("Key Features", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        Icon(Icons.show_chart, color: Color(0xFF16C9E6)),
                        const SizedBox(width: 6),
                        const Text("Progress Tracking", style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      const Padding(
                        padding: EdgeInsets.only(left: 40, top: 2, bottom: 10),
                        child: Text("Visual progress indicators and streak counters", style: TextStyle(color: Colors.grey)),
                      ),
                      Row(children: [
                        Icon(Icons.local_fire_department, color: Colors.orange),
                        const SizedBox(width: 6),
                        const Text("Streak Management", style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      const Padding(
                        padding: EdgeInsets.only(left: 40, top: 2, bottom: 10),
                        child: Text("Maintain your momentum with streak tracking", style: TextStyle(color: Colors.grey)),
                      ),
                      Row(children: [
                        Icon(Icons.phone_android, color: Colors.blue),
                        const SizedBox(width: 6),
                        const Text("Mobile Optimized", style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      const Padding(
                        padding: EdgeInsets.only(left: 40, top: 2, bottom: 5),
                        child: Text("Designed for seamless mobile experience", style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Icon(Icons.medical_services, color: Colors.cyan),
                        SizedBox(width: 8),
                        Text("Healthcare Partnership", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ]),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFECFCFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("True Heal Multispeciality Hospital", style: TextStyle(color: Color(0xFF16C9E6), fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("This app is developed in partnership with True Heal Multispeciality Hospital to support patient wellness and health tracking initiatives. Together, we're committed to promoting healthy lifestyle habits.", style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.verified_rounded, color: Colors.lightBlue, size: 18),
                          SizedBox(width: 5),
                          Text("Healthcare Focused", style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 16),
                          Icon(Icons.verified, color: Colors.green, size: 18),
                          SizedBox(width: 5),
                          Text("Wellness Certified", style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Icon(Icons.support_agent, color: Colors.cyan),
                        SizedBox(width: 8),
                        Text("Support & Contact", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ]),
                      const SizedBox(height: 8),
                      const Text("Need help?", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text(
                          "Visit our Help section for frequently asked questions and support guides.",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/help');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF16C9E6),
                            side: BorderSide(color: Color(0xFF16C9E6)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Visit Help Center"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "© 2024 HabitFlow. All rights reserved.\nMade with ❤️ for better health habits",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
