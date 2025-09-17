import 'package:flutter/material.dart';
import '../widgets/main_navigation_bar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const Icon(Icons.email, color: Color(0xFF16C9E6), size: 30),
                        title: const Text('Email Support', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Contact Us'),
                        onTap: () {
                          // TODO: Add email logic
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const Icon(Icons.chat_bubble_outline, color: Colors.cyan, size: 30),
                        title: const Text('Live Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Start Chat'),
                        onTap: () {
                          // TODO: Add live chat logic
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(children: const [
                Icon(Icons.help_outline, color: Color(0xFF16C9E6)),
                SizedBox(width: 8),
                Text("Frequently Asked Questions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ]),
              const SizedBox(height: 12),
              _FaqCard(
                question: "How do I create a new habit?",
                answer: "Tap the '+' button on the dashboard or go to the Habits page and tap 'Add New Habit'. Fill in the habit details and save.",
              ),
              _FaqCard(
                question: "What happens if I miss a day?",
                answer: "Don't worry! Missing one day won't reset your progress. Your streak will pause, but you can continue building it the next day.",
              ),
              _FaqCard(
                question: "How do I delete a habit?",
                answer: "Go to the habit details page and tap the edit button. You'll find the delete option at the bottom of the edit form.",
              ),
              _FaqCard(
                question: "Can I change my habit frequency?",
                answer: "Yes! Edit your habit and change the frequency from daily to weekly or vice versa anytime.",
              ),
              const SizedBox(height: 20),
              Row(children: const [
                Icon(Icons.import_contacts, color: Color(0xFF16C9E6)),
                SizedBox(width: 8),
                Text("Resources", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
              const SizedBox(height: 12),
              _ResourceItem(label: "User Guide"),
              _ResourceItem(label: "Video Tutorials"),
              _ResourceItem(label: "Community Forum"),
              _ResourceItem(label: "Habit Building Tips"),
              const SizedBox(height: 14),
              Row(children: const [
                Icon(Icons.star_border, color: Colors.cyan),
                SizedBox(width: 8),
                Text("Feedback", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
              const SizedBox(height: 12),
              _FeedbackItem(label: "Rate the App"),
              _FeedbackItem(label: "Send Feedback"),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  "Habit Tracker\nVersion 1.0.0\nNeed more help? We're here to assist you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
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

class _FaqCard extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqCard({required this.question, required this.answer, super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(answer, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _ResourceItem extends StatelessWidget {
  final String label;
  const _ResourceItem({required this.label, super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.link, color: Color(0xFF16C9E6)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.open_in_new, color: Colors.grey),
      onTap: () {
        // TODO: Add resource/action logic
      },
    );
  }
}

class _FeedbackItem extends StatelessWidget {
  final String label;
  const _FeedbackItem({required this.label, super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.rate_review, color: Colors.cyan),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        // TODO: Implement feedback or rating logic
      },
    );
  }
}
