import 'package:flutter/material.dart';
import 'package:sawweb/signup.dart';

class Signin extends StatelessWidget {
  const Signin({super.key});

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
                onPressed: () {
                  Navigator.of(context).pushNamed('track');
                },
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
                  child: TextButton(onPressed: (){},
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
            ],
          ),
        ),
      ),
    );
  }
}
