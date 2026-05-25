import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_flow_habit/screens/notifications.dart';
import 'package:fresh_flow_habit/screens/share_progress.dart';
import 'package:share_plus/share_plus.dart';
import 'firebase_options.dart';
import 'screens/edit_profile.dart';


// Import your new SplashScreen file
import 'screens/splash.dart';

// Your existing screen imports
import 'screens/auth.dart';
import 'screens/dashboard.dart';
import 'screens/habits.dart';
import 'screens/add_habit.dart';
import 'screens/habit_detail.dart';
import 'screens/edit_habit.dart';
import 'screens/profile.dart';
import 'screens/more.dart';
import 'screens/settings.dart';
import 'screens/invite.dart';
import 'screens/privacy.dart';
import 'screens/about.dart';
import 'screens/help.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HabitFlow',
      theme: ThemeData(
        primaryColor: const Color(0xFF16C9E6),
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);

        // This condition now correctly routes to the SplashScreen imported from the other file.
        if (uri.pathSegments.isEmpty) {
          return MaterialPageRoute(builder: (_) => const SplashScreen());
        }

        if (uri.pathSegments.length == 1) {
          final first = uri.pathSegments[0];
          switch (first) {
            case 'auth':
              return MaterialPageRoute(builder: (_) => const AuthPage());
            case 'dashboard':
              return MaterialPageRoute(builder: (_) => const Dashboard());
            case 'habits':
              return MaterialPageRoute(builder: (_) => HabitsPage());
            case 'add-habit':
              return MaterialPageRoute(builder: (_) => const AddHabitPage());
            case 'profile':
              return MaterialPageRoute(builder: (_) => const ProfilePage());
            case 'more':
              return MaterialPageRoute(builder: (_) => const MorePage());
            case 'settings':
              return MaterialPageRoute(builder: (_) => const SettingsPage());
            case 'privacy':
              return MaterialPageRoute(builder: (_) => const PrivacyPage());
            case 'about':
              return MaterialPageRoute(builder: (_) => const AboutPage());
            case 'help':
              return MaterialPageRoute(builder: (_) => const HelpPage());
            case 'invite':
              return MaterialPageRoute(builder: (_) => const InvitePage());
            case 'progress':
              return MaterialPageRoute(builder: (_) => const ShareProgressPage());
            case 'notifications':
              return MaterialPageRoute(builder: (_) => const NotificationsPage());
            case 'share':
              return MaterialPageRoute(builder: (_) => ShareProgressPage());
            case 'profile/edit':
              return MaterialPageRoute(builder: (_) => EditProfilePage());
            default:
              break;
          }
        }

        if (uri.pathSegments.length == 2) {
          final id = uri.pathSegments[1];
          if (uri.pathSegments[0] == 'habits') {
            final habit = settings.arguments as dynamic;
            return MaterialPageRoute(builder: (_) => HabitDetailPage(habit: habit));
          }
        }

        if (uri.pathSegments.length == 3) {
          final id = uri.pathSegments[1];
          final action = uri.pathSegments[2];
          if (uri.pathSegments[0] == 'habits' && action == 'edit') {
            final habit = settings.arguments as dynamic;
            return MaterialPageRoute(builder: (_) => EditHabitPage(habit: habit));
          }
        }

        return MaterialPageRoute(builder: (_) => const AuthPage());
      },
    );
  }
}
