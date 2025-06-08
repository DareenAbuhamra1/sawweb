import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sawweb/Citizen_UI/SuggestionForm.dart';
import 'package:sawweb/Citizen_UI/catagory.dart';
import 'package:sawweb/Citizen_UI/profile.dart';
import 'package:sawweb/Citizen_UI/report.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc.data()?['first_name'] ?? "";
        });
      }
    }
  }

  get categories => null;
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
              "!مرحبًا ${username}",
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
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Profile()));
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment(1, -1),
              height: 250,
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
                      "!عينك على التغيير",
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
                      "بلّغ، واحنا معك نصوّب",
                      style: TextStyle(
                        color: Color.fromARGB(255, 32, 33, 35),
                        fontWeight: FontWeight.w100,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        showSearch(context: context, delegate: IssueSearchDelegate());
                      },
                      child: Container(
                        width: 370,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromARGB(55, 0, 0, 0),
                            width: 1.0,
                          ),
                        ),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  "إبحث على مشكلة معينة لتقديم شكوى",
                                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 10),
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
                    "فئات المشاكل",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 72, 69, 69),
                    ),
                  ),
                ],
              ),
            ),
            CategoriesGrid(),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
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
                    "قـــدم اقتراحًا",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 72, 69, 69),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Suggestionform()
                    ),
                  );
                },
                child: Container(
                  height: 105,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 73, 109, 145),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5, top: 15),
                            child: Text(
                              "!كن جزءًا من الحل",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 15),
                            child: Icon(
                              Icons.lightbulb_circle,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 13,
                          top: 7,
                          left: 20,
                        ),
                        child: Text(
                          "أرســل اقتراحـــاتك لتحسين منطقتك أو تطــــوير الخدمات المقدّمة لك ولغيرك من المواطنين",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ----------------- SEARCH DELEGATE -----------------

class IssueSearchDelegate extends SearchDelegate {
  List<Map<String, dynamic>>? _allIssues; // cached list
  Future<void> _fetchIssues() async {
    if (_allIssues != null) return;
    final snapshot = await FirebaseFirestore.instance.collection('category').get();
    List<Map<String, dynamic>> issues = [];
    for (var doc in snapshot.docs) {
      final categoryName = doc.id;
      final data = doc.data();
      if (data['المشاكل'] is List) {
        for (var issue in data['المشاكل']) {
          if (issue is Map<String, dynamic>) {
            issues.add({
              'category': categoryName,
              'issue': issue['المشكلة'] ?? '',
              'authority': issue['الجهة المسؤولة'] ?? '',
            });
          }
        }
      }
    }
    _allIssues = issues;
  }

  List<Map<String, dynamic>> _filterIssues(String query) {
    if (_allIssues == null) return [];
    final lower = query.toLowerCase();
    return _allIssues!.where((m) =>
      (m['issue']?.toString().toLowerCase().contains(lower) ?? false) ||
      (m['category']?.toString().toLowerCase().contains(lower) ?? false)
    ).toList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as user types
    return FutureBuilder(
      future: _fetchIssues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final matches = _filterIssues(query);
        if (matches.isEmpty) {
          return Center(child: Text('لا يوجد نتائج'));
        }
        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, i) {
            final matched = matches[i];
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: Text(matched['issue'] ?? ''),
                subtitle: Text(matched['category'] ?? ''),
                onTap: () {
                  close(context, null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Report(
                        categoryName: matched['category'],
                        initialIssue: matched['issue'],
                        initialAuthority: matched['authority'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show results after submitting
    return FutureBuilder(
      future: _fetchIssues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final matches = _filterIssues(query);
        if (matches.isEmpty) {
          return Center(child: Text('لا يوجد نتائج'));
        }
        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, i) {
            final matched = matches[i];
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: Text(matched['issue'] ?? ''),
                subtitle: Text(matched['category'] ?? ''),
                onTap: () {
                  close(context, null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Report(
                        categoryName: matched['category'],
                        initialIssue: matched['issue'],
                        initialAuthority: matched['authority'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
}