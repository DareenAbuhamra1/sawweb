import 'dart:io'; // لاستخدام File مع image_picker

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// قد تحتاجين لإضافة حزمة intl لتهيئة التاريخ بشكل أفضل، أو استخدام format بسيط.
// import 'package:intl/intl.dart'; // مثال: لاستخدام DateFormat

class Report extends StatefulWidget {
  final String categoryName; // الفئة الأولية التي يتم تمريرها للنموذج

  Report({required this.categoryName});

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<Report> {
  // تتبع المشاكل لكل فئة
  Map<String, List<String>> issuesByCategory = {};
  TextEditingController titleController =
      TextEditingController(); // لعنولن الشكوى
  TextEditingController descriptionController = TextEditingController();
  TextEditingController responsibleAuthorityController =
      TextEditingController(); // خانة نصية إذا كانت "أخرى"

  String? selectedCategory; // الفئة المختارة من القائمة الأولى
  String? selectedIssue; // المشكلة المحددة من القائمة الثانية

  String? detectedAuthority; // الجهة المسؤولة المكتشفة تلقائياً

  Future<List<String>> fetchIssuesForCategory(String category) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('category')
              .doc(category)
              .get();
      if (!doc.exists) return [];

      final data = doc.data()!;
      if (data.containsKey('المشاكل')) {
        return List<String>.from(
          data['المشاكل'].map((e) => e['المشكلة'].toString()),
        );
      }
      return [];
    } catch (e) {
      print("Error fetching issues: $e");
      return [];
    }
  }

  // لم يعد هناك حاجة للقائمة المنسدلة للجهات أو متغيراتها

  DateTime? _problemDate; // تاريخ المشكلة المختار

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  List<PlatformFile>? _attachments;

  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  // --- دالة التقاط صورة ---
  Future<void> _attachImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إرفاق الصورة: ${pickedFile.name}')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('لم يتم اختيار صورة.')));
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصورة: $e')));
      }
    }
  }

  // --- دالة التقاط مرفقات ---
  Future<void> _pickAttachments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        setState(() {
          _attachments = result.files;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إضافة ${_attachments!.length} مرفقات بنجاح!'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('لم يتم اختيار أي مرفقات.')));
        }
      }
    } catch (e) {
      print('Error picking files: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء اختيار المرفقات: $e')),
        );
      }
    }
  }

  // --- دالة اختيار تاريخ المشكلة ---
  Future<void> _selectProblemDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _problemDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5), // قبل 5 سنوات كحد أقصى
      lastDate: DateTime.now(), // لا يمكن أن يكون التاريخ في المستقبل
      locale: Locale('ar'), // لتعريب واجهة اختيار التاريخ
    );
    if (picked != null && picked != _problemDate) {
      setState(() {
        _problemDate = picked;
      });
    }
  }

  // قائمة الجهات المسؤولة المقترحة
  List<String> predefinedAuthorities = [
    'أمانة عمان الكبرى',
    'وزارة الأشغال العامة والإسكان',
    'شركة الكهرباء الوطنية',
    'شركة مياهنا',
    'وزارة السياحة والآثار',
    'مديرية الأمن العام',
    'أخرى (يرجى التحديد)'
  ];
  String? selectedAuthority; // الجهة المسؤولة المختارة
  bool _showOtherAuthorityField = false;

  DateTime? _problemDate; // تاريخ المشكلة المختار

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  List<PlatformFile>? _attachments;

  // --- دالة التقاط صورة ---
  Future<void> _attachImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إرفاق الصورة: ${pickedFile.name}')),
          );
        }
      } else {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لم يتم اختيار صورة.')));
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصورة: $e')));
      }
    }
  }

  // --- دالة التقاط مرفقات ---
  Future<void> _pickAttachments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        setState(() {
          _attachments = result.files;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إضافة ${_attachments!.length} مرفقات بنجاح!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لم يتم اختيار أي مرفقات.')));
        }
      }
    } catch (e) {
      print('Error picking files: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء اختيار المرفقات: $e')),
        );
      }
    }
  }

  // --- دالة اختيار تاريخ المشكلة ---
  Future<void> _selectProblemDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _problemDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5), // قبل 5 سنوات كحد أقصى
      lastDate: DateTime.now(), // لا يمكن أن يكون التاريخ في المستقبل
      locale: Locale('ar'), // لتعريب واجهة اختيار التاريخ
    );
    if (picked != null && picked != _problemDate) {
      setState(() {
        _problemDate = picked;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    // تعيين الفئة الأولية للمشكلة بناءً على ما تم تمريره للويدجت
    if (issuesByCategory.containsKey(widget.categoryName)) {
      selectedCategory = widget.categoryName;
    } else if (issuesByCategory.isNotEmpty) {
      selectedCategory = issuesByCategory.keys.first; // اختيار أول فئة كافتراضي إذا لم يتم تمرير فئة صالحة
    }

    if (selectedCategory != null) {
      fetchIssuesForCategory(selectedCategory!).then((fetchedIssues) {
        issuesByCategory[selectedCategory!] = fetchedIssues;
        selectedIssue = fetchedIssues.isNotEmpty ? fetchedIssues[0] : null;
        if (selectedIssue != null) {
          fetchResponsibleAuthority(selectedCategory!, selectedIssue!);
        }
        setState(() {});
      });
    }
  }

  // --- إيجاد الجهة المسؤولة بناءً على الفئة والمشكلة ---
  Future<void> fetchResponsibleAuthority(String category, String issue) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('category')
            .doc(category)
            .get();
    if (!doc.exists) return;

    final data = doc.data()!;
    if (data.containsKey('المشاكل')) {
      final List<dynamic> list = data['المشاكل'];
      for (final item in list) {
        if (item['المشكلة'] == issue) {
          setState(() {
            detectedAuthority = item['الجهة المسؤولة'];
          });
          return;
        }
      }
    }

    setState(() {
      detectedAuthority = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // قائمة المشاكل المرتبطة بالفئة المختارة حالياً
    List<String> relatedIssues =
        (selectedCategory != null &&
                issuesByCategory.containsKey(selectedCategory))
            ? issuesByCategory[selectedCategory!]!
            : [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 245),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: AppBar(
              leading: BackButton(
                color: Color.fromARGB(255, 10, 40, 95),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                "قدم شكوى",
                textAlign: TextAlign.right,
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
            // --- حقل عنوان الشكوى ---
            Text(
              'عنوان الشكوى',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: TextField(
                controller: titleController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color.fromARGB(153, 93, 97, 104)),
                  hintText: 'اكتب عنواناً موجزاً للشكوى',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // --- القائمة المنسدلة الأولى: فئة المشكلة ---
            Text(
              'فئة المشكلة الرئيسية',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: Text(
                    'اختر فئة المشكلة',
                    style: TextStyle(color: Color.fromARGB(153, 93, 97, 104)),
                  ),
                  items:
                      issuesByCategory.keys.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              category,
                              style: TextStyle(
                                color: Color.fromARGB(255, 10, 40, 95),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedCategory = val;
                      });
                      fetchIssuesForCategory(val).then((fetchedIssues) {
                        setState(() {
                          issuesByCategory[val] = fetchedIssues;
                          selectedIssue =
                              fetchedIssues.isNotEmpty
                                  ? fetchedIssues[0]
                                  : null;
                        });
                        if (selectedIssue != null) {
                          fetchResponsibleAuthority(val, selectedIssue!);
                        }
                      });
                    }
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 10, 40, 95),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            // --- القائمة المنسدلة الثانية: نوع المشكلة المحدد ---
            Text(
              'نوع المشكلة المحدد',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  value: selectedIssue,
                  hint: Text(
                    'اختر المشكلة المحددة',
                    style: TextStyle(color: Color.fromARGB(153, 93, 97, 104)),
                  ),
                  items:
                      relatedIssues.map((String issue) {
                        return DropdownMenuItem<String>(
                          value: issue,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              issue,
                              style: TextStyle(
                                color: Color.fromARGB(255, 10, 40, 95),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedIssue = val;
                    });
                    if (val != null && selectedCategory != null) {
                      fetchResponsibleAuthority(selectedCategory!, val);
                    }
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                  isExpanded: true,
                  disabledHint:
                      relatedIssues.isEmpty
                          ? Text(
                            'لا توجد مشاكل محددة لهذه الفئة',
                            style: TextStyle(color: Colors.grey),
                          )
                          : null,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 10, 40, 95),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // --- حقل الجهة المسؤولة (قراءة فقط) ---
            Text(
              'الجهة المسؤولة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                detectedAuthority ?? '—',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 10, 40, 95),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 16),

            // --- حقل تاريخ المشكلة ---
            Text(
              'تاريخ المشكلة (تقريبي)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
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
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ), // لضبط الارتفاع
                  alignment: Alignment.centerRight,
                ),
                onPressed: () => _selectProblemDate(context),
                child: Text(
                  _problemDate == null
                      ? 'اختر تاريخ المشكلة'
                      // : 'التاريخ المحدد: ${DateFormat('EEEE, d MMMM yyyy', 'ar').format(_problemDate!)}', // يتطلب intl
                      : 'التاريخ المحدد: ${_problemDate!.year}/${_problemDate!.month}/${_problemDate!.day}',
                  style: TextStyle(
                    color:
                        _problemDate == null
                            ? Color.fromARGB(153, 93, 97, 104)
                            : Color.fromARGB(255, 10, 40, 95),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // --- وصف المشكلة و إرفاق صورة ---
            Text(
              'وصف المشكلة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  value: selectedAuthority,
                  hint: Text('اختر الجهة المسؤولة', style: TextStyle(color: Color.fromARGB(153, 93, 97, 104))),
                  items: predefinedAuthorities.map((String authority) {
                    return DropdownMenuItem<String>(
                      value: authority,
                      child: Align(alignment: Alignment.centerRight, child: Text(authority, style: TextStyle(color: Color.fromARGB(255, 10, 40, 95)))),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedAuthority = val;
                      _showOtherAuthorityField = (val == 'أخرى (يرجى التحديد)');
                    });
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 10, 40, 95)),
                ),
              ),
            ),
            if (_showOtherAuthorityField) ...[
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
                ),
                child: TextField(
                  controller: responsibleAuthorityController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color.fromARGB(153, 93, 97, 104)),
                    hintText: 'يرجى تحديد اسم الجهة المسؤولة الأخرى',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
            SizedBox(height: 16),

            // --- حقل تاريخ المشكلة ---
            Text(
              'تاريخ المشكلة (تقريبي)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 10, 40, 95)),
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14), // لضبط الارتفاع
                  alignment: Alignment.centerRight,
                ),
                onPressed: () => _selectProblemDate(context),
                child: Text(
                  _problemDate == null
                      ? 'اختر تاريخ المشكلة'
                      // : 'التاريخ المحدد: ${DateFormat('EEEE, d MMMM yyyy', 'ar').format(_problemDate!)}', // يتطلب intl
                      : 'التاريخ المحدد: ${_problemDate!.year}/${_problemDate!.month}/${_problemDate!.day}',
                  style: TextStyle(
                    color: _problemDate == null ? Color.fromARGB(153, 93, 97, 104) : Color.fromARGB(255, 10, 40, 95),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // --- وصف المشكلة و إرفاق صورة ---
            Text(
              'وصف المشكلة',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 10, 40, 95)),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: _attachImage, // استدعاء دالة التقاط الصورة
                    child: Container(
                      height: 126,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
                        color: Colors.white,
                      ),
                      child:
                          _selectedImage == null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 40,
                                      color: Color.fromARGB(255, 10, 40, 95),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'إرفاق صورة',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromARGB(153, 93, 97, 104),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 126,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'يرجى وصف المشكلة بالتفصيل هنا...',
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

            // --- عرض المرفقات المختارة ---
            if (_attachments != null && _attachments!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'المرفقات (${_attachments!.length}):',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 10, 40, 95),
                  ),
                ),
              ),
            if (_attachments != null && _attachments!.isNotEmpty)
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments!.length,
                  itemBuilder: (context, index) {
                    final file = _attachments![index];
                    return Container(
                      width: 100,
                      margin: EdgeInsets.only(
                        left: 8.0,
                      ), // changed to left for RTL
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: 24,
                            color: Color.fromARGB(255, 10, 40, 95),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Text(
                              file.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (_attachments != null && _attachments!.isNotEmpty)
              SizedBox(height: 16),

            // --- زر إضافة مرفقات أخرى ---
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                    255,
                    10,
                    40,
                    95,
                  ).withOpacity(0.1),
                  foregroundColor: Color.fromARGB(255, 10, 40, 95),
                  elevation: 0,
                  side: BorderSide(color: Color.fromARGB(255, 10, 40, 95)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _pickAttachments, // استدعاء دالة التقاط المرفقات
                icon: Icon(Icons.add_link_outlined),
                label: Text('إضافة مرفقات أخرى (pdf, doc, ..)'),
              ),
            ),
            SizedBox(height: 16),

            // --- تحديد الموقع (الخريطة) ---
            Text(
              'تحديد موقع المشكلة (اختياري)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(31.963158, 35.930359), // Default location (Amman)
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: MarkerId("selected-location"),
                            position: _selectedLocation!,
                          )
                        }
                      : {},
                  onTap: (position) {
                    setState(() {
                      _selectedLocation = position;
                    });
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () async {
                  Location location = Location();
                  bool serviceEnabled = await location.serviceEnabled();
                  if (!serviceEnabled) {
                    serviceEnabled = await location.requestService();
                    if (!serviceEnabled) return;
                  }

                  PermissionStatus permissionGranted = await location.hasPermission();
                  if (permissionGranted == PermissionStatus.denied) {
                    permissionGranted = await location.requestPermission();
                    if (permissionGranted != PermissionStatus.granted) return;
                  }

                  final locData = await location.getLocation();
                  if (locData.latitude != null && locData.longitude != null) {
                    final newPosition = LatLng(locData.latitude!, locData.longitude!);
                    setState(() {
                      _selectedLocation = newPosition;
                    });
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(newPosition),
                    );
                  }
                },
                icon: Icon(
                  Icons.my_location,
                  color: Color.fromARGB(255, 10, 40, 95),
                ),
                label: Text(
                  'تحديد الموقع الحالي',
                  style: TextStyle(color: Color.fromARGB(255, 10, 40, 95)),
                ),
              ),
            ),
            SizedBox(height: 24),

            // --- زر إرسال الشكوى ---
            ElevatedButton(
              onPressed: () {
                //  منطق تجميع البيانات وإرسالها (إلى Firebase مثلاً)
                print('عنوان الشكوى: ${titleController.text}');
                print('فئة المشكلة: $selectedCategory');
                print('المشكلة المحددة: $selectedIssue');
                print('الجهة المسؤولة: ${detectedAuthority ?? "—"}');
                print('تاريخ المشكلة: ${_problemDate?.toIso8601String()}');
                print('وصف المشكلة: ${descriptionController.text}');
                print('الصورة المرفقة: ${_selectedImage?.path}');
                _attachments?.forEach(
                  (file) => print('مرفق آخر: ${file.name}'),
                );
                // print('الموقع: ...'); //  اطبع بيانات الموقع إذا تم تحديدها
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('سيتم هنا إرسال الشكوى.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 10, 40, 95),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
              ),
              child: Text(
                'إرسال الشكوى',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}