import 'dart:io'; // لاستخدام File مع image_picker
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

// نموذج بيانات الشكوى
class ReportModel {
  final String title;
  final Timestamp timeStamp;
  final int? rate;
  final String description;
  final String? type;
  final String? state;
  final String? authority;
  final String? photoPath;
  final List<String>? attachments;
  final String nationalId;
  final LatLng? location;
  final String? issue;
  final String? placeName;
  final DateTime? issueTime;

  ReportModel({
    required this.title,
    required this.timeStamp,
    this.rate,
    required this.description,
    this.type,
    this.issue,
    this.state,
    this.authority,
    this.photoPath,
    this.attachments,
    required this.nationalId,
    this.location,
    this.placeName,
    this.issueTime, // add this line
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'timestamp': timeStamp,
      'rate': rate,
      'description': description,
      'type': type,
      'issue': issue,
      'state': state,
      'authority': authority,
      'photo_path': photoPath,
      'attachments': attachments,
      'national_id': nationalId,
      'location':
          location != null
              ? {'lat': location!.latitude, 'lng': location!.longitude}
              : null,
      'place_name': placeName,
      'issue_time': issueTime?.toIso8601String(),
    };
  }
}

class Report extends StatefulWidget {
  final String categoryName; // الفئة الأولية التي يتم تمريرها للنموذج
  final String? initialIssue;
  final String? initialAuthority;

  Report({
    required this.categoryName,
    this.initialIssue,
    this.initialAuthority,
    Key? key,
  }) : super(key: key);

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<Report> {
  TextEditingController titleController =
      TextEditingController(); // لعنولن الشكوى
  TextEditingController descriptionController = TextEditingController();
  TextEditingController responsibleAuthorityController =
      TextEditingController(); // خانة نصية إذا كانت "أخرى"

  LatLng? _selectedLocation;

  String? selectedCategory; // الفئة المختارة من القائمة الأولى
  String? selectedIssue; // المشكلة المحددة من القائمة الثانية
  String? selectedAuthority; // الجهة المسؤولة المختارة
  bool _showOtherAuthorityField = false;

  // متغير للاحتفاظ بالبيانات المجلوبة من Firebase
  Map<String, List<Map<String, String>>> firebaseIssues = {};

  DateTime? _problemDate; // تاريخ المشكلة المختار

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  List<PlatformFile>? _attachments;

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

  @override
  void initState() {
    super.initState();
    fetchIssuesFromFirebase().then((_) {
      if (widget.initialIssue != null) {
        setState(() {
          selectedIssue = widget.initialIssue;
          selectedAuthority = widget.initialAuthority;
        });
      }
    });
  }

  Future<void> fetchIssuesFromFirebase() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('category').get();
    Map<String, List<Map<String, String>>> temp = {};

    for (var doc in snapshot.docs) {
      List<dynamic> issues = doc['المشاكل'];
      temp[doc.id] = issues.map((e) => Map<String, String>.from(e)).toList();
    }

    setState(() {
      firebaseIssues = temp;

      // Set selected category
      if (firebaseIssues.containsKey(widget.categoryName)) {
        selectedCategory = widget.categoryName;
      } else if (firebaseIssues.isNotEmpty) {
        selectedCategory = firebaseIssues.keys.first;
      }

      // Set default issue
      if (selectedCategory != null) {
        var related = firebaseIssues[selectedCategory!];
        if (related != null && related.isNotEmpty) {
          selectedIssue = related[0]['المشكلة'];
          selectedAuthority = related[0]['الجهة المسؤولة'];
        }
      }
    });
  }

  Future<(ReportModel?, String?)> _gatherReportData() async {
    String? placeName;
    if (_selectedLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _selectedLocation!.latitude,
          _selectedLocation!.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          placeName = '${place.street}, ${place.locality}, ${place.country}';
        }
      } catch (e) {
        print('فشل تحويل الإحداثيات إلى عنوان: $e');
      }
    }

    final nationalId = await _getCurrentUserNationalId();
    final fullName = await _getFullName();
    if (nationalId == null || fullName == null) {
      return (null, null);
    }

    final report = ReportModel(
      title: titleController.text,
      timeStamp: Timestamp.now(),
      description: descriptionController.text,
      type: selectedCategory,
      issue: selectedIssue,
      state: 'قيد الاطلاع',
      authority: selectedAuthority,
      photoPath: _selectedImage?.path,
      attachments: _attachments?.map((e) => e.path!).toList(),
      nationalId: nationalId,
      location: _selectedLocation,
      placeName: placeName,
      issueTime: _problemDate,
    );

    return (report, fullName);
  }

  @override
  Widget build(BuildContext context) {
    // استخراج قائمة المشاكل المرتبطة بالفئة المختارة حالياً من firebaseIssues
    Map<String, List<String>> issuesByCategory = firebaseIssues.map(
      (key, value) => MapEntry(key, value.map((e) => e['المشكلة']!).toList()),
    );
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
                      "قدم شكوى",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // --- Category & Date Row ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                            hint: Text(
                              'اختر فئة المشكلة',
                              style: TextStyle(
                                color: Color.fromARGB(153, 93, 97, 104),
                              ),
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
                                          color: Color.fromARGB(
                                            255,
                                            10,
                                            40,
                                            95,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  selectedCategory = val;
                                  List<Map<String, String>>? issues =
                                      firebaseIssues[val];
                                  if (issues != null && issues.isNotEmpty) {
                                    selectedIssue = issues[0]['المشكلة'];
                                    selectedAuthority =
                                        issues[0]['الجهة المسؤولة'];
                                  } else {
                                    selectedIssue = null;
                                    selectedAuthority = null;
                                  }
                                });
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromARGB(255, 10, 40, 95),
                            ),
                          ),
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
                      Text(
                        'تاريخ المشكلة',
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
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          onPressed: () => _selectProblemDate(context),
                          child: Text(
                            _problemDate == null
                                ? 'اختر تاريخ المشكلة'
                                : '${_problemDate!.year}/${_problemDate!.month}/${_problemDate!.day}',
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // --- القائمة المنسدلة الثانية: نوع المشكلة المحدد ---
            Text(
              'نوع المشكلة',
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
                  hint: Text(
                    'اختر المشكلة',
                    style: TextStyle(color: Color.fromARGB(153, 93, 97, 104)),
                  ),
                  items:
                      (selectedCategory != null &&
                              firebaseIssues[selectedCategory!] != null)
                          ? firebaseIssues[selectedCategory!]!
                              .map((e) => e['المشكلة']!)
                              .map(
                                (issue) => DropdownMenuItem<String>(
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
                                ),
                              )
                              .toList()
                          : [],
                  onChanged: (val) {
                    setState(() {
                      selectedIssue = val;
                      final issueData = firebaseIssues[selectedCategory!]
                          ?.firstWhere(
                            (e) => e['المشكلة'] == val,
                            orElse: () => {},
                          );
                      selectedAuthority = issueData?['الجهة المسؤولة'];
                    });
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
            SizedBox(height: 16),
            // --- الجهة المسؤولة ---
            Text(
              'الجهة المسؤولة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 40, 95),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
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
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  selectedAuthority ?? 'لم يتم تحديد جهة مسؤولة',
                  style: TextStyle(color: Color.fromARGB(255, 10, 40, 95)),
                ),
              ),
            ),
            SizedBox(height: 16),
            // --- حقل عنوان الشكوى (منقول هنا مباشرة قبل وصف المشكلة) ---
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
                  hintText: 'اكتب عنواناً موجزاً للشكوى',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
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
              'تحديد موقع المشكلة',
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
                    target: LatLng(31.963158, 35.930359), // عمان كموقع افتراضي
                    zoom: 12,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers:
                      _selectedLocation != null
                          ? {
                            Marker(
                              markerId: MarkerId('selected'),
                              position: _selectedLocation!,
                            ),
                          }
                          : {},
                  onTap: (LatLng pos) {
                    setState(() {
                      _selectedLocation = pos;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  //  منطق الحصول على الموقع الحالي للمستخدم وتحديث الخريطة
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'سيتم هنا تفعيل خاصية تحديد الموقع الحالي.',
                      ),
                    ),
                  );
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
              onPressed: () async {
                final (report, fullName) = await _gatherReportData();
                if (report == null || fullName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تعذر جلب بيانات المستخدم.')),
                  );
                  return;
                }
                try {
                  final docRef = await FirebaseFirestore.instance
                      .collection('reports')
                      .add({...report.toJson(), 'full_name': fullName});



                  if (mounted) {
                    int selectedRating = 0;
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder:
                              (context, setState) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    'تم الاستلام',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 10, 40, 95),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(8),
                                content: SizedBox(
                                  width: 280,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'لقد تم استلام الشكوى بنجاح وهي قيد الاطلاع',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'قيّم عملية الشكوى لتحسين خدمات الحكومة',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          return IconButton(
                                            iconSize: 24,
                                            icon: Icon(
                                              Icons.star,
                                              color:
                                                  index < selectedRating
                                                      ? Colors.amber
                                                      : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                selectedRating = index + 1;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await docRef.update({
                                        'rate': selectedRating,
                                      });
                                      // Add notification for the current user after rating using UID as docId
                                      final user = FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        final userDocId = user.uid;
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userDocId)
                                            .collection('notificationList')
                                            .add({
                                              'title': 'تم تقديم شكوى ${report.issue}',
                                              'body': 'شكراً على تقديم الشكوى، تم إرسالها إلى ${report.authority} للاطلاع.',
                                              'timestamp': FieldValue.serverTimestamp(),
                                              'location': report.placeName ?? '',
                                              'color':'Amber',
                                              'icon': 'sync',
                                              'read': false,
                                            });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('موافق'),
                                  ),
                                ],
                              ),
                        );
                      },
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم حفظ الشكوى بنجاح.')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل في إرسال الشكوى: $e')),
                    );
                  }
                }
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

// --- Helper methods for user info ---
Future<String?> _getCurrentUserNationalId() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!docSnapshot.exists) return null;
  return docSnapshot.data()?['national_id'];
}

Future<String?> _getFullName() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!docSnapshot.exists) return null;
  final data = docSnapshot.data()!;
  final firstName = data['first_name'] ?? '';
  final secondName = data['second_name'] ?? '';
  final middleName = data['middle_name'] ?? '';
  final lastName = data['last_name'] ?? '';
  return '$firstName $secondName $middleName $lastName';
}