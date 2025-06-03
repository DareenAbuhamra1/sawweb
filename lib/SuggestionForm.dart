import 'dart:io'; // لاستخدام كائن File عند رفع الملفات

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Suggestionform extends StatefulWidget {
  String? categoryName;
  Suggestionform({super.key, this.categoryName}); // تم تعديل الكونستركتور ليشمل categoryName
  @override
  State<Suggestionform> createState() => _SuggestionformState();
}

class _SuggestionformState extends State<Suggestionform> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<PlatformFile>? _attachments;
  String? selectedCategory;
  String? selectedIssue; // هذا المتغير غير مستخدم حالياً في الواجهة
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
 // LatLng? _suggestionLocation; // لتخزين الموقع المختار من الخريطة أو خدمة الموقع

  // --- متغيرات لحالة التحميل ---
  // bool _isUploading = false;
  // --- نهاية متغيرات حالة التحميل ---

  Future<void> _pickAttachments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt'], // تم إضافة jpeg, docx, txt
      );

      if (result != null) {
        setState(() {
          _attachments = result.files;
        });
        if (mounted) { // التأكد أن الويدجت ما زال في الشجرة
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إضافة ${_attachments!.length} مرفقات بنجاح!')),
          );
        }
      } else {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('لم يتم اختيار أي مرفقات.')),
          );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('لم يتم اختيار صورة.')),
          );
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في اختيار الصورة: $e')),
        );
      }
    }
  }

  List<String> SuggestionTypes = [
    'طُرقات',
    'الزراعة',
    'السياحة',
    'النظافة',
    'كهرباء',
    'مياه وصرف صحي', // مثال لإضافة تصنيف
    'أخرى' // مثال لإضافة تصنيف
  ];


  @override
  void initState() {
    super.initState();
    // إذا كان widget.categoryName غير فارغ، يتم تعيينه كقيمة أولية
    // وإلا، إذا كانت القائمة SuggestionTypes غير فارغة، يتم اختيار أول عنصر كقيمة افتراضية
    if (widget.categoryName != null && SuggestionTypes.contains(widget.categoryName)) {
      selectedCategory = widget.categoryName;
    } else if (SuggestionTypes.isNotEmpty) {
      // selectedCategory = SuggestionTypes[0]; // يمكنك جعل أول عنصر هو الافتراضي إذا أردت
    }
  }

  // --- دوال لرفع الملفات إلى Firebase Storage (كـ تعليقات) ---
  // Future<String?> _uploadFileToFirebase(File file, String pathInStorage) async {
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance.ref(pathInStorage);
  //     final uploadTask = ref.putFile(file);
  //     final snapshot = await uploadTask.whenComplete(() => {});
  //     final downloadUrl = await snapshot.ref.getDownloadURL();
  //     return downloadUrl;
  //   } catch (e) {
  //     print('Firebase Storage - Error uploading file ($pathInStorage): $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('خطأ في رفع الملف: ${file.path.split('/').last}')),
  //       );
  //     }
  //     return null;
  //   }
  // }
  // --- نهاية دوال الرفع ---


  // --- دالة لإرسال بيانات الاقتراح إلى Firestore (كـ تعليقات) ---
  // Future<void> _submitSuggestionToFirebase() async {
  //   if (titleController.text.isEmpty) {
  //     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الرجاء إدخال عنوان الاقتراح.')));
  //     return;
  //   }
  //   if (selectedCategory == null) {
  //     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الرجاء اختيار تصنيف الاقتراح.')));
  //     return;
  //   }
  //   if (descriptionController.text.isEmpty) {
  //      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الرجاء إدخال وصف الاقتراح.')));
  //     return;
  //   }

  //   setState(() {
  //     _isUploading = true;
  //   });

  //   String? imageUrl;
  //   List<String> attachmentUrls = [];

  //   // 1. رفع الصورة المختارة (إن وجدت)
  //   if (_selectedImage != null) {
  //     File imageFile = File(_selectedImage!.path);
  //     String imagePath = 'suggestion_images/${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.name}';
  //     imageUrl = await _uploadFileToFirebase(imageFile, imagePath);
  //   }

  //   // 2. رفع المرفقات (إن وجدت)
  //   if (_attachments != null && _attachments!.isNotEmpty) {
  //     for (PlatformFile platformFile in _attachments!) {
  //       if (platformFile.path != null) {
  //         File file = File(platformFile.path!);
  //         String attachmentPath = 'suggestion_attachments/${DateTime.now().millisecondsSinceEpoch}_${platformFile.name}';
  //         String? url = await _uploadFileToFirebase(file, attachmentPath);
  //         if (url != null) {
  //           attachmentUrls.add(url);
  //         }
  //       }
  //     }
  //   }
    
  //   // 3. تجهيز بيانات الاقتراح
  //   Map<String, dynamic> suggestionData = {
  //     'title': titleController.text,
  //     'category': selectedCategory,
  //     'description': descriptionController.text,
  //     'imageUrl': imageUrl, // قد يكون null
  //     'attachmentUrls': attachmentUrls, // قد تكون قائمة فارغة
  //     'timestamp': FieldValue.serverTimestamp(), // وقت إنشاء الاقتراح على الخادم
  //     // 'userId': FirebaseAuth.instance.currentUser?.uid, // مثال إذا كان هناك مستخدم مسجل دخوله
  //   };

  //   // إضافة بيانات الموقع إذا كانت متوفرة
  //   if (_suggestionLocation != null) {
  //     suggestionData['location'] = GeoPoint(_suggestionLocation!.latitude, _suggestionLocation!.longitude);
  //     // أو يمكنك تخزينها كـ map:
  //     // suggestionData['location'] = {
  //     //   'latitude': _suggestionLocation!.latitude,
  //     //   'longitude': _suggestionLocation!.longitude,
  //     // };
  //   }

  //   // 4. إرسال البيانات إلى Firestore
  //   try {
  //     await FirebaseFirestore.instance.collection('suggestions').add(suggestionData);
  //     if (mounted) {
  //        ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('تم إرسال الاقتراح بنجاح!')),
  //       );
  //       // يمكنك هنا إعادة تعيين الحقول أو الانتقال إلى شاشة أخرى
  //       titleController.clear();
  //       descriptionController.clear();
  //       setState(() {
  //         _selectedImage = null;
  //         _attachments = null;
  //         _suggestionLocation = null;
  //         // selectedCategory = SuggestionTypes.isNotEmpty ? SuggestionTypes[0] : null; // إعادة تعيين التصنيف
  //       });
  //       // Navigator.pop(context); // للرجوع للخلف مثلاً
  //     }
  //   } catch (e) {
  //     print('Firestore - Error adding suggestion: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('حدث خطأ أثناء إرسال الاقتراح: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //        setState(() {
  //         _isUploading = false;
  //       });
  //     }
  //   }
  // }
  // --- نهاية دالة إرسال الاقتراح ---

  // --- دالة لتحديث الموقع (مثال، يمكنك ربطها بزر الموقع أو الخريطة) ---
  // void _updateSuggestionLocation(LatLng location) {
  //   setState(() {
  //     _suggestionLocation = location;
  //   });
  //   if(mounted) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('تم تحديد الموقع: ${location.latitude}, ${location.longitude}')),
  //     );
  //   }
  // }
  // --- نهاية دالة تحديث الموقع ---

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
              leading: BackButton(color: Color.fromARGB(255, 10, 40, 95), onPressed: () => Navigator.of(context).pop()),
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
            SizedBox(height: 16),
            Text('تصنيف الاقتراح', style: TextStyle(fontWeight: FontWeight.bold ,color:Color.fromARGB(255, 10, 40, 95))),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0), // لتوسيط السهم قليلاً
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
                  hint: Text('اختر تصنيفًا', style: TextStyle(color: Color.fromARGB(153, 93, 97, 104))),
                  items:
                      SuggestionTypes
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Align( // لمحاذاة النص إلى اليمين داخل كل عنصر
                                alignment: Alignment.centerRight,
                                child: Text(
                                  c,
                                  // textAlign: TextAlign.right, // هذا قد لا يعمل كما هو متوقع هنا
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 10, 40, 95), // لون النص للعناصر
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    // contentPadding: EdgeInsets.symmetric(horizontal: 0), // إزالة الـ padding لتوسيط أفضل
                  ),
                  isExpanded: true, // لجعل العنصر يملأ العرض
                  icon: Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 10, 40, 95)), // لون السهم
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
              crossAxisAlignment: CrossAxisAlignment.start, // لمحاذاة العناصر في الأعلى
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: _attachImage,
                    child: Container(
                      height: 126,
                      // width: 109, // الـ Expanded سيتعامل مع العرض
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
                      child: _selectedImage == null 
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined, // أيقونة أوضح قليلاً
                                  size: 40,
                                  color: Color.fromARGB(255, 10, 40, 95),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'ارفق صورة', // تم تعديل النص قليلاً
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(153, 93, 97, 104),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect( // لعرض الصورة المختارة مع حواف دائرية
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                              width: double.infinity, // لملء عرض الكونتينر
                              height: double.infinity, // لملء ارتفاع الكونتينر
                            ),
                          ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 126, // تحديد ارتفاع مماثل لمربع الصورة
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
                      maxLines: null, // للسماح بعدة أسطر ديناميكياً
                      expands: true, // لجعل الحقل يملأ المساحة المتاحة
                      textAlignVertical: TextAlignVertical.top, // لبدء الكتابة من الأعلى
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
             // --- عرض المرفقات المختارة ---
            if (_attachments != null && _attachments!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'المرفقات (${_attachments!.length}):',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 10, 40, 95)),
                ),
              ),
            if (_attachments != null && _attachments!.isNotEmpty)
              Container(
                height: 80, // ارتفاع لعرض قائمة المرفقات أفقياً
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // عرض أفقي للمرفقات
                  itemCount: _attachments!.length,
                  itemBuilder: (context, index) {
                    final file = _attachments![index];
                    return Container(
                      width: 100, // عرض كل مرفق
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                         boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_file, size: 24, color: Color.fromARGB(255, 10, 40, 95)),
                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            if (_attachments != null && _attachments!.isNotEmpty) SizedBox(height: 16),
            // --- نهاية عرض المرفقات ---
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 10, 40, 95).withOpacity(0.1), // لون خلفية مختلف قليلاً
                  foregroundColor: Color.fromARGB(255, 10, 40, 95), // لون الأيقونة والنص
                  elevation: 0,
                  side: BorderSide(color: Color.fromARGB(255, 10, 40, 95)), // إطار للزر
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _pickAttachments,
                icon: Icon(Icons.attach_file_outlined), // أيقونة مختلفة
                label: Text('إضافة مرفقات أخرى (pdf, doc, ..)'),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'تحديد الموقع (اختياري)',
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
              child: ClipRRect( // لجعل الخريطة بحواف دائرية
                borderRadius: BorderRadius.circular(8.0),
                // --- كود الخريطة (مثال، يحتاج إلى تفعيل وإعداد) ---
                // child: _suggestionLocation == null 
                // ? Center(child: Text('لم يتم تحديد موقع بعد.\nاضغط على زر "تحديد الموقع الحالي" أو اختر من الخريطة.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)))
                // : GoogleMap(
                //   initialCameraPosition: CameraPosition(
                //     target: _suggestionLocation!, // استخدام الموقع المحدد كمركز
                //     zoom: 15,
                //   ),
                //   markers: {
                //     if (_suggestionLocation != null)
                //       Marker(
                //         markerId: MarkerId('suggestionLocation'),
                //         position: _suggestionLocation!,
                //       ),
                //   },
                //   onTap: (LatLng location) { // للسماح للمستخدم بالنقر على الخريطة لتحديد موقع
                //     _updateSuggestionLocation(location);
                //   },
                //   // onMapCreated: (controller) {}, // يمكنك استخدام controller إذا احتجت
                // ),
                // --- نهاية كود الخريطة ---
                // --- مؤقتاً حتى يتم تفعيل الخريطة ---
                child: Center(child: Text('الخريطة ستعرض هنا', style: TextStyle(color: Colors.grey[600]))),
              )
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // --- كود للحصول على الموقع الحالي للمستخدم (مثال باستخدام Geolocator) ---
                  // final position = await Geolocator.getCurrentPosition();
                  // _updateSuggestionLocation(LatLng(position.latitude, position.longitude));
                  // --- نهاية كود الحصول على الموقع ---
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('سيتم هنا تفعيل خاصية تحديد الموقع الحالي.')));
                },
                icon: Icon(Icons.my_location, color: Color.fromARGB(255, 10, 40, 95)),
                label: Text('تحديد الموقع الحالي', style: TextStyle(color: Color.fromARGB(255, 10, 40, 95))),
              ),
            ),

            SizedBox(height: 24), // زيادة المسافة قبل زر الإرسال
            // --- زر الإرسال ---
            // if (_isUploading)
            //   Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 10, 40, 95))),
            // if (!_isUploading)
              ElevatedButton(
                onPressed: () {
                  print('Title: ${titleController.text}');
                  print('Category: $selectedCategory');
                  print('Description: ${descriptionController.text}');
                  print('Image: ${_selectedImage?.path}');
                  _attachments?.forEach((file) => print('Attachment: ${file.name} - ${file.path}'));
                   if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('سيتم هنا إرسال الاقتراح إلى Firebase.')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 10, 40, 95), // لون أساسي للزر
                  foregroundColor: Colors.white, // لون النص والأيقونة
                  minimumSize: Size(double.infinity, 52), // حجم أكبر قليلاً للزر
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: Text('إرسال الاقتراح', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            SizedBox(height: 16), // مسافة إضافية في الأسفل
          ],
        ),
      ),
    );
  }
}