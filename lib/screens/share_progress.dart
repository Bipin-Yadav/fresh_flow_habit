import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/habit_service.dart';
import '../models/habit.dart';
import '../widgets/main_navigation_bar.dart';

class ShareProgressPage extends StatefulWidget {
  const ShareProgressPage({super.key});

  @override
  State<ShareProgressPage> createState() => _ShareProgressPageState();
}

class _ShareProgressPageState extends State<ShareProgressPage> {
  final HabitService _habitService = HabitService();
  final GlobalKey _boundaryKey = GlobalKey();
  bool _isCapturing = false;

  String _today() {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Captures the widget inside the RepaintBoundary key as a PNG and returns its temporary File path
  Future<File?> _capturePngBytes() async {
    setState(() => _isCapturing = true);
    try {
      // Small delay to ensure any active rebuild frame settles
      await Future.delayed(const Duration(milliseconds: 100));

      final RenderRepaintBoundary boundary = _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0); // 3.0 pixel ratio for high-resolution graphics
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final File file = File('${tempDir.path}/habitflow_streak_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(pngBytes);
        return file;
      }
      return null;
    } catch (e) {
      print("Error capturing progress card: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate sharing image: $e')),
      );
      return null;
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  // Exports the generated PNG image using native share sheet overlay
  Future<void> _shareProgressCard() async {
    final File? imageFile = await _capturePngBytes();
    if (imageFile != null) {
      await Share.shareXFiles(
        [XFile(imageFile.path)],
        text: 'Check out my custom habit streak on HabitFlow! 🚀 Build better routines daily.',
      );
    }
  }

  // Captures the PNG image and copies it permanently to the gallery documents folder
  Future<void> _saveProgressCardToGallery() async {
    final File? imageFile = await _capturePngBytes();
    if (imageFile != null) {
      try {
        final docDir = await getApplicationDocumentsDirectory();
        final String permanentPath = '${docDir.path}/saved_habitflow_card_${DateTime.now().millisecondsSinceEpoch}.png';
        await imageFile.copy(permanentPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image saved successfully! 📸\nLocation: $permanentPath'),
            duration: const Duration(seconds: 4),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save to device gallery: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: StreamBuilder<List<Habit>>(
          stream: _habitService.streamAllHabits(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final habits = snapshot.data ?? [];
            
            // Dynamic stats aggregation
            final int totalHabits = habits.length;
            final int doneToday = habits.where((h) => h.completedDates.contains(_today())).length;
            final int streakDays = habits.isEmpty
                ? 0
                : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);

            // Compute exact Completion Rate of the past 7 days
            final now = DateTime.now();
            int weeklyCompletions = 0;
            int totalWeeklyPossible = habits.length * 7;
            
            for (var habit in habits) {
              for (int i = 0; i < 7; i++) {
                final checkDate = now.subtract(Duration(days: i));
                final dateStr = _formatDate(checkDate);
                if (habit.completedDates.contains(dateStr)) {
                  weeklyCompletions++;
                }
              }
            }
            final int thisWeekPercent = totalWeeklyPossible == 0 ? 0 : ((weeklyCompletions / totalWeeklyPossible) * 100).round();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Your Progress Card", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  
                  // RepaintBoundary intercepts the custom styled gradient card
                  RepaintBoundary(
                    key: _boundaryKey,
                    child: Container(
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
                  ),
                  const SizedBox(height: 18),
                  const Text("Share Options", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: _isCapturing
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.download),
                          label: const Text("Save Image"),
                          onPressed: _isCapturing ? null : _saveProgressCardToGallery,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16C9E6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: _isCapturing
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Color(0xFF16C9E6), strokeWidth: 2))
                              : const Icon(Icons.share),
                          label: const Text("Share Card"),
                          onPressed: _isCapturing ? null : _shareProgressCard,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF16C9E6),
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
                  _SocialShareButton(platform: "Instagram", icon: Icons.camera_alt, color: Colors.pink, onTap: _shareProgressCard),
                  _SocialShareButton(platform: "Twitter", icon: Icons.alternate_email, color: Colors.lightBlue, onTap: _shareProgressCard),
                  _SocialShareButton(platform: "Facebook", icon: Icons.facebook, color: Colors.blue, onTap: _shareProgressCard),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFCFF),
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
            );
          },
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
  final VoidCallback onTap;
  const _SocialShareButton({required this.platform, required this.icon, required this.color, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text("Share on $platform"),
        onTap: onTap,
      ),
    );
  }
}
