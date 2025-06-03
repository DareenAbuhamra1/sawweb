import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

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
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح (محاكاة)')),
        );
        Navigator.pop(context); // العودة إلى شاشة الملف الشخصي أو الإعدادات
      }
    }
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
                "تغيير كلمة المرور",
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              // --- حقول كلمة المرور ---
              _buildPasswordTextField(
                controller: _currentPasswordController,
                labelText: "كلمة المرور الحالية",
                hintText: "أدخل كلمة المرور الحالية",
                obscureText: _obscureCurrentPassword,
                onToggleObscure: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الحالية';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordTextField(
                controller: _newPasswordController,
                labelText: "كلمة المرور الجديدة",
                hintText: "أدخل كلمة المرور الجديدة",
                obscureText: _obscureNewPassword,
                onToggleObscure: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الجديدة';
                  }
                  if (value.length < 8) {
                    return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordTextField(
                controller: _confirmNewPasswordController,
                labelText: "تأكيد كلمة المرور الجديدة",
                hintText: "أعد إدخال كلمة المرور الجديدة",
                obscureText: _obscureConfirmNewPassword,
                onToggleObscure: () {
                  setState(() {
                    _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة المرور الجديدة';
                  }
                  if (value != _newPasswordController.text) {
                    return 'كلمتا المرور غير متطابقتين';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  "نصيحة: استخدم كلمة مرور قوية تحتوي على أحرف كبيرة وصغيرة وأرقام ورموز، ولا تقل عن 8 أحرف.",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 25),

              // --- زر تحديث كلمة المرور ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onPressed: _updatePassword,
                child: const Text("تحديث كلمة المرور"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        prefixIcon: Padding( // استخدام prefixIcon لوضع الأيقونة على اليمين في RTL
          padding: const EdgeInsets.only(right: 12.0, left: 8.0),
          child: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: _primaryColor.withOpacity(0.7),
            ),
            onPressed: onToggleObscure,
          ),
        ),
        filled: true,
        fillColor: _inputFillColor,
        border: _inputBorder,
        enabledBorder: _inputBorder,
        focusedBorder: _inputFocusedBorder,
        errorBorder: _inputBorder.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1)),
        focusedErrorBorder: _inputFocusedBorder.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // ضبط الحشو الداخلي
      ),
      validator: validator,
      textDirection: TextDirection.rtl,
    );
  }
}