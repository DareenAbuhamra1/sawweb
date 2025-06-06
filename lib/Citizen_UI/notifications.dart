import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationItem {
  final String title;
  final String body;
  final String location;
  final String source;
  final String date;
  final Color color;
  final IconData icon;
  final bool read;

  NotificationItem({
    required this.title,
    required this.body,
    required this.location,
    required this.source,
    required this.date,
    required this.color,
    required this.icon,
    required this.read,
  });
}

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('الرجاء تسجيل الدخول لعرض الإشعارات'));
    }

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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: user.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('لا توجد إشعارات حالياً'));
              }
              final userDoc = snapshot.data!.docs.first;
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userDoc.id)
                    .collection('notificationList')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, notifSnapshot) {
                  if (notifSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!notifSnapshot.hasData || notifSnapshot.data!.docs.isEmpty) {
                    return Center(child: Text('لا توجد إشعارات حالياً'));
                  }

                  final notifications = notifSnapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return NotificationItem(
                      title: data['title'] ?? '',
                      body: data['body'] ?? '',
                      location: data['location'] ?? '',
                      source: data['source'] ?? '',
                      date: (data['timestamp'] as Timestamp?)?.toDate().toString().split(' ').first ?? '',
                      color: Color(int.tryParse(data['color']) ?? 0xFFFFC107),
                      icon: IconData(data['icon'] != null ? Icons.sync.codePoint : Icons.notifications.codePoint, fontFamily: 'MaterialIcons'),
                      read: data['read'] ?? false,
                    );
                  }).toList();

                  return ListView(
                    children: notifications.map((notif) => _buildNotificationCard(
                      context,
                      title: notif.title,
                      body: notif.body,
                      location: notif.location,
                      source: notif.source,
                      date: notif.date,
                      color: notif.color,
                      icon: notif.icon,
                      read: notif.read,
                    )).toList(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildNotificationCard(
  BuildContext context, {
  required String title,
  required String body,
  required String location,
  required String source,
  required String date,
  required Color color,
  required IconData icon,
  required bool read,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                softWrap: true,
                overflow: TextOverflow.visible,
                maxLines: 3,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          body,
          softWrap: true,
          overflow: TextOverflow.visible,
          maxLines: 3,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'الموقع: $location',
                softWrap: true,
                overflow: TextOverflow.visible,
                maxLines: null,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'الجهة: $source',
                softWrap: true,
                overflow: TextOverflow.visible,
                maxLines: null,
              ),
            ),
            SizedBox(width: 16),
            Text(
              'التاريخ: $date',
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: null,
            ),
          ],
        ),
      ],
    ),
  );
}
