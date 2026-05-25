import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_flow_habit/main.dart';

void main() {
  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title 'HabitFlow' is displayed on the SplashScreen
    expect(find.text('HabitFlow'), findsOneWidget);
    expect(find.text('Build Better Habits Daily'), findsOneWidget);

    // Pump the tester to allow the 3-second delayed timer in splash.dart to execute and complete
    await tester.pump(const Duration(seconds: 3));
  });
}
