import 'package:flutter/material.dart';
import 'package:sawweb/Admin_UI/model/employee.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final EmployeeModel? employee; 

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nationalIdController;
  late TextEditingController _employeeIdController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _isEditMode = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    _isEditMode = widget.employee != null;

    _nationalIdController = TextEditingController(text: _isEditMode ? widget.employee!.nationalId : '');
    _employeeIdController = TextEditingController(text: _isEditMode ? widget.employee!.employeeId : '');
    _fullNameController = TextEditingController(text: _isEditMode ? widget.employee!.fullName : '');
    _phoneNumberController = TextEditingController(text: _isEditMode ? widget.employee!.phoneNumber : '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _employeeIdController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final employeeData = EmployeeModel(
        id: _isEditMode ? widget.employee!.id : DateTime.now().millisecondsSinceEpoch.toString(), 
        nationalId: _nationalIdController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        department: _isEditMode ? widget.employee!.department : "قسم جديد (مثال)", 
        responsibility: _isEditMode ? widget.employee!.responsibility : "مسؤولية جديدة (مثال)", 
        isActive: _isEditMode ? widget.employee!.isActive : true,
      );
      
      print("--- بيانات الموظف ---");
      print("الرقم الوطني: ${employeeData.nationalId}");
      print("الرقم الوظيفي: ${employeeData.employeeId}");
      print("الاسم: ${employeeData.fullName}");
      print("الهاتف: ${employeeData.phoneNumber}");
      if (!_isEditMode) {
        print("كلمة السر المبدئية: ${_passwordController.text}");
      }
   
      Navigator.pop(context, employeeData); 
    }
  }

   Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    IconData? prefixIcon, 
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon, 
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          labelText,
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.w600, color: _primaryColor, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          textAlign: TextAlign.right,
          style: TextStyle(color: readOnly ? Colors.grey.shade700 : Colors.black87, fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            prefixIcon: prefixIcon != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: Icon(prefixIcon, color: _primaryColor.withOpacity(0.7))) : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: readOnly ? Colors.grey.shade100 : _inputFillColor,
            border: _inputBorder,
            enabledBorder: _inputBorder,
            focusedBorder: _inputFocusedBorder,
            errorBorder: _inputBorder.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1)),
            focusedErrorBorder: _inputFocusedBorder.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
          textDirection: TextDirection.rtl,
        ),
      ],
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
                _isEditMode ? "تعديل بيانات الموظف" : "إضافة موظف جديد",
                style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: _primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
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
              _buildTextField(
                controller: _fullNameController,
                labelText: "الاسم الرباعي",
                hintText: "أدخل الاسم الرباعي للموظف",
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'الرجاء إدخال الاسم الرباعي';
                  if (value.trim().split(' ').length < 4) return 'الرجاء إدخال الاسم الرباعي كاملاً';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nationalIdController,
                labelText: "الرقم الوطني",
                hintText: "أدخل الرقم الوطني (10 أرقام)",
                prefixIcon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'الرجاء إدخال الرقم الوطني';
                  if (value.length != 10 || int.tryParse(value) == null) return 'يجب أن يتكون الرقم الوطني من 10 أرقام';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _employeeIdController,
                labelText: "الرقم الوظيفي",
                hintText: "أدخل الرقم الوظيفي",
                prefixIcon: Icons.assignment_ind_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'الرجاء إدخال الرقم الوظيفي';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneNumberController,
                labelText: "رقم الهاتف",
                hintText: "أدخل رقم الهاتف (مثال: 07XXXXXXXX)",
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'الرجاء إدخال رقم الهاتف';
                   if (!RegExp(r'^07[7-9][0-9]{7}$').hasMatch(value)) return 'صيغة رقم الهاتف غير صحيحة';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (!_isEditMode) ...[
                _buildTextField(
                  controller: _passwordController,
                  labelText: "كلمة السر المبدئية",
                  hintText: "أدخل كلمة سر مبدئية للموظف",
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _primaryColor.withOpacity(0.7)),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة سر مبدئية';
                    if (value.length < 8) return 'يجب أن تكون كلمة السر 8 أحرف على الأقل';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _confirmPasswordController,
                  labelText: "تأكيد كلمة السر المبدئية",
                  hintText: "أعد إدخال كلمة السر",
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _primaryColor.withOpacity(0.7)),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'الرجاء تأكيد كلمة السر';
                    if (value != _passwordController.text) return 'كلمتا السر غير متطابقتين';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],

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
                onPressed: _saveEmployee,
                child: Text(_isEditMode ? "حفظ التغييرات" : "إضافة الموظف"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}