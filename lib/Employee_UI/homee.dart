import 'package:flutter/material.dart';
import 'package:sawweb/Employee_UI/complaints.dart';


class HomeEmp extends StatelessWidget {
  const HomeEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "!مرحبًا دارين",
              style: TextStyle(
                color: Color.fromRGBO(96, 101, 113, 1),
                fontSize: 18,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
               Navigator.pushNamed(context, 'profile_emp');
              },
              icon: Icon(
                Icons.account_circle,
                color: Color.fromRGBO(96, 101, 113, 1),
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment(1, -1),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          111,
                          111,
                          111,
                        ).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 1), // x, y
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 20.0,
                          top: 30,
                          bottom: 10,
                        ),
                        child: Text(
                          "!كن جزءًا فاعِلًا",
                          style: TextStyle(
                            color: Color.fromARGB(255, 10, 40, 95),
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          "غيّر، وأحسن، وتقدم",
                          style: TextStyle(
                            color: Color.fromARGB(255, 32, 33, 35),
                            fontWeight: FontWeight.w100,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 1,
                        width: 270,
                        color: const Color.fromARGB(67, 72, 69, 69),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "مهام اليوم",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      children: [
                        _buildTaskTile("عرض الشكاوي", Icons.info_outline, () {
                          Navigator.pushNamed(context, 'complaint_emp');
                        }),
                        SizedBox(height: 10),
                        _buildTaskTile("عرض الاقتراحات", Icons.lightbulb_outline, () {
                          Navigator.pushNamed(context, 'sugg_emp');
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 1,
                        width: 278,
                        color: const Color.fromARGB(67, 72, 69, 69),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "إحصائيات",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            color: Color(0xFF496D8D),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'المهام المنتهية',
                            style: TextStyle(
                              color: Color(0xFF0A285F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'المهام الجديدة',
                            style: TextStyle(
                              color: Color(0xFF0A285F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade700),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFE8ECF4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF0A285F), size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A285F),
            ),
            textAlign: TextAlign.right,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}