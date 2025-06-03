import 'package:flutter/material.dart';
import 'package:sawweb/Navbar.dart';
import 'package:sawweb/chat.dart';
import 'package:sawweb/homePage.dart';
import 'package:sawweb/notifications.dart';
import 'package:sawweb/signin.dart';
import 'package:sawweb/signup.dart';
import 'package:sawweb/track.dart';


void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  final MaterialColor customSwatch = const MaterialColor(
    0xFF145C8C, 
    <int, Color>{
      50: Color.fromRGBO(20, 60, 140, 0.1), 
      100: Color.fromRGBO(20, 60, 140, 0.2),
      200: Color.fromRGBO(20, 60, 140, 0.3),
      300: Color.fromRGBO(20, 60, 140, 0.4),
      400: Color.fromRGBO(20, 60, 140, 0.5),
      500: Color.fromRGBO(20, 60, 140, 0.6),
      600: Color.fromRGBO(20, 60, 140, 0.7),
      700: Color.fromRGBO(20, 60, 140, 0.8),
      800: Color.fromRGBO(20, 60, 140, 0.9),
      900: Color.fromRGBO(20, 60, 140, 1.0), 
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'AlexandriaArabic',
        primarySwatch: customSwatch,
        useMaterial3: false,
      ),
      initialRoute: 'signin',
      routes: {
        'signin': (context) => Signin(),
        'signup': (context) => Signup(),
        'track': (context) => Track(),
        'home':(context) => Homepage(),
        'chat': (context)=> ChatBotPage(),
        'notifications': (context) => Notifications(),
        'navBar':(context)=>Navbar(),
      },
    );
  }
}