import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'الإشعارات',
          style: TextStyle(
            color: Color.fromARGB(255, 10, 40, 95),
            fontSize: 20,
            fontFamily: 'AlexandriaArabic',
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            children: [
              _buildNotificationCard(
                context,
                title: 'إشعار بدء العمل على إصلاح "منهل مفتوح"',
                location: 'شارع الجامعة',
                source: 'أمانة عمان',
                date: '2025/5/5',
                color: Colors.amber,
                icon: Icons.sync,
              ),
              _buildNotificationCard(
                context,
                title: 'إشعار إصلاح "ماسورة ماء"',
                location: 'شارع إربد',
                source: 'وزارة المياه',
                date: '2025/5/5',
                color: Colors.green,
                icon: Icons.check_circle,
              ),
              _buildNotificationCard(
                context,
                title: 'إشعار تعذر إصلاح "إشارة معطلة"',
                location: 'شارع إربد',
                source: 'أمانة عمان',
                date: '2025/5/5',
                color: Colors.red,
                icon: Icons.cancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildNotificationCard(
  BuildContext context, {
  required String title,
  required String location,
  required String source,
  required String date,
  required Color color,
  required IconData icon,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الموقع: $location'),
            Row(children: [Icon(icon, color: color, size: 20)]),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('الجهة: $source'), Text('التاريخ: $date')],
        ),
      ],
    ),
  );
}
