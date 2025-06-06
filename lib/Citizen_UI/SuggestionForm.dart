import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class SuggestionModel {
  final String title;
  final String description;
  final String category;
  final LatLng? location;
  final String? photoPath;
  final List<String>? attachments;
  final Timestamp timestamp;
  final String fullName;
  final String nationalId;
  final int? rate;
  final String? placeName;

  SuggestionModel({
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    required this.fullName,
    required this.nationalId,
    this.location,
    this.photoPath,
    this.attachments,
    this.rate,
    this.placeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'timestamp': timestamp,
      'full_name': fullName,
      'national_id': nationalId,
      'location': location != null
          ? {'latitude': location!.latitude, 'longitude': location!.longitude}
          : null,
      'photo_path': photoPath,
      'attachments': attachments,
      'rate': rate,
      'place_name': placeName,
    };
  }

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];
    return SuggestionModel(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      timestamp: json['timestamp'],
      fullName: json['full_name'],
      nationalId: json['national_id'],
      location: loc != null
          ? LatLng(loc['latitude'], loc['longitude'])
          : null,
      photoPath: json['photo_path'],
      attachments: (json['attachments'] as List?)?.map((e) => e.toString()).toList(),
      rate: json['rate'],
      placeName: json['place_name'],
    );
  }
}
class Suggestionform extends StatefulWidget {
  String? categoryName;
  Suggestionform({super.key, this.categoryName});
  @override
  State<Suggestionform> createState() => _SuggestionformState();
}

class _SuggestionformState extends State<Suggestionform> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<PlatformFile>? _attachments;
  String? selectedCategory;
  String? selectedIssue;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Location for suggestion (nullable)
  LatLng? _suggestionLocation;

  // Method to update suggestion location
  void _updateSuggestionLocation(LatLng location) {
    setState(() {
      _suggestionLocation = location;
    });
  }

  // Add this method to handle Firebase submission
  Future<void> _submitSuggestion(SuggestionModel suggestion) async {
    await FirebaseFirestore.instance.collection('suggestions').add(suggestion.toJson());
  }

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
    'مياه وصرف صحي',
    'أخرى'
  ];


  @override
  void initState() {
    super.initState();
    if (widget.categoryName != null && SuggestionTypes.contains(widget.categoryName)) {
      selectedCategory = widget.categoryName;
    } else if (SuggestionTypes.isNotEmpty) {
    }
  }
  Future<void> _handleSubmit() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر تحديد البريد الإلكتروني للمستخدم.')));
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('خطأ في تحميل البيانات'),
          content: Text('تعذر جلب بيانات المستخدم. يرجى المحاولة لاحقًا.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('موافق'),
            ),
          ],
        ),
      );
      return;
    }

    final userData = querySnapshot.docs.first.data();

    final fullName = '${userData['first_name']} ${userData['second_name']} ${userData['middle_name']} ${userData['last_name']}';
    final nationalId = userData['national_id'] ?? '';

    String? placeName;
    if (_suggestionLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _suggestionLocation!.latitude,
          _suggestionLocation!.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          placeName = '${place.street}, ${place.locality}, ${place.country}';
        }
      } catch (e) {
        print('فشل تحويل الإحداثيات إلى عنوان: $e');
      }
    }

    final Timestamp nowTimestamp = Timestamp.now();
    final suggestion = SuggestionModel(
      title: titleController.text,
      description: descriptionController.text,
      category: selectedCategory ?? '',
      timestamp: nowTimestamp,
      fullName: fullName,
      nationalId: nationalId,
      location: _suggestionLocation,
      placeName: placeName,
      photoPath: _selectedImage?.path,
      attachments: _attachments?.map((e) => e.path!).toList(),
      rate: null,
    );

    try {
      await _submitSuggestion(suggestion);

      // Save notification to user's notificationList subcollection
      final notification = {
        'title': 'تم تقديم المقترح',
        'body': suggestion.title,
        'color': 'amber',
        'date': DateTime.now().toIso8601String(),
        'icon': 'sync',
        'location': suggestion.placeName ?? '',
        'read': false,
        'category': suggestion.category,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      };
      final userDoc = querySnapshot.docs.first.reference;
      await userDoc.collection('notificationList').add(notification);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال الاقتراح بنجاح.')));
        int selectedRating = 0;
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Center(child: Text('شكرًا لمساهمتك')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('تم استلام اقتراحك بنجاح وهو قيد المراجعة.'),
                      SizedBox(height: 12),
                      Text('كيف تُقيّم تجربة تقديم الاقتراح؟'),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
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
                  actions: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          final query = await FirebaseFirestore.instance
                              .collection('suggestions')
                              .where('title', isEqualTo: suggestion.title)
                              .where('national_id', isEqualTo: suggestion.nationalId)
                              .where('timestamp', isEqualTo: suggestion.timestamp)
                              .limit(1)
                              .get();

                          if (query.docs.isNotEmpty) {
                            await query.docs.first.reference.update({'rate': selectedRating});
                          }
                        },
                        child: Text('موافق'),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل في إرسال الاقتراح: $e')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        242,
        242,
        245,
      ), // لون خلفية فاتح
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
                      'قدم اقتراحًا',
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
              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  c,
                                  
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
                  ),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 10, 40, 95)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: _attachImage,
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
                      child: _selectedImage == null 
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: Color.fromARGB(255, 10, 40, 95),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'ارفق صورة',
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
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments!.length,
                  itemBuilder: (context, index) {
                    final file = _attachments![index];
                    return Container(
                      width: 100,
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
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 10, 40, 95).withOpacity(0.1),
                  foregroundColor: Color.fromARGB(255, 10, 40, 95),
                  elevation: 0,
                  side: BorderSide(color: Color.fromARGB(255, 10, 40, 95)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _pickAttachments,
                icon: Icon(Icons.attach_file_outlined),
                label: Text('إضافة مرفقات أخرى (pdf, doc, ..)'),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'تحديد الموقع',
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
                child: _suggestionLocation == null
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(31.9539, 35.9106),
                          zoom: 12,
                        ),
                        onTap: (LatLng location) {
                          _updateSuggestionLocation(location);
                        },
                        markers: {},
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      )
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _suggestionLocation!,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('selected'),
                            position: _suggestionLocation!,
                          ),
                        },
                        onTap: (LatLng location) {
                          _updateSuggestionLocation(location);
                        },
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('سيتم هنا تفعيل خاصية تحديد الموقع الحالي.')));
                 
                },
                icon: Icon(Icons.my_location, color: Color.fromARGB(255, 10, 40, 95)),
                label: Text('تحديد الموقع الحالي', style: TextStyle(color: Color.fromARGB(255, 10, 40, 95))),
              ),
            ),

            SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 10, 40, 95),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: Text('إرسال الاقتراح', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
 