import 'package:flutter/material.dart';
import 'package:sawweb/Admin_UI/employeeEditScreen.dart';
import 'package:sawweb/Admin_UI/model/employee.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _appBackgroundColor = const Color.fromARGB(255, 242, 242, 245);
  List<EmployeeModel> _employees = [
    EmployeeModel(id: 'emp001', nationalId: '1990101012345', employeeId: 'EMP-TR-001', fullName: 'أحمد خالد محمود علي', phoneNumber: '0791112233', department: 'صيانة الطرق', responsibility: 'إصلاح الحفر ومعالجة تشققات الأسفلت', isActive: true),
    EmployeeModel(id: 'emp002', nationalId: '1985051567890', employeeId: 'EMP-WM-001', fullName: 'فاطمة سعيد ياسين القاسم', phoneNumber: '0782223344', department: 'شبكات المياه والصرف', responsibility: 'متابعة تسربات المياه وصيانة خطوط الصرف', isActive: true),
    EmployeeModel(id: 'emp003', nationalId: '1992082011223', employeeId: 'EMP-EL-001', fullName: 'يوسف إبراهيم حسن مراد', phoneNumber: '0773334455', department: 'الإنارة العامة', responsibility: 'صيانة أعمدة الإنارة واستبدال المصابيح', isActive: false),
    EmployeeModel(id: 'emp004', nationalId: '1988020255667', employeeId: 'EMP-CL-001', fullName: 'سارة عمر عبد الرحمن حمدان', phoneNumber: '0794445566', department: 'النظافة والبيئة', responsibility: 'الإشراف على فرق النظافة ومتابعة الشكاوى البيئية', isActive: true),
    EmployeeModel(id: 'emp005', nationalId: '1995113088990', employeeId: 'EMP-AG-001', fullName: 'محمد علي حسين الشريف', phoneNumber: '0785556677', department: 'الزراعة والحدائق', responsibility: 'صيانة الحدائق العامة وتقليم الأشجار', isActive: true),
    EmployeeModel(id: 'emp006', nationalId: '1993071023456', employeeId: 'EMP-TR-002', fullName: 'ليلى ناصر جمال موسى', phoneNumber: '0776667788', department: 'صيانة الطرق', responsibility: 'متابعة سلامة الإشارات الضوئية والمرورية', isActive: true),
    EmployeeModel(id: 'emp007', nationalId: '1980012578901', employeeId: 'EMP-WM-002', fullName: 'حسن عبدالله أحمد إسماعيل', phoneNumber: '0797778899', department: 'شبكات المياه والصرف', responsibility: 'فحص جودة المياه ومعالجة شكاوى التلوث', isActive: true),
    EmployeeModel(id: 'emp008', nationalId: '1998041834567', employeeId: 'EMP-SC-001', fullName: 'نور سامي كمال إبراهيم', phoneNumber: '0788889900', department: 'السلامة العامة', responsibility: 'متابعة مخالفات البناء واللوحات الإعلانية', isActive: false),
    EmployeeModel(id: 'emp009', nationalId: '1991090545678', employeeId: 'EMP-EL-002', fullName: 'عمر محمود صالح خليل', phoneNumber: '0779990011', department: 'الإنارة العامة', responsibility: 'الاستجابة لطلبات الإنارة الجديدة', isActive: true),
    EmployeeModel(id: 'emp010', nationalId: '1987031267890', employeeId: 'EMP-CL-002', fullName: 'ريم خالد يوسف عوض', phoneNumber: '0790001122', department: 'النظافة والبيئة', responsibility: 'مكافحة الحشرات والقوارض في المناطق العامة', isActive: true),
  ];

  void _navigateToAddEmployeeScreen() {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditEmployeeScreen(employee: null)), // تمرير null لأنه إضافة جديد
    ).then((newEmployee) {
      if (newEmployee != null && newEmployee is EmployeeModel) {
        setState(() {
          _employees.add(newEmployee);
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تمت إضافة الموظف ${newEmployee.fullName} بنجاح')),
          );
        });
      }
    });
  }

  void _deleteEmployee(EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد الحذف", textAlign: TextAlign.right, style: TextStyle(color: _primaryColor)),
          content: Text("هل أنت متأكد أنك تريد حذف حساب الموظف: ${employee.fullName}؟\nلا يمكن التراجع عن هذا الإجراء.", textAlign: TextAlign.right),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              child: Text("إلغاء", style: TextStyle(color: Colors.grey.shade700)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1)),
              child: const Text("حذف", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _employees.removeWhere((emp) => emp.id == employee.id);
                });
                Navigator.of(context).pop(); // إغلاق الحوار
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف حساب الموظف: ${employee.fullName}')),
                );
              },
            ),
          ],
        );
      },
    );
  }
 
  Widget _buildEmployeeListItem(EmployeeModel employee) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          employee.fullName,
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 4),
            Text("${employee.employeeId}", textAlign: TextAlign.right, style: TextStyle(fontSize: 13, color: const Color.fromARGB(255, 126, 150, 201))),
            Text("القــــــــــسم: ${employee.department}", textAlign: TextAlign.right, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            Text("المسؤولية: ${employee.responsibility}", textAlign: TextAlign.right, style: TextStyle(fontSize: 13, color: Colors.grey.shade700 , )),
             Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: employee.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
               child: Text(
                employee.isActive ? "الحالة: نشط" : "الحالة: غير نشط",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13, color: employee.isActive ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.w500),
                ),
             ),
          ],
        ),
        leading: PopupMenuButton<String>(
          color: Colors.white, // استخدام PopupMenuButton لإجراءات متعددة
          onSelected: (value) {
            if (value == 'edit') {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditEmployeeScreen(employee: employee)),
              ).then((updatedEmployee) {
                if (updatedEmployee != null && updatedEmployee is EmployeeModel) {
                  setState(() {
                    final index = _employees.indexWhere((e) => e.id == updatedEmployee.id);
                    if (index != -1) {
                      _employees[index] = updatedEmployee;
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم تحديث بيانات الموظف ${updatedEmployee.fullName} بنجاح')),
                      );
                    }
                  });
                }
              });
            } else if (value == 'delete') {
              _deleteEmployee(employee);
            } else if (value == 'toggle_status') {
               setState(() {
                employee.isActive = !employee.isActive;
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم تغيير حالة الموظف ${employee.fullName} إلى: ${employee.isActive ? "نشط" : "غير نشط"}')),
                  );
              });
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // لـ RTL
                children: [
                  Text('تعديل البيانات'),
                  SizedBox(width: 8),
                  Icon(Icons.edit_outlined, size: 20),
                ],
              ),
            ),
             PopupMenuItem<String>( // تفعيل/تعطيل الحساب
              value: 'toggle_status',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(employee.isActive ? 'تعطيل الحساب' : 'تفعيل الحساب'),
                  SizedBox(width: 8),
                  Icon(employee.isActive ? Icons.toggle_off_outlined : Icons.toggle_on_outlined, size: 20),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('حذف الحساب', style: TextStyle(color: Colors.red)),
                  SizedBox(width: 8),
                  Icon(Icons.delete_outline, color: Colors.red, size: 20),
                ],
              ),
            ),
          ],
          icon: Icon(Icons.more_vert, color: Colors.grey.shade600), // أيقونة النقاط الثلاث
        ),
        isThreeLine: true, // للسماح بعرض الأسطر المتعددة في subtitle بشكل جيد
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBackgroundColor,
      appBar: PreferredSize(
         preferredSize: const Size.fromHeight(75),
        child: Material(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: AppBar(
              title: Text(
                "إدارة حسابات الموظفين",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 10, 40, 95),
              elevation: 0,
              leading: Navigator.canPop(context) ? BackButton(color: Colors.white) : null,
            ),
          ),
        ),
      ),
      body: _employees.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline_rounded, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'لا يوجد موظفون حالياً.',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                   const SizedBox(height: 8),
                  Text(
                    'يمكنك إضافة موظف جديد باستخدام الزر أدناه.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                return _buildEmployeeListItem(_employees[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddEmployeeScreen,
        label: const Text("إضافة موظف جديد"),
        icon: const Icon(Icons.add),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

