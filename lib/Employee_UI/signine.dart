import 'package:flutter/material.dart';

class Signine extends StatefulWidget {
  const Signine({super.key});

  @override
  State<Signine> createState() => _SignineState();
}

class _SignineState extends State<Signine> {
  final TextEditingController jobNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signIn() {
    Navigator.pushReplacementNamed(context, 'home_emp');
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
                "فضلًا، أدخل رقمك الوظيفي لتسجيل الدخول",
                style: TextStyle(fontFamily: 'AlexandriaArabic', fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: jobNumberController,
                  decoration: InputDecoration(
                    labelText: 'الرقم الوظيفي',
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
                      Navigator.pushReplacementNamed(context, 'signin');
                    },
                    child: Text('مواطن؟'),
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