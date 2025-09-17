import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MainNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        // Use pushNamedAndRemoveUntil instead of pushReplacementNamed for clean navigation
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
          default:
            route = '/dashboard';
        }
        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        onItemTapped(index);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF16C9E6),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Habits"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
      ],
    );
  }
}
