import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Track extends StatefulWidget {
  Track({super.key});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {

  Future<List<Map<String, dynamic>>> fetchUserReports() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    if (usersSnapshot.docs.isEmpty) return [];

    final nationalId = usersSnapshot.docs.first.data()['national_id'];
    print('Using national ID: $nationalId');

    final snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('national_id', isEqualTo: nationalId)
        .get();

    final reports = snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;
      return data;
    }).toList().cast<Map<String, dynamic>>();
    print('Reports found for user: $reports');
    return reports;
  }
  @override
  Widget build(BuildContext context) {
    // Define the icon map for types
    Map<String, IconData> typeIcons = {
      'مياه': Icons.water,
      'كهرباء': Icons.power,
      'زراعة': FontAwesomeIcons.seedling,
      'طرقات': FontAwesomeIcons.road,
      'تلوث': Icons.delete,
      'أخرى': Icons.more_horiz,
    };
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
                    // Tab 1: قيد الاطلاع
                    _PendingReportsTab(fetchUserReports: fetchUserReports, typeIcons: typeIcons),
                    // Tab 2: قيد العمل
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchUserReports(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('لا يوجد بلاغات.'));
                        }
                        final complaints = snapshot.data!;
                        final filtered = complaints.where((c) => c['state'] == 'قيد العمل').toList();
                        if (filtered.isEmpty) {
                          return Center(child: Text('لا يوجد بلاغات قيد العمل'));
                        }
                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final complaint = filtered[i];
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
                                          typeIcons[complaint['type']] ?? Icons.report,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'مشاكل\n${complaint['type'] ?? ''}',
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${complaint['issue'] ?? ''}',
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("الوقت المتوقع:", style: TextStyle(color: Colors.white, fontSize: 12)),
                                                Text(
                                                  '${complaint['estimated_time'] ?? '3 أيام'}',
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Divider(color: Colors.white),
                                        SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('الموقع:', style: TextStyle(color: Colors.white)),
                                                  Text(
                                                    '${complaint['place_name'] ?? ''}',
                                                    style: TextStyle(color: Colors.white),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('تاريخ البلاغ:', style: TextStyle(color: Colors.white)),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    '${complaint['timestamp'] != null ? complaint['timestamp'].toDate().toString().split(' ')[0] : ''}',
                                                    style: TextStyle(color: Colors.white),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
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
                        );
                      },
                    ),
                    // Tab 3: تم اصلاحه
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchUserReports(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('لا يوجد بلاغات.'));
                        }
                        final complaints = snapshot.data!;
                        final filtered = complaints.where((c) => c['state'] == 'تم اصلاحه').toList();
                        if (filtered.isEmpty) {
                          return Center(child: Text('لا يوجد بلاغات.'));
                        }
                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final complaint = filtered[i];
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
                                          typeIcons[complaint['type']] ?? Icons.report,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'مشاكل\n${complaint['type'] ?? ''}',
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${complaint['issue'] ?? ''}',
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.check_circle, color: Colors.white),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Divider(color: Colors.white),
                                        SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('الموقع:', style: TextStyle(color: Colors.white)),
                                                  Text(
                                                    '${complaint['place_name'] ?? ''}',
                                                    style: TextStyle(color: Colors.white),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('تاريخ البلاغ:', style: TextStyle(color: Colors.white)),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    '${complaint['timestamp'] != null ? complaint['timestamp'].toDate().toString().split(' ')[0] : ''}',
                                                    style: TextStyle(color: Colors.white),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
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
                        );
                      },
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

  // Move _PendingReportsTab inside _TrackState so setState is accessible
  Widget _PendingReportsTab({
    required Future<List<Map<String, dynamic>>> Function() fetchUserReports,
    required Map<String, IconData> typeIcons,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchUserReports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('لا يوجد بلاغات.'));
            }
            final complaints = snapshot.data!;
            final filtered = complaints.where((c) => c['state'] == 'قيد الاطلاع').toList();
            if (filtered.isEmpty) {
              return Center(child: Text('لا يوجد بلاغات قيد الاطلاع.'));
            }
            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final complaint = filtered[i];
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
                              typeIcons[complaint['type']] ?? Icons.report,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'مشاكل\n${complaint['type'] ?? ''}',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${complaint['issue'] ?? ''}',
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.warning, color: Colors.redAccent),
                              ],
                            ),
                            SizedBox(height: 6),
                            Divider(color: Colors.white),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('الموقع:', style: TextStyle(color: Colors.white)),
                                      Text(
                                        '${complaint['place_name'] ?? ''}',
                                        style: TextStyle(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('تاريخ البلاغ:', style: TextStyle(color: Colors.white)),
                                      SizedBox(height: 6),
                                      Text(
                                        '${complaint['timestamp'] != null ? complaint['timestamp'].toDate().toString().split(' ')[0] : ''}',
                                        style: TextStyle(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Delete (cancel report) button aligned to left
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                icon: Icon(Icons.cancel, color: Colors.redAccent),
                                label: Text('الغاء البلاغ', style: TextStyle(color: Colors.redAccent)),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('تأكيد الإلغاء', textAlign: TextAlign.center),
                                        content: Text('هل أنت متأكد من رغبتك في إلغاء هذا البلاغ؟', textAlign: TextAlign.center),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text('لا'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
                                            child: Text('نعم'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmed == true) {
                                    final docId = complaint['docId'];
                                    await FirebaseFirestore.instance.collection('reports').doc(docId).delete();
                                    // ignore: use_build_context_synchronously
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }