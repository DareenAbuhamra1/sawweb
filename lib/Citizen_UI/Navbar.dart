import 'package:flutter/material.dart';
import 'package:sawweb/Citizen_UI/chat.dart';
import 'package:sawweb/Citizen_UI/homePage.dart';
import 'package:sawweb/Citizen_UI/notifications.dart';
import 'package:sawweb/Citizen_UI/track.dart';

class Navbar extends StatefulWidget {
  static final GlobalKey<_MyHomePageState> navbarKey = GlobalKey<_MyHomePageState>();

  Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Navbar> {
  int _currentIndex = 0;


  final List<Widget> _pages = [Homepage(), Track(), Notifications(), ChatbotScreen()];

  void navigateToTab(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

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
