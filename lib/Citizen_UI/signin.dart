import 'package:flutter/material.dart';
import 'package:sawweb/Citizen_UI/signup.dart';
import 'package:sawweb/Citizen_UI/Navbar.dart';
import 'package:sawweb/Citizen_UI/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final nationalIdController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nationalIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final nationalId = nationalIdController.text.trim();
    final password = passwordController.text.trim();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(nationalId)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لم يتم العثور على المستخدم')),
        );
        return;
      }

      final email = userDoc['email'];

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.of(context).pushReplacementNamed('navBar');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تسجيل الدخول: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Optional: Center vertically
              children: [
              Text(
                "Sawweb",
                style: TextStyle(
                  fontFamily: 'AlexandriaArabic',
                  fontSize: 30,
                  color: Color.fromARGB(255, 10, 40, 95),
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/sawweb.png',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 10),
              Text(
                "تسجيل الدخول",
                style: TextStyle(fontFamily: 'AlexandriaArabic', fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "فضلًا، أدخل رقمك الوطني لتسجيل الدخول",
                style: TextStyle(fontFamily: 'AlexandriaArabic', fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: nationalIdController,
                  decoration: InputDecoration(
                    labelText: 'الرقم الوطني',
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: 'AlexandriaArabic',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'الرقم السري',
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: 'AlexandriaArabic',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signIn,
                child: Text('دخول', style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),// Width: 200, Height: 50
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft ,
                  child: TextButton(onPressed: (){
                    Navigator.pushNamed(context, "changePassword");
                  },
                   child: Text('نسيت كلمة السر ؟',
                   style: TextStyle(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 98, 98, 98),
                    ),
                   
                   )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('مستخدم جديد ؟'),
                  TextButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Signup()));
                  }, 
                  child: Text('إنشاء حساب'),
                  )
                ],
              ),
              Divider(
                color: Colors.grey, // Line color
                thickness: 1, // Line thickness
                indent: 30, // Space before the line
                endIndent: 30, // Space after the line
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('هل انت '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'signin_emp');
                    },
                    child: Text('موظف؟'),
                  ),
                ],
              ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}
