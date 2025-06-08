import 'package:flutter/material.dart';
import 'package:sawweb/Citizen_UI/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final nationalIdController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

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
                style: TextStyle(fontFamily: 'AlexandriaArabic', fontSize: 30),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "حساب جديد",
                style: TextStyle(fontFamily: 'AlexandriaArabic', fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "فضلًا، أدخل رقمك الوطني لإنشاء حساب",
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
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الالكتروني',
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
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
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
                onPressed: () async {
                  final nationalId = nationalIdController.text.trim();
                  final email = emailController.text.trim();
                  final phone = phoneController.text.trim();
                  final password = passwordController.text.trim();

                  if (nationalId.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
                    );
                    return;
                  }

                  final citizenDoc = await FirebaseFirestore.instance
                      .collection('citizens')
                      .doc(nationalId)
                      .get();

                  if (!citizenDoc.exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('الرقم الوطني غير موجود في قاعدة بيانات المواطنين')),
                    );
                    return;
                  }

                  final existingUser = await FirebaseFirestore.instance
                      .collection('users')
                      .where('national_id', isEqualTo: nationalId)
                      .get();

                  if (existingUser.docs.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم إنشاء حساب مسبقًا لهذا الرقم الوطني')),
                    );
                    return;
                  }

                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(email: email, password: password);

                    final uid = userCredential.user!.uid;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .set({
                      'uid': uid,
                      'national_id': nationalId,
                      'first_name': citizenDoc['first_name'],
                      'second_name': citizenDoc['second_name'],
                      'middle_name': citizenDoc['middle_name'],
                      'last_name': citizenDoc['last_name'],
                      'email': email,
                      'phone_number': phone,
                    });

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Signin()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل في إنشاء الحساب: $e'),backgroundColor: Colors.red,),
                    );
                  }
                },
                child: Text('تسجيل', style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // Width: 200, Height: 50
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('لديك حساب ؟'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => Signin()));
                    },
                    child: Text('تسجيل الدخول'),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey, // Line color
                thickness: 1, // Line thickness
                indent: 30, // Space before the line
                endIndent: 30, // Space after the line
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'بالنقر على تسجيل، أنت توافق على ',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'AlexandriaArabic',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to Terms of Service
                    },
                    child: Text(
                      'الشروط والأحكام',
                      style: TextStyle(
                        color: Color.fromARGB(255, 20, 60, 140),
                        fontSize: 12,
                        fontFamily: 'AlexandriaArabic',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' و ',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'AlexandriaArabic',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to Privacy Policy
                    },
                    child: Text(
                      'سياسة الخصوصية',
                      style: TextStyle(
                        color: Color.fromARGB(255, 20, 60, 140),
                        fontSize: 12,
                        fontFamily: 'AlexandriaArabic',
                      ),
                    ),
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
