import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuggestionForm extends StatefulWidget {
  const SuggestionForm({super.key});

  @override
  _SuggestionFormState createState() => _SuggestionFormState();
}

class _SuggestionFormState extends State<SuggestionForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedIssue;

  // خريطة تصنيف المشاكل المرتبطة بكل خانة
  Map<String, List<String>> issuesByCategory = {
     'طُرقات': ['حفر', 'ازدحام', 'إشارات مفقودة'],
    'الزراعة': ['نقص مياه', 'آفات', 'تلوث تربة'],
    'الشارع': ['إنارة ضعيفة', 'قمامة', 'أرصفة مكسورة'],
    'السياحة': ['افتقار لمرافق', 'عدم وجود لافتات', 'ازدحام'],
    'النظافة': ['تراكم القمامة', 'نقص حاويات', 'تلوث الهواء'],
    'كهرباء': ['تراكم القمامة', 'نقص حاويات', 'تلوث الهواء'],
  };

  @override
  Widget build(BuildContext context) {
    List<String>? relatedIssues = selectedCategory != null
        ? issuesByCategory[selectedCategory!]
        : [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                'قدم اقتراحًا',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('عنوان الاقتراح'),
            Container(
               decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(55, 0, 0, 0),
                          width: 1.0,
                        ),
                      ),
                   child:   TextField(
              
              controller: titleController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'اكتب عنوان الاقتراح',
              ),
            ),
            ),
            const SizedBox(height: 16),
            const Text('تصنيف الاقتراح'),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: issuesByCategory.keys
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c, textAlign: TextAlign.right),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategory = val;
                  List<String>? issues = issuesByCategory[val!];
                  selectedIssue = (issues != null && issues.isNotEmpty)
                      ? issues[0]
                      : null;
                });
              },
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 16),
            const Text('وصف الاقتراح'),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      // رفع صورة
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40),
                            Text('ارفق أي صور'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'وصف الاقتراح بالتفصيل',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // رفع مرفقات
              },
              icon: const Icon(Icons.add),
              label: const Text('إضافة مرفقات'),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // تحديد الموقع
                },
                icon: const Icon(Icons.location_on),
                label: const Text('الموقع'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // إرسال الاقتراح
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('اقترح'),
            ),
          ],
        ),
      ),
    );
  }
}
