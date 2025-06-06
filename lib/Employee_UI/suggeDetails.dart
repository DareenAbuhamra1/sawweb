import 'package:flutter/material.dart';

class Suggestiondetails extends StatelessWidget {
  const Suggestiondetails({super.key});

  @override
  Widget build(BuildContext context) {
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
              automaticallyImplyLeading: false, // لمنع الزر التلقائي
              backgroundColor: Colors.white,
              elevation: 0,
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "الشكاوي",
                      style: TextStyle(
                        color: Color.fromARGB(255, 10, 40, 95),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 10, 40, 95)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات الاقتراح',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF0A285F),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const Divider(height: 24),
                    const Text(
                      'الاقتراح: حفرة كبيرة بشارع المدينة',
                      textDirection: TextDirection.rtl,
                    ),
                    const Text(
                      'نوع الاقتراح: طرقات وبينة تحتية',
                      textDirection: TextDirection.rtl,
                    ),
                    const Text(
                      'تاريخ التقديم: 10 / 6 / 2024',
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'وصف الاقتراح',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0A285F),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Text(
                       'اقترح توسيع المصف في البلد، بسبب تكدس السيارات، وارفقت صورة توضح الاقتراح',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'صورة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A285F),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ملفات مرفقة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A285F),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'soc1.pdf',
                      style: TextStyle(color: Color(0xFF0A285F)),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'توجيهات المسؤول:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0A285F),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 100,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ملفات مرفقة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A285F),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'soc1.pdf',
                      style: TextStyle(color: Color(0xFF0A285F)),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF496D8D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'رابط الموقع',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ملاحظات',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF0A285F),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 280,
                        height: 120,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: TextField(
                          maxLines: 4,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: 'اكتب ملاحظاتك',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 120,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'إرفاق أي صور',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'PNG, JPG, MP4',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle, color: Color(0xFF0A285F)),
                          SizedBox(width: 8),
                          Text(
                            'إضافة مرفقات',
                            style: TextStyle(
                              color: Color(0xFF0A285F),
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0A285F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'تمت',
                        style: TextStyle(fontSize: 18),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}