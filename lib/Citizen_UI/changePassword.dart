import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
    super.dispose();
  }

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350, maxHeight: 350),
            child: AlertDialog(
              title: const Center(child: Text("تم")),
              content: const SizedBox(
                child: Center(
                  child: Text(
                    "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseAuth.instance.signOut();
                    }
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('signin', (route) => false);
                    }
                  },
                  child: const Text("حسنا"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

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
                      "تغيير كلمة المرور",
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
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  TextFormField(
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      labelText: "البريد الإلكتروني",
                      hintText: "أدخل بريدك الإلكتروني",
                      labelStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.w500),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      filled: true,
                      fillColor: _inputFillColor,
                      border: _inputBorder,
                      enabledBorder: _inputBorder,
                      focusedBorder: _inputFocusedBorder,
                      errorBorder: _inputBorder.copyWith(borderSide: BorderSide(color: Colors.red, width: 1)),
                      focusedErrorBorder: _inputFocusedBorder.copyWith(borderSide: BorderSide(color: Colors.red, width: 1.5)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'الرجاء إدخال بريد إلكتروني صالح';
                      }
                      return null;
                    },
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
                    child: const Text("إرسال رابط إعادة التعيين"),
                  ),
                ],
              ),
            ),
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