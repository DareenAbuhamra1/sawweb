import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sawweb/Admin_UI/Homepage.dart';
import 'package:sawweb/Citizen_UI/Navbar.dart';
import 'package:sawweb/Employee_UI/complaints.dart';
import 'package:sawweb/Employee_UI/complaintsDetails.dart';
import 'package:sawweb/Employee_UI/homee.dart';
import 'package:sawweb/Employee_UI/profilee.dart';
import 'package:sawweb/Employee_UI/sugg.dart';
import 'package:sawweb/Employee_UI/suggeDetails.dart';
import 'package:sawweb/auth_wrapper.dart';
import 'package:sawweb/Citizen_UI/changePassword.dart';
import 'package:sawweb/Citizen_UI/chat.dart';
import 'package:sawweb/Citizen_UI/homePage.dart';
import 'package:sawweb/Citizen_UI/notifications.dart';
import 'package:sawweb/Citizen_UI/profile.dart';
import 'package:sawweb/Citizen_UI/signin.dart';
import 'package:sawweb/Citizen_UI/signup.dart';
import 'package:sawweb/Citizen_UI/track.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sawweb/Employee_UI/signine.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('ar', null);
  runApp(const MainApp());
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
        localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ar'), // Arabic (you use this!)
      ],
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'AlexandriaArabic',
        primarySwatch: customSwatch,
        useMaterial3: false,
      ),
      home: AuthWrapper(),
      routes: {
        'signin': (context) => Signin(),
        'signup': (context) => Signup(),
        'track': (context) => Track(),
        'home':(context) => Homepage(),
        'chat': (context)=> ChatbotScreen (),
        'notifications': (context) => Notifications(),
        'navBar':(context)=>Navbar(),
        'profile': (context) => Profile(),
        'changePassword': (context) => ChangePasswordScreen(),
        'signin_emp':(context) => Signine(),
        'home_emp' : (context) => HomeEmp(),
        'complaint_emp':(context) => ComplaintsPage(),
        'complaint_details' : (context) => Complaintsdetails(),
        'profile_emp' : (context) =>Profilee(),
        'sugg_emp' : (context) => Sugg(),
        'sugg_details': (context) => Suggestiondetails(),
        'homeAdmin':(context) => AdminHomeScreen(),
      },
    );
  }
}
