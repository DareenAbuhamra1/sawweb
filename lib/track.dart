import 'dart:ffi';

import 'package:flutter/material.dart';

class Track extends StatelessWidget {
  Track({super.key});
  final List<Map<String, dynamic>> complaints = [
    {
      'title': 'انقطاع الكهرباء',
      'location': 'وسط البلد',
      'date': '2025-04-20',
      'icon': Icons.power,
      'type': 'كهرباء',
      'estimatedTime': '3 أيام',
      
    },
    {
      'title': 'تسرب مياه',
      'location': 'عبدون',
      'date': '2025-04-19',
      'icon': Icons.water,
      'type': 'مياه',
      'estimatedTime': '1 أيام',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'بلاغاتي',
              style: TextStyle(
                fontFamily: 'AlexandriaArabic',
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Color.fromARGB(255, 73, 109, 145),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor:Color.fromARGB(255, 10, 40, 95),
                  labelStyle: TextStyle(
                    fontFamily: 'AlexandriaArabic',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'AlexandriaArabic',
                    fontSize: 16,
                  ),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 4),
                  tabs: [
                    Tab(text: 'قيد الاطلاع'),
                    Tab(text: 'قيد العمل'),
                    Tab(text: 'تم اصلاحه'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Builder(
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListView.builder(
                              itemCount: complaints.length,
                              itemBuilder: (context, i) {
                                final complaint = complaints[i];
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 73, 109, 145),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Column(
                                          children: [
                                            Icon(
                                              complaint['icon'],
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'مشاكل\n${complaint['type']}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${complaint['title']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.warning,color: const Color.fromARGB(255, 245, 101, 101),)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Divider(
                                              color: Colors.white,
                                              thickness: 1,
                                            ),
                                            SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'الموقع:',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${complaint['location']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                          'تاريخ البلاغ:',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        SizedBox(height: 6,),
                                                        Text(
                                                          '${complaint['date']}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Builder(
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListView.builder(
                              itemCount: complaints.length,
                              itemBuilder: (context, i) {
                                final complaint = complaints[i];
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 73, 109, 145),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Column(
                                          children: [
                                            Icon(
                                              complaint['icon'],
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'مشاكل\n${complaint['type']}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${complaint['title']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("الوقت المتوقع:",style: TextStyle(color: Colors.white),),
                                                    Text('${complaint['estimatedTime']}',style: TextStyle(color: Colors.white),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Divider(color: Colors.white, thickness: 1),
                                            SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'الموقع:',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                    Text(
                                                      '${complaint['location']}',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'تاريخ البلاغ:',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                    SizedBox(height: 6),
                                                    Text(
                                                      '${complaint['date']}',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Builder(
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListView.builder(
                              itemCount: complaints.length,
                              itemBuilder: (context, i) {
                                final complaint = complaints[i];
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 73, 109, 145),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Column(
                                          children: [
                                            Icon(
                                              complaint['icon'],
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'مشاكل\n${complaint['type']}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${complaint['title']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    // You can customize the right-side content for "تم اصلاحه" if needed.
                                                    Icon(Icons.check_circle, color: Colors.white),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Divider(color: Colors.white, thickness: 1),
                                            SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'الموقع:',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                    Text(
                                                      '${complaint['location']}',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'تاريخ البلاغ:',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                    SizedBox(height: 6),
                                                    Text(
                                                      '${complaint['date']}',
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
