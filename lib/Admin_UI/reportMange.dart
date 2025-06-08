import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawweb/Admin_UI/complaintsdetails.dart' show ComplaintDetailScreen;
import 'package:sawweb/Admin_UI/model/report.dart'; //  قد تحتاجينها لتهيئة التاريخ

class ComplaintsManagementScreen extends StatefulWidget {
  const ComplaintsManagementScreen({super.key});

  @override
  State<ComplaintsManagementScreen> createState() =>
      _ComplaintsManagementScreenState();
}

class _ComplaintsManagementScreenState
    extends State<ComplaintsManagementScreen> {
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _appBackgroundColor = const Color.fromARGB(255, 242, 242, 245);

  final List<ReportModel> _allComplaints = [
    ReportModel(
      id: 'cmp001',
      title: 'حفرة كبيرة في شارع المدينة المنورة',
      type: 'طرقات وبنية تحتية',
      issue: 'صيانة حفر أو هبوط في الشارع',
      authorityName: 'أمانة عمان الكبرى',
      problemDate: DateTime(2024, 5, 28),
      description: 'توجد حفرة عميقة تشكل خطراً على المركبات...',
      submissionTimestamp: DateTime(2024, 6, 1, 10, 30),
      status: 'قيد الاطلاع',
      submittedByName: 'محمد قاسم',
      photoUrl: '',
      attachmentFileNames: ['document1.pdf', 'notes.txt'],
    ),
    ReportModel(
      id: 'cmp002',
      title: 'انقطاع مياه مستمر في حي النزهة',
      type: 'مياه وصرف صحي',
      issue: 'انقطاع مياه',
      authorityName: 'شركة مياهنا',
      description: 'نعاني من انقطاع المياه بشكل يومي لمدة تزيد عن 5 ساعات...',
      submissionTimestamp: DateTime(2024, 6, 2, 14, 00),
      status: 'قيد المعالجة',
      submittedByName: 'عائشة علي',
    ),
    ReportModel(
      id: 'cmp003',
      title: 'تراكم نفايات بالقرب من مدرسة اليرموك',
      type: 'نظافة عامة وصحة بيئة',
      issue: 'تراكم نفايات أو عدم تفريغ حاويات',
      authorityName: 'أمانة عمان الكبرى',
      description: 'النفايات متراكمة منذ أسبوع وتسبب روائح كريهة.',
      submissionTimestamp: DateTime(2024, 5, 30, 9, 15),
      status: 'تم الحل',
      submittedByName: 'أحمد ياسين',
    ),
    ReportModel(
      id: 'cmp004',
      title: 'عمود إنارة معطل في شارع الاستقلال',
      type: 'كهرباء وإنارة عامة',
      issue: 'صيانة أعمدة إنارة أو لمبات محروقة',
      authorityName: 'شركة الكهرباء الوطنية',
      problemDate: DateTime(2024, 5, 15),
      description:
          'الشارع مظلم بسبب عطل في عمود الإنارة رقم 5 بالقرب من المتجر.',
      submissionTimestamp: DateTime(2024, 6, 3, 20, 45),
      status: 'قيد الاطلاع',
      submittedByName: 'فاطمة سعيد',
    ),
    ReportModel(
      id: 'cmp005',
      title: 'إزعاج من أعمال بناء بعد منتصف الليل',
      type: 'سلامة عامة ومخالفات متنوعة',
      issue: 'استمرار أعمال إنشائية لساعات متأخرة ومزعجة',
      authorityName: 'أمانة عمان الكبرى',
      description:
          'أعمال البناء في الموقع المجاور تستمر حتى ساعات متأخرة من الليل مما يسبب إزعاجاً كبيراً للسكان.',
      submissionTimestamp: DateTime(2024, 6, 1, 23, 30),
      status: 'مرفوضة',
      submittedByName: 'عمر حسن',
    ),
  ];

  List<ReportModel> _filteredComplaints = [];
  String? _selectedStatusFilter;
  final List<String> _statusOptions = [
    "الكل",
    "قيد الاطلاع",
    "قيد المعالجة",
    "تم الحل",
    "مرفوضة",
  ];

  @override
  void initState() {
    super.initState();
    _filteredComplaints = List.from(_allComplaints);
    _selectedStatusFilter = _statusOptions[0];
  }

  void _filterComplaints(String? status) {
    setState(() {
      _selectedStatusFilter = status;
      if (status == null || status == "الكل") {
        _filteredComplaints = List.from(_allComplaints);
      } else {
        _filteredComplaints =
            _allComplaints.where((cmp) => cmp.status == status).toList();
      }
    });
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

  Widget _buildComplaintListItem(ReportModel complaint) {
    final String formattedSubmissionDate = DateFormat(
      'yyyy/MM/dd - hh:mm a',
      'ar',
    ).format(complaint.submissionTimestamp);
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 12,
        ),
        title: Text(
          complaint.title,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _primaryColor,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 6),
            Text(
              "${complaint.type}",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                color: const Color.fromARGB(255, 69, 68, 68),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (complaint.issue != null && complaint.issue!.isNotEmpty)
              Text(
                "${complaint.issue}",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            if (complaint.submittedByName != null) const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: _getStatusColor(complaint.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$formattedSubmissionDate",
                        style: TextStyle(
                          fontSize: 13,
                          color: _getStatusColor(complaint.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: _getStatusColor(complaint.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(top: 4),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        complaint.status,
                        style: TextStyle(
                          fontSize: 13,
                          color: _getStatusColor(complaint.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.circle,
                        color: _getStatusColor(complaint.status),
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComplaintDetailScreen(complaint: complaint),
            ),
          ).then((updatedComplaintStatus) {
            if (updatedComplaintStatus != null &&
                updatedComplaintStatus is String) {
              setState(() {
                final index = _allComplaints.indexWhere(
                  (c) => c.id == complaint.id,
                );
                if (index != -1) {
                  _allComplaints[index].status = updatedComplaintStatus;
                  _filterComplaints(
                    _selectedStatusFilter,
                  ); // إعادة تطبيق الفلتر
                }
              });
            }
          });
        },
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: AppBar(
              title: Text(
                "إدارة الشكاوى",
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading:
                  Navigator.canPop(context)
                      ? BackButton(color: _primaryColor)
                      : null,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: _appBackgroundColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatusFilter,
                      icon: Icon(Icons.filter_list_alt, color: _primaryColor),
                      items:
                          _statusOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        _filterComplaints(newValue);
                      },
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  ":فلترة حسب الحالة",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(
            child:
                _filteredComplaints.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedStatusFilter == "الكل" ||
                                    _selectedStatusFilter == null
                                ? 'لا توجد شكاوى حالياً.'
                                : 'لا توجد شكاوى بهذه الحالة: "$_selectedStatusFilter"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        10,
                        16,
                        80,
                      ), // مسافة سفلية للزر العائم
                      itemCount: _filteredComplaints.length,
                      itemBuilder: (context, index) {
                        return _buildComplaintListItem(
                          _filteredComplaints[index],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
