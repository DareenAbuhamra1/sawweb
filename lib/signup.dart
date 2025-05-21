import 'package:flutter/material.dart';
import 'package:sawweb/signin.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
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
                onPressed: () {},
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
    );
  }
}
