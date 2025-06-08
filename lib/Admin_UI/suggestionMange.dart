import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sawweb/Admin_UI/model/employee.dart';
import 'package:sawweb/Admin_UI/suggestionManger.dart';

class EmployeeModel {
  final String id;
  final String fullName;
  final String department;

  EmployeeModel({
    required this.id,
    required this.fullName,
    required this.department,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class SuggestionDetailAdminScreen extends StatefulWidget {
  final SuggestionModel suggestion;
  const SuggestionDetailAdminScreen({super.key, required this.suggestion});

  @override
  State<SuggestionDetailAdminScreen> createState() =>
      _SuggestionDetailAdminScreenState();
}

class _SuggestionDetailAdminScreenState
  extends State<SuggestionDetailAdminScreen> {
  final GlobalKey<FormState> _assignmentFormKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _appBackgroundColor = const Color.fromARGB(255, 242, 242, 245);
  final Color _cardBackgroundColor = Colors.white;

  late SuggestionModel _currentSuggestionData;
  final TextEditingController _adminNoteController = TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();

  List<AdminAddedNote> _adminAddedNotesLocally = [];
  List<XFile> _adminSelectedPhotos = [];
  List<PlatformFile> _adminSelectedFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _showAssignmentSection = false;
  EmployeeModel? _selectedEmployeeForAssignment;

  final List<EmployeeModel> _availableEmployees = [
    EmployeeModel(
      id: 'emp001',
      fullName: 'أحمد خالد محمود علي',
      department: 'صيانة الطرق',
    ),
    EmployeeModel(
      id: 'emp002',
      fullName: 'فاطمة سعيد ياسين القاسم',
      department: 'شبكات المياه والصرف',
    ),
    EmployeeModel(
      id: 'emp003',
      fullName: 'يوسف إبراهيم حسن مراد',
      department: 'الإنارة العامة',
    ),
    EmployeeModel(
      id: 'emp004',
      fullName: 'سارة عمر عبد الرحمن',
      department: 'النظافة والبيئة',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentSuggestionData = widget.suggestion;
  }

  @override
  void dispose() {
    _adminNoteController.dispose();
    _rejectionReasonController.dispose();
    super.dispose();
  }

  Widget _buildDetailRow(
    String label,
    String? value, {
    IconData? icon,
    VoidCallback? onLinkTap,
  }) {
    Widget valueWidget = Text(
      value ?? 'غير متوفر',
      textAlign: TextAlign.right,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: valueWidget),
          const SizedBox(width: 10),
          SizedBox(
            width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    ":$label",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Icon(icon, size: 18, color: _primaryColor.withOpacity(0.9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "قيد الاطلاع":
        return Colors.blue.shade600;
      case 'قيد المعالجة':
        return Colors.orange.shade700;
      case 'تم الحل':
        return Colors.green.shade700;
      case 'مرفوضة':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  void _acceptSuggestion() {
    setState(() {
      _showAssignmentSection = true; // إظهار قسم الإسناد
      _currentSuggestionData.status = "قيد المعالجة"; // تغيير الحالة مؤقتاً
    });
  }

  void _rejectSuggestion() {
    _rejectionReasonController.clear();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "رفض الاقتراح",
            textAlign: TextAlign.right,
            style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "هل أنت متأكد أنك تريد رفض هذا الاقتراح؟",
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _rejectionReasonController,
                decoration: InputDecoration(
                  hintText: "سبب الرفض (اختياري)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              child: Text(
                "إلغاء",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
              ),
              child: const Text(
                "تأكيد الرفض",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _currentSuggestionData.status = "مرفوض";
                  _saveAdminInputs(
                    rejectionReason: _rejectionReasonController.text.trim(),
                  );
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم رفض الاقتراح')),
                );
                Navigator.pop(context, _currentSuggestionData.status);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmAssignment() {
    if (_assignmentFormKey.currentState!.validate()) {
      setState(() {
        _currentSuggestionData.status =
            "قيد المعالجة"; 
        _showAssignmentSection = false; 
        _saveAdminInputs(); 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إسناد الاقتراح للموظف بنجاح.')),
      );
    }
  }

  Future<void> _pickAdminPhotos() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70,
      );
      if (pickedFiles.isNotEmpty) {
        setState(() => _adminSelectedPhotos.addAll(pickedFiles));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم اختيار ${pickedFiles.length} صور.')),
        );
      }
    } catch (e) {
      print('Error picking admin photos: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصور: $e')));
    }
  }

  Future<void> _pickAdminFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'txt',
          'jpg',
          'jpeg',
          'png',
        ],
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _adminSelectedFiles.addAll(result.files));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم اختيار ${result.files.length} ملفات.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الملفات: $e')));
    }
  }

