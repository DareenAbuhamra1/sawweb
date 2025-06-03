import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// الصفحة الثانية اللي رح تنقل لها مع تمرير التصنيف
import 'report.dart'; // غير المسار حسب مكان الملف عندك

class CategoriesGrid extends StatelessWidget {
  // بيانات التصنيفات (الايقونة + الاسم)
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.water, 'label': 'مياه'},
    {'icon': Icons.power, 'label': 'كهرباء'},
    {'icon': Icons.security, 'label': 'أمن'},
    {'icon': FontAwesomeIcons.seedling, 'label': 'زراعة'},
    {'icon': FontAwesomeIcons.road, 'label': 'طُرقات'},
    {'icon': Icons.landscape, 'label': 'سياحة'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int row = 0; row < 2; row++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = row * 3; i < row * 3 + 3; i++)
                    if (i < categories.length)
                      Padding( 
                        padding: EdgeInsets.only(
                          left: i % 3 == 0 ? 25 : 0,
                          right: 15,
                          top: row == 0 ? 25 : 0,
                          bottom: 15,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => Report(
                                      categoryName: categories[i]['label'],
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromARGB(55, 0, 0, 0),
                                width: 1.4,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  categories[i]['icon'],
                                  size: 40,
                                  color: Color.fromARGB(255, 10, 40, 95),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  categories[i]['label'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 10, 40, 95),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
