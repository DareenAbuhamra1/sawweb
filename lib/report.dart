import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Report extends StatefulWidget {
  final String categoryName;

  Report({required this.categoryName});

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<Report> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedIssue;

  Map<String, List<String>> issuesByCategory = {
    'طُرقات': ['حفر', 'ازدحام', 'إشارات مفقودة'],
    'الزراعة': ['نقص مياه', 'آفات', 'تلوث تربة'],
    'الشارع': ['إنارة ضعيفة', 'قمامة', 'أرصفة مكسورة'],
    'السياحة': ['افتقار لمرافق', 'عدم وجود لافتات', 'ازدحام'],
    'النظافة': ['تراكم القمامة', 'نقص حاويات', 'تلوث الهواء'],
    'كهرباء': ['تراكم القمامة', 'نقص حاويات', 'تلوث الهواء'],
  };

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categoryName;

    List<String>? relatedIssues = issuesByCategory[selectedCategory!];
    if (relatedIssues != null && relatedIssues.isNotEmpty) {
      selectedIssue = relatedIssues[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String>? relatedIssues = issuesByCategory[selectedCategory!] ?? [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 245),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: AppBar(
              leading: const BackButton(color: Color.fromARGB(255, 10, 40, 95)),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                'قدم اقتراحًا',
                style: TextStyle(
                  color: Color.fromARGB(255, 10, 40, 95),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'عنوان الاقتراح ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: titleController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color.fromARGB(153, 93, 97, 104)),
                  hintText: 'اكتب عنوان الاقتراح',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            //SizedBox(height: 16),
            // Text('تصنيف الاقتراح', style: TextStyle(fontWeight: FontWeight.bold ,color:Color.fromARGB(255, 10, 40, 95))),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items:
                      issuesByCategory.keys
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color.fromARGB(153, 93, 97, 104),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                      List<String>? issues = issuesByCategory[val!];
                      selectedIssue =
                          issues != null && issues.isNotEmpty
                              ? issues[0]
                              : null;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  isExpanded: true,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'المشاكل المرتبطة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  value: selectedIssue,
                  items:
                      relatedIssues
                          .map(
                            (issue) => DropdownMenuItem(
                              value: issue,
                              child: Text(
                                issue,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color.fromARGB(153, 93, 97, 104),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => selectedIssue = val),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  isExpanded: true,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'وصف الاقتراح',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      // رفع صورة
                    },
                    child: Container(
                      height: 126,
                      width: 109,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 40,
                              color: Color.fromARGB(255, 10, 40, 95),
                            ),
                            Text(
                              'ارفق أي صور',
                              style: TextStyle(
                                color: Color.fromARGB(153, 93, 97, 104),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'وصف الاقتراح بالتفصيل',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(153, 93, 97, 104),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text('إضافة مرفقات'),
              ),
            ),
            SizedBox(height: 16),
             Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(33.5138, 36.2765),
                  zoom: 14,
                ),
                onMapCreated: (controller) {},
              ),
            ),
          
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.location_on),
                label: Text('الموقع'),
              ),
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('اقترح'),
            ),
          ],
        ),
      ),
    );
  }
}