  void _addAdminNote() {
    if (_adminNoteController.text.trim().isNotEmpty) {
      setState(() {
        _adminAddedNotesLocally.add(
          AdminAddedNote(
            text: _adminNoteController.text.trim(),
            timestamp: DateTime.now(),
            adminName: "آيات,"
          ),
        );
        _adminNoteController.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تمت إضافة الملاحظة.')));
    }
  }

  void _saveAdminInputs({String? rejectionReason}) {
    if (_adminAddedNotesLocally.isNotEmpty)
      print(
        "الملاحظات المضافة: ${_adminAddedNotesLocally.map((n) => n.text).toList()}",
      );
    if (_adminSelectedPhotos.isNotEmpty)
      print(
        "الصور المختارة للرفع: ${_adminSelectedPhotos.map((p) => p.name).toList()}",
      );
    if (_adminSelectedFiles.isNotEmpty)
      print(
        "الملفات المختارة للرفع: ${_adminSelectedFiles.map((f) => f.name).toList()}",
      );
    if (rejectionReason != null && rejectionReason.isNotEmpty)
      print("سبب الرفض (سيُحفظ): $rejectionReason");
  }

  @override
  Widget build(BuildContext context) {
    final String formattedSubmissionDate = DateFormat(
      'yyyy/MM/dd - hh:mm a',
      'ar',
    ).format(_currentSuggestionData.submissionDate);
    bool canTakeAction =
        _currentSuggestionData.status == "قيد الاطلاع";
    return Scaffold(
      backgroundColor: _appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.4),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: AppBar(
              title: Text(
                "تفاصيل الاقتراح",
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: BackButton(
                color: _primaryColor,
                onPressed:
                    () => Navigator.of(
                      context,
                    ).pop(_currentSuggestionData.status),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Card(
              elevation: 1.5,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: _cardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              _currentSuggestionData.status,
                            ).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _currentSuggestionData.status,
                            style: TextStyle(
                              color: _getStatusColor(
                                _currentSuggestionData.status,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          "معلومات الاقتراح",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    const Divider(height: 25, thickness: 0.5),
                    _buildDetailRow(
                      "العنـــــــــــــوان",
                      _currentSuggestionData.title,
                      icon: Icons.title_rounded,
                    ),
                    _buildDetailRow(
                      "الفئـــــــــــــــــــة",
                      _currentSuggestionData.categoryName,
                      icon: Icons.category_outlined,
                    ),
                    _buildDetailRow(
                      "تاريخ التقديم",
                      formattedSubmissionDate,
                      icon: Icons.calendar_today_outlined,
                    ),
                    _buildDetailRow(
                      "مقــــــدم من",
                      _currentSuggestionData.submittedByName ?? "غير محدد",
                      icon: Icons.person_pin_outlined,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ":وصـــــف الاقتراح",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _appBackgroundColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _currentSuggestionData.description,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (_currentSuggestionData.photoUrl != null &&
                        _currentSuggestionData.photoUrl!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        ":الصورة المرفقة من المستخدم",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _primaryColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                _currentSuggestionData.photoUrl!,
                              ),
                              fit: BoxFit.contain,
                              onError: (e, s) => print('Error'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_currentSuggestionData.attachmentFileNames != null &&
                        _currentSuggestionData
                            .attachmentFileNames!
                            .isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        ":المرفقات من المستخدم",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _primaryColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      ..._currentSuggestionData.attachmentFileNames!
                          .map(
                            (fileName) => InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(':فتح الملف $fileName'),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      fileName,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue.shade800,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.attach_file_rounded,
                                      size: 20,
                                      color: Colors.grey.shade700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ],
                ),
              ),
            ),

            if (canTakeAction && !_showAssignmentSection)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "رفض",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _rejectSuggestion,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "قبول",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _acceptSuggestion,
                      ),
                    ),
                  ],
                ),
              ),
    //assinge the suggestion to the employee
            if (_showAssignmentSection)
              Form(
                key: _assignmentFormKey,
                child: Card(
                  elevation: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: _cardBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "إسناد الاقتراح لموظف",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const Divider(height: 20),
                        Text(
                          "اختر الموظف المسؤول عن المتابعة",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: _appBackgroundColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonFormField<EmployeeModel>(
                            value: _selectedEmployeeForAssignment,
                            hint: const Text(
                              "اختر موظفاً",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.grey),
                            ),
                            isExpanded: true,
                            items:
                                _availableEmployees.map((
                                  EmployeeModel employee,
                                ) {
                                  return DropdownMenuItem<EmployeeModel>(
                                    value: employee,
                                    child: Align(
                                      child: Text(
                                        "${employee.fullName} (${employee.department})",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: _primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged:
                                (EmployeeModel? newValue) => setState(
                                  () =>
                                      _selectedEmployeeForAssignment = newValue,
                                ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator:
                                (value) =>
                                    value == null
                                        ? 'الرجاء اختيار الموظف المسؤول'
                                        : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: Text(
                                "إلغاء",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _showAssignmentSection = false;
                                  _currentSuggestionData.status =
                                      "قيد الاطلاع"; // إرجاع الحالة
                                  _selectedEmployeeForAssignment = null;
                                });
                              },
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.assignment_turned_in_outlined,
                                size: 18,
                              ),
                              label: const Text(
                                "تأكيد الإسناد",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: _confirmAssignment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            Card(
              elevation: 1.5,
              margin: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: _cardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "إجراءات إدارية إضافية",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const Divider(height: 20),
                    Text(
                      ":إضافة ملاحظة إدارية",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller:
                          _adminNoteController 
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: _addAdminNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor.withOpacity(0.8),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("إضافة الملاحظة"),
                      ),
                    ),
                    if (_adminAddedNotesLocally.isNotEmpty) ...[
                    ],

                    const SizedBox(height: 15),
                    Text(
                      "إرفاق صور/ملفات إدارية:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.attach_file, size: 20),
                          label: const Text("ملفات"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primaryColor,
                            side: BorderSide(
                              color: _primaryColor.withOpacity(0.7),
                            ),
                          ),
                          onPressed: _pickAdminFiles,
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 20,
                          ),
                          label: const Text("صور"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primaryColor,
                            side: BorderSide(
                              color: _primaryColor.withOpacity(0.7),
                            ),
                          ),
                          onPressed: _pickAdminPhotos,
                        ),
                      ],
                    ),
                    if (_adminSelectedPhotos.isNotEmpty) ...[
                    ],
                    if (_adminSelectedFiles.isNotEmpty) ...[
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
