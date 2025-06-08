import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawweb/Admin_UI/suggestionMange.dart'; //  قد تحتاجينها لتهيئة التاريخ بشكل جميل

class SuggestionModel {
  final String id;
  final String title;
  final String description;
  final String categoryName;
  final String? submittedByUserId; // أو اسم المستخدم مباشرة إذا كان متاحاً
  final String? submittedByName; // اسم المستخدم للعرض
  final DateTime submissionDate;
  String
  status; // أمثلة: "جديد", "قيد الدراسة", "تم الأخذ به", "مرفوض", "مؤرشف"
  final String? photoUrl;
  final List<String>? attachmentFileNames; // أسماء الملفات أو روابطها

  SuggestionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryName,
    this.submittedByUserId,
    this.submittedByName,
    required this.submissionDate,
    required this.status,
    this.photoUrl,
    this.attachmentFileNames,
  });
}

class SuggestionsManagementScreen extends StatefulWidget {
  const SuggestionsManagementScreen({super.key});

  @override
  State<SuggestionsManagementScreen> createState() =>
      _SuggestionsManagementScreenState();
}

class _SuggestionsManagementScreenState
    extends State<SuggestionsManagementScreen> {
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _appBackgroundColor = const Color.fromARGB(255, 242, 242, 245);

  final List<SuggestionModel> _allSuggestions = [
    SuggestionModel(
      id: 'sug001',
      title: 'توسيع مواقف السيارات في وسط البلد',
      description: '...',
      categoryName: 'طرقات وبنية تحتية',
      submittedByName: 'أحمد عبدالله',
      submissionDate: DateTime(2024, 5, 15),
      status: "قيد الاطلاع",
      photoUrl: null,
      attachmentFileNames: ['plan.pdf'],
    ),
    SuggestionModel(
      id: 'sug002',
      title: 'زيادة عدد الحاويات في حي الياسمين',
      description: '...',
      categoryName: 'نظافة عامة وصحة بيئة',
      submittedByName: 'سارة محمود',
      submissionDate: DateTime(2024, 5, 20),
      status: "قيد المعالجة",
      photoUrl: 'image_url.jpg',
    ),
    SuggestionModel(
      id: 'sug003',
      title: 'إنشاء حديقة أطفال في المنطقة الغربية',
      description: '...',
      categoryName: 'خدمات ومرافق مجتمعية',
      submittedByName: 'خالد علي',
      submissionDate: DateTime(2024, 4, 10),
      status: "تم الحل",
    ),
    
  ];

  List<SuggestionModel> _filteredSuggestions = [];
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
    _filteredSuggestions = List.from(
      _allSuggestions,
    ); // مبدئياً عرض كل الاقتراحات
    _selectedStatusFilter = _statusOptions[0]; //  افتراضياً "الكل"
  }

  void _filterSuggestions(String? status) {
    setState(() {
      _selectedStatusFilter = status;
      if (status == null || status == "الكل") {
        _filteredSuggestions = List.from(_allSuggestions);
      } else {
        _filteredSuggestions =
            _allSuggestions.where((sug) => sug.status == status).toList();
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

  Widget _buildSuggestionListItem(SuggestionModel suggestion) {
    final String formattedDate =
        "${suggestion.submissionDate.year}/${suggestion.submissionDate.month}/${suggestion.submissionDate.day}";

    return Card(
      elevation: 1.5,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 12,
        ),
        title: Text(
          suggestion.title,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _primaryColor,
            fontSize: 16,
          ),
          maxLines: 2,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 6),
            Text(
              "${suggestion.categoryName}",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            Text(
              "${suggestion.submittedByName}",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 110,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(suggestion.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                          color: _getStatusColor(suggestion.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(suggestion.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        suggestion.status,
                        style: TextStyle(
                          fontSize: 13,
                          color: _getStatusColor(suggestion.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.circle,
                        color: _getStatusColor(suggestion.status),
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
              builder:
                  (context) =>
                      SuggestionDetailAdminScreen(suggestion: suggestion),
            ),
          );
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
            child: AppBar(
              title: Text(
                "إدارة الاقتراحات",
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
                        _filterSuggestions(newValue);
                      },
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Text(
                  ":فلترة حسب الحالة",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          Expanded(
            child:
                _filteredSuggestions.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedStatusFilter == "الكل" ||
                                    _selectedStatusFilter == null
                                ? 'لا توجد اقتراحات حالياً.'
                                : 'لا توجد اقتراحات بهذه الحالة: "$_selectedStatusFilter"',
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
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      itemCount: _filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        return _buildSuggestionListItem(
                          _filteredSuggestions[index],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
