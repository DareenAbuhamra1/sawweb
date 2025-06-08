import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sawweb/Admin_UI/Homepage.dart';
import 'package:sawweb/Citizen_UI/Navbar.dart';
import 'package:sawweb/Citizen_UI/homePage.dart';
import 'package:sawweb/Citizen_UI/signin.dart';
import 'package:sawweb/Employee_UI/homee.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final uid = snapshot.data!.uid;
          print('User is signed in with UID: $uid');
          return FutureBuilder(
            future: _getUserRole(uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (roleSnapshot.hasData) {
                final role = roleSnapshot.data as String;
                print('User role determined: $role');
                if (role == 'admin') {
                  return AdminHomeScreen();
                } else if (role == 'employee') {
                  return HomeEmp();
                } else if (role == 'citizen') {
                  return Navbar();
                } else {
                  return const Signin();
                }
              } else {
                return const Signin();
              }
            },
          );
        } else {
          return const Signin();
        }
      },
    );
  }

  Future<String?> _getUserRole(String uid) async {
    print('Checking UID in admins...');
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(uid)
        .get();
    if (adminDoc.exists) {
      print('UID found in admins');
      return 'admin';
    }

    print('Checking UID in employees...');
    final empDoc = await FirebaseFirestore.instance
        .collection('employees')
        .doc(uid)
        .get();
    if (empDoc.exists) {
      print('UID found in employees');
      return 'employee';
    }

    print('Checking UID in users...');
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (userDoc.exists) {
      print('UID found in users');
      return 'citizen';
    }

    print('UID not found in any role collections');
    return null;
  }
}
