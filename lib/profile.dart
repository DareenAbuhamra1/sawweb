import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // --- بيانات المستخدم (مثال، سيتم جلبها من قاعدة البيانات لاحقاً) ---
  final String _userName = "دارين أبو حمرة"; // اسم المستخدم
  final String _userNationalId = "199XXXXXXX1"; // الرقم الوطني (مثال)
  final String _email = "dareen@gmail.com";
  final String _phoneNumber = "079XXXXXXX";
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _secondaryTextColor = Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 245), // لون خلفية فاتح
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          shadowColor: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: ClipRRect(
            child: AppBar(
              title: Text(
                "الملف الشخصي",
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: _primaryColor), // لون أيقونة الرجوع
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(0), // إزالة الحشو الافتراضي للـ ListView
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 24),
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildActionsCard(),
          const SizedBox(height: 30),
          _buildLogoutButton(context),
          const SizedBox(height: 20),
          _buildAppVersion(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
       borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 55,
            backgroundColor: const Color.fromARGB(64, 182, 180, 180),
            child:
                Icon(
              Icons.person,
              size: 60,
              color: _primaryColor.withOpacity(0.8),
            )
          ),
          const SizedBox(height: 15),
          Text(
            _userName,
            style: const TextStyle(
              color: Color.fromARGB(255, 10, 40, 95),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),

          Text(
            " $_userNationalId",
            style: TextStyle(
              
              color: Color.fromARGB(255, 10, 40, 95),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              _buildInfoTile(
                icon: Icons.email_outlined,
                title: "البريد الإلكتروني",
                subtitle: _email,
                onTap: () { 
                },
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: Icons.phone_outlined,
                title: "رقم الهاتف",
                subtitle: _phoneNumber,
                onTap: () {

                 },
              ),
              // يمكنك إضافة المزيد من المعلومات هنا مثل العنوان
              // _buildDivider(),
              // _buildInfoTile(
              //   icon: Icons.location_on_outlined,
              //   title: "العنوان",
              //   subtitle: "شارع الملكة رانيا، عمان، الأردن", // مثال
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              _buildActionTile(
                icon: Icons.edit_outlined,
                title: "تعديل الملف الشخصي",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الانتقال إلى تعديل الملف الشخصي...')));
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.lock_outline,
                title: "تغيير كلمة المرور",
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الانتقال إلى تغيير كلمة المرور...')));
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.notifications_none_outlined,
                title: "إعدادات الإشعارات",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الانتقال إلى إعدادات الإشعارات...')));
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.help_outline_outlined,
                title: "المساعدة والدعم",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الانتقال إلى المساعدة والدعم...')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String title, required String subtitle, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor, size: 26),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: _primaryColor, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 14, color: _secondaryTextColor)),
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor, size: 26),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 0.5, indent: 16, endIndent: 16, color: Colors.grey.shade300);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextButton.icon(
        icon: Icon(Icons.logout, color: Colors.red.shade700),
        label: Text(
          "تسجيل الخروج",
          style: TextStyle(fontSize: 16, color: Colors.red.shade700, fontWeight: FontWeight.w600),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade200),
          ),
          backgroundColor: Colors.red.withOpacity(0.05),
        ),
        onPressed: () {
          //  منطق تسجيل الخروج
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("تسجيل الخروج", textAlign: TextAlign.right, style: TextStyle(color: _primaryColor)),
                content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟", textAlign: TextAlign.right),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: <Widget>[
                  TextButton(
                    child: Text("إلغاء", style: TextStyle(color: _secondaryTextColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("تسجيل الخروج", style: TextStyle(color: Colors.red.shade700)),
                    onPressed: () {
                      Navigator.of(context).pop(); // إغلاق الحوار
                      // تنفيذ عملية تسجيل الخروج الفعلية
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج بنجاح (محاكاة)')));
                      // Navigator.of(context).pushReplacementNamed('/login'); // مثال للانتقال لشاشة تسجيل الدخول
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

   Widget _buildAppVersion() {
    return Text(
      "إصدار التطبيق 1.0.0 (تجريبي)", // يمكنك وضع رقم الإصدار الفعلي هنا
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 12,
      ),
    );
  }
}