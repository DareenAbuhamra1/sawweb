import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// الصفحة الثانية اللي رح تنقل لها مع تمرير التصنيف
import 'report.dart'; // غير المسار حسب مكان الملف عندك

class CategoriesGrid extends StatefulWidget {
  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('category').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'label': doc.id,
        'icon': data['icon'] ?? 'Icons.help_outline',
        'issues': data['المشاكل'] ?? [],
      };
    }).toList();
  }

  IconData resolveIcon(String iconString) {
  switch (iconString) {
    case 'Icons.water':
      return Icons.water;
    case 'Icons.power':
      return Icons.power;
    case 'Icons.security':
      return Icons.security;
    case 'Icons.landscape':
      return Icons.landscape;
    case 'Icons.delete':
      return Icons.delete;
    case 'Icons.more_horiz':
      return Icons.more_horiz;
    case 'FontAwesomeIcons.seedling':
      return FontAwesomeIcons.seedling;
    case 'FontAwesomeIcons.road':
      return FontAwesomeIcons.road;
    default:
      return Icons.help_outline;
  }
}

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('لا توجد تصنيفات'));
        }

        final categories = snapshot.data!;

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
                                    builder: (_) => Report(
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
                                      resolveIcon(categories[i]['icon']),
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
      },
    );
  }
}
