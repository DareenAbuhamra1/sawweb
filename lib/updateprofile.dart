import 'dart:io'; // لاستخدام File مع XFile
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // لإضافة وظيفة اختيار الصورة
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final String email;
  final String phone;
  final String name;
  const EditProfileScreen({super.key, required this.email, required this.phone,required this.name});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  // يمكنك إضافة المزيد من الـ controllers هنا إذا لزم الأمر (مثل العنوان)

  XFile? _newProfileImage;
  final ImagePicker _picker = ImagePicker();

  // بيانات المستخدم الحالية (مثال، سيتم جلبها من قاعدة البيانات)
  late String _currentUserName;
  late String _currentUserEmail;
  late String _currentUserPhone;
  // String? _currentProfileImageUrl;

  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _inputFillColor = Colors.white;
  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
  );
  final OutlineInputBorder _inputFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color.fromARGB(255, 10, 40, 95), width: 1.5),
  );


  @override
  void initState() {
    super.initState();
    _currentUserName = widget.name;
    _nameController = TextEditingController(text: _currentUserName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _currentUserEmail = widget.email;
    _currentUserPhone = widget.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _newProfileImage = pickedFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء اختيار الصورة: $e')),
          
        );
        print('حدث خطأ أثناء اختيار الصورة: $e');
      }
    }
  }

  void _saveProfileChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving changes is currently disabled.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 245),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: AppBar(
              title: Text(
                "تعديل الملف الشخصي",
                style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: BackButton(color: _primaryColor, onPressed: () => Navigator.of(context).pop()),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // --- قسم صورة الملف الشخصي ---
              Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey.shade200,
                    child: _newProfileImage == null /*&& _currentProfileImageUrl == null*/
                        ? Icon(Icons.person, size: 70, color: _primaryColor.withOpacity(0.6))
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: _primaryColor,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        onTap: _pickImage,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                readOnly: true,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
                decoration: InputDecoration(
                  labelText: "الاسم الكامل",
                  hintText: "الاسم الكامل",
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  labelStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.w500),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                    child: Icon(Icons.person_outline, color: _primaryColor.withOpacity(0.7)),
                  ),
                  filled: true,
                  fillColor: _inputFillColor,
                  border: _inputBorder,
                  enabledBorder: _inputBorder,
                  focusedBorder: _inputFocusedBorder,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                labelText: "البريد الإلكتروني",
                hintText: "أدخل البريد الإلكتروني",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                    return 'الرجاء إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                labelText: "رقم الهاتف",
                hintText: "أدخل رقم الهاتف",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onPressed: _saveProfileChanges,
                child: const Text("حفظ التغييرات"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right, 
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        labelStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.w500),
        suffixIcon: Padding( 
           padding: const EdgeInsets.only(left: 12.0, right: 8.0), 
           child: Icon(icon, color: _primaryColor.withOpacity(0.7)),
        ),
        filled: true,
        fillColor: _inputFillColor,
        border: _inputBorder,
        enabledBorder: _inputBorder,
        focusedBorder: _inputFocusedBorder,
        errorBorder: _inputBorder.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1)),
        focusedErrorBorder: _inputFocusedBorder.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
      textDirection: TextDirection.rtl, 
    );
  }
}