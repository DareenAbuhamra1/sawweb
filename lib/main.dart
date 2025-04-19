import 'package:flutter/material.dart';
import 'package:sawweb/signup.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
   final MaterialColor customSwatch = const MaterialColor(
  0xFF145C8C, // Lightened color (20, 60, 140)
  <int, Color>{
    50: Color.fromRGBO(20, 60, 140, 0.1),  // Very light
    100: Color.fromRGBO(20, 60, 140, 0.2),
    200: Color.fromRGBO(20, 60, 140, 0.3),
    300: Color.fromRGBO(20, 60, 140, 0.4),
    400: Color.fromRGBO(20, 60, 140, 0.5),
    500: Color.fromRGBO(20, 60, 140, 0.6),
    600: Color.fromRGBO(20, 60, 140, 0.7),
    700: Color.fromRGBO(20, 60, 140, 0.8),
    800: Color.fromRGBO(20, 60, 140, 0.9),
    900: Color.fromRGBO(20, 60, 140, 1.0), // Base color
  },
);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'AlexandriaArabic',primarySwatch: customSwatch,useMaterial3: false ),
      home: Signup(),
    );
    }
}
