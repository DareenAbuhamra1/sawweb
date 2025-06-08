import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawweb/Admin_UI/emolyeemange.dart';
import 'package:sawweb/Admin_UI/model/employee.dart';
import 'package:sawweb/Admin_UI/model/report.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final ReportModel complaint;

  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  final GlobalKey<FormState> _assignmentFormKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _appBackgroundColor = const Color.fromARGB(255, 242, 242, 245);
  final Color _cardBackgroundColor = Colors.white;
  final Color _secondaryTextColor = Colors.grey.shade700;

  late ReportModel _currentComplaintData;
  bool _showAssignmentSection = false;

  final List<EmployeeModel> _availableEmployees = [
    EmployeeModel(
      id: 'emp001',
      fullName: 'أحمد خالد محمود علي',
      department: 'صيانة الطرق',
      nationalId: '',
      employeeId: '',
      phoneNumber: '',
      responsibility: '',
    ),
    EmployeeModel(
      id: 'emp002',
      fullName: 'فاطمة سعيد ياسين القاسم',
      department: 'شبكات المياه والصرف',
      nationalId: '',
      employeeId: '',
      phoneNumber: '',
      responsibility: '',
    ),
    EmployeeModel(
      id: 'emp003',
      fullName: 'يوسف إبراهيم حسن مراد',
      department: 'الإنارة العامة',
      nationalId: '',
      employeeId: '',
      phoneNumber: '',
      responsibility: '',
    ),
    EmployeeModel(
      id: 'emp004',
      fullName: 'سارة عمر عبد الرحمن',
      department: 'النظافة والبيئة',
      nationalId: '',
      employeeId: '',
      phoneNumber: '',
      responsibility: '',
    ),
  ];
  EmployeeModel? _selectedEmployeeForAssignment;
  final TextEditingController _adminNotesController = TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentComplaintData = widget.complaint;
  }

  @override
  void dispose() {
    _adminNotesController.dispose();
    _rejectionReasonController.dispose();
    super.dispose();
  }

  Widget _buildDetailRow(
    String label,
    String? value, {
    IconData? icon,
    bool isLink = false,
    VoidCallback? onLinkTap,
  }) {
    Widget valueWidget = Text(
      value ?? 'غير متوفر',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 13,
        color: isLink ? Colors.blue.shade700 : Colors.black87,
        decoration: isLink ? TextDecoration.underline : TextDecoration.none,
        height: 1.4,
      ),
    );

    if (isLink && onLinkTap != null) {
      valueWidget = InkWell(onTap: onLinkTap, child: valueWidget);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: valueWidget),
          const SizedBox(width: 5),
          SizedBox(
            width: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    ":$label",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 10), // مسافة بين العنوان والقيمة
                if (icon != null)
                  Icon(icon, size: 18, color: _primaryColor.withOpacity(0.9)),
                if (icon != null) const SizedBox(width: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColorLocal(String status) {
    // دالة محلية حتى لا تتداخل مع دالة الشاشة السابقة إذا كانوا في نفس الملف
    switch (status) {
      case 'قيد الاطلاع':
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

  void _acceptComplaintAndShowAssignment() {
    setState(() {
      _showAssignmentSection = true;
    });
  }

  void _rejectComplaint() {
    _rejectionReasonController.clear();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "رفض الشكوى",
            textAlign: TextAlign.right,
            style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "هل أنت متأكد أنك تريد رفض هذه الشكوى؟",
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 15),
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
                  _currentComplaintData.status = "مرفوضة";
                  _showAssignmentSection = false;
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('تم رفض الشكوى.')));
                Navigator.pop(
                  context,
                  _currentComplaintData.status,
                ); // إرجاع الحالة الجديدة لشاشة القائمة
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
        _currentComplaintData.status = "قيد المعالجة";
        _showAssignmentSection = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إسناد الشكوى للموظف بنجاح.')),
      );
      Navigator.pop(
        context,
        _currentComplaintData.status,
      ); // إرجاع الحالة الجديدة لشاشة القائمة
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedSubmissionDate = DateFormat(
      'yyyy/MM/dd - hh:mm a',
      'ar',
    ).format(_currentComplaintData.submissionTimestamp);
    final String problemDateStr =
        _currentComplaintData.problemDate != null
            ? DateFormat(
              'yyyy/MM/dd',
              'ar',
            ).format(_currentComplaintData.problemDate!)
            : 'غير محدد';
    bool canTakeAction = _currentComplaintData.status == "قيد الاطلاع";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 245),
      appBar: AppBar(
        title: Text(
          "شكوى ",
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
              () => Navigator.of(context).pop(_currentComplaintData.status),
        ), // إرجاع الحالة عند الرجوع
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
                            color: _getStatusColorLocal(
                              _currentComplaintData.status,
                            ).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _currentComplaintData.status,
                            style: TextStyle(
                              color: _getStatusColorLocal(
                                _currentComplaintData.status,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          "معلومات الشكوى",
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
                      "المشكلة",
                      _currentComplaintData.title,
                      icon: Icons.add_card_rounded,
                    ),
                    _buildDetailRow(
                      "الفئـــــة",
                      _currentComplaintData.type,
                      icon: Icons.category_outlined,
                    ),
                    if (_currentComplaintData.issue != null &&
                        _currentComplaintData.issue!.isNotEmpty)
                      _buildDetailRow(
                        "المشكلة المحددة",
                        _currentComplaintData.issue,
                        icon: Icons.report_problem_outlined,
                      ),
                    _buildDetailRow(
                      "تـــــــــاريخ التقـــديم",
                      formattedSubmissionDate,
                      icon: Icons.calendar_today_outlined,
                    ),
                    _buildDetailRow(
                      "تـــــــــاريخ المشكلة",
                      problemDateStr,
                      icon: Icons.date_range_outlined,
                    ),
                    _buildDetailRow(
                      "مقدمـــــة مـــــــــن",
                      _currentComplaintData.submittedByName ?? "غير محدد",
                      icon: Icons.person_pin_outlined,
                    ),
                    _buildDetailRow(
                      "الجهة المسؤولـــة",
                      _currentComplaintData.authorityName,
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ":وصف المشكلة",
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
                     // height: 100, //  <--- قومي بإزالة هذا السطر أو التعليق عليه
                      decoration: BoxDecoration(
                        color: _appBackgroundColor.withOpacity(
                          0.6,
                        ), // افترضي أن _appBackgroundColor مُعرّف
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _currentComplaintData
                            .description, // افترضي أن _currentComplaintData مُعرّف
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ), // إضافة height للنص لتحسين القراءة
                      ),
                    ),
                    if (_currentComplaintData.photoUrl != null &&
                        _currentComplaintData.photoUrl!.isNotEmpty) ...[
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
                                _currentComplaintData.photoUrl!,
                              ),
                              fit: BoxFit.contain,
                              onError:
                                  (e, s) => print('Error loading image: $e'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_currentComplaintData.attachmentFileNames != null &&
                        _currentComplaintData
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
                      ..._currentComplaintData.attachmentFileNames!
                          .map(
                            (fileName) => InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('فتح الملف: $fileName'),
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
                        onPressed: _rejectComplaint,
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
                        onPressed: _acceptComplaintAndShowAssignment,
                      ),
                    ),
                  ],
                ),
              ),

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
                          "إسناد الشكوى لموظف",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const Divider(height: 20),
                        Text(
                          ":اختر الموظف المسؤول",
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
                            dropdownColor: Colors.white,
                            
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
                                      alignment: Alignment.centerRight,
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
                        const SizedBox(height: 15),
                        Text(
                          "ملاحظات توجيهية للموظف (اختياري):",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _adminNotesController,
                          textAlign:
                              TextAlign
                                  .right, //textDirection: TextDirection.rtl, maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "اكتب ملاحظاتك هنا",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            
                            fillColor: _appBackgroundColor.withOpacity(0.7),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: Text(
                                "إلغاء الإسناد",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed:
                                  () => setState(() {
                                    _showAssignmentSection = false;
                                    _selectedEmployeeForAssignment = null;
                                    _adminNotesController
                                        .clear(); /* _currentComplaintData.status = "جديدة"; */
                                  }),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
