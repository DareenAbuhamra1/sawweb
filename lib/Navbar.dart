import 'package:flutter/material.dart';
import 'package:sawweb/chat.dart';
import 'package:sawweb/homePage.dart';
import 'package:sawweb/notifications.dart';
import 'package:sawweb/track.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Navbar> {
  int _currentIndex = 0;


  final List<Widget> _pages = [Homepage(), Track(), Notifications(), ChatbotScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromARGB(255, 10, 40, 95),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'تتبع',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'chatBot',
            ),
          ],
        ),
      ),
    );
  }
}
