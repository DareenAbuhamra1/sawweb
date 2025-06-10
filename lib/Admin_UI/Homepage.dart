import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sawweb/Admin_UI/emolyeemange.dart';
import 'package:sawweb/Admin_UI/model/ChartData.dart';
import 'package:sawweb/Admin_UI/profilemange.dart';
import 'package:sawweb/Admin_UI/reportMange.dart';
import 'package:sawweb/Admin_UI/suggestionManger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final String _adminName = "آيات"; // مثال، سيتم جلبه لاحقاً
  final String _adminEmail = 'ayat@admin.gov.jo'; // مثال
  String _selectedPageTitle = "لوحة التحكم الرئيسية";
  final List<ChartData> chartData = [
    ChartData("الشكاوى الجديدة", 15, const Color.fromARGB(255, 224, 161, 98)),
    ChartData("الاقتراحات الجديدة", 8, const Color.fromARGB(255, 157, 202, 242)),
    ChartData("شكاوى تم حلها", 120, const Color.fromARGB(255, 138, 225, 142)),
  ];

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? _primaryColor : Colors.black87,
            ),
          ),
          SizedBox(width: 10), // مسافة بين النص والأيقونة
           Icon(
        icon,
        color: isSelected ? _primaryColor : Colors.grey.shade700,
        size: 26,
      ),
        ],
      ),
      
      tileColor: isSelected ? _primaryColor.withOpacity(0.1) : null,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
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
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: AppBar(
              
              title: Text(
                _selectedPageTitle,
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: _primaryColor,
              ), // لون أيقونة القائمة الجانبية
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: _primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليمين
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 35,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _adminName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _adminEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard_outlined,
              title: "لوحة التحكم الرئيسية",
              isSelected: _selectedPageTitle == "لوحة التحكم الرئيسية",
              onTap: () {
                setState(() {
                  _selectedPageTitle = "لوحة التحكم الرئيسية";
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('عرض لوحة التحكم الرئيسية...')),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.list_alt_outlined,
              title: "إدارة الشكاوى",
              isSelected: _selectedPageTitle == "إدارة الشكاوى",
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintsManagementScreen(),
                    ),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.lightbulb_outline,
              title: "إدارة الاقتراحات",
              isSelected: _selectedPageTitle == "إدارة الاقتراحات",
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuggestionsManagementScreen(),
                    ),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.people_outline,
              title: "إدارة حسابات الموظفين",
              isSelected: _selectedPageTitle == "إدارة حسابات الموظفين",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeListScreen()),
                );
              },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildDrawerItem(
              icon: Icons.person_outline,
              title: "ملفي الشخصي",
              isSelected: _selectedPageTitle == "ملفي الشخصي",
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AdminProfileScreen()));},
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              title: "تسجيل الخروج",
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, 'signin_emp', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildDashboardBody(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2), // تأثير الظل
                    ),
                  ],
                ),
                child: Center( 
                  child: Container(
                    child: SfCircularChart(
                      
                      legend: Legend(
                        isResponsive: true,
                        isVisible: true,
                        position: LegendPosition.right,
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(221, 92, 88, 88),
                        ),
                      ),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: chartData,
                        
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          
                        
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            "!أهلاً بك، $_adminName",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "نظرة عامة على النظام",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2, // عمودين في الشبكة
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2, // نسبة العرض إلى الارتفاع للبطاقات
            children: <Widget>[
              _buildDashboardCard(
                icon: Icons.error_outline,
                title: "الشكاوى الجديدة",
                value: "15", // من قاعدة البيانات
                color: Colors.orange.shade700,
              ),
              _buildDashboardCard(
                icon: Icons.lightbulb_outline,
                title: "الاقتراحات الجديدة",
                value: "8", // مثال
                color: Colors.blue.shade600,
              ),
              _buildDashboardCard(
                icon: Icons.check_circle_outline,
                title: "شكاوى تم حلها",
                value: "120", // مثال
                color: Colors.green.shade600,
              ),
              _buildDashboardCard(
                icon: Icons.people_alt_outlined,
                title: "إجمالي الموظفين",
                value: "45", // مثال
                color: Colors.deepPurple.shade400,
              ),
            ],
            
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: <Widget>[
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 5),
              Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
