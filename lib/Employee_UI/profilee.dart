import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sawweb/Employee_UI/notif_sett.dart';
import 'package:sawweb/Employee_UI/update.dart';

class Profilee extends StatelessWidget {
  const Profilee({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F7),
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          shadowColor: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: ClipRRect(
            child: AppBar(
              title: Text(
                "الملف الشخصي",
                style: TextStyle(
                  color: const Color.fromARGB(255, 10, 40, 95),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color:const Color.fromARGB(255, 10, 40, 95),
              ), // لون أيقونة الرجوع
            ),
          ),
        ),
      ),
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            _buildHeader(),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildActionsCard(context),
            const SizedBox(height: 30),
            _buildLogoutButton(context),
            const SizedBox(height: 20),
            _buildAppVersion(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
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
                icon: Icons.badge_outlined,
                title: "الرقم الوظيفي",
                subtitle: 'EMP-TR-001',
                onTap: () {},
              ),
              _buildInfoTile(
                icon: Icons.email_outlined,
                title: "البريد الإلكتروني",
                subtitle: 'ahmadAli@employee.gov.jo',
                onTap: () {},
              ),
              _buildInfoTile(
                icon: Icons.phone_outlined,
                title: "رقم الهاتف",
                subtitle: '0791112233',
                onTap: () {},
              ),
             
            ],
          ),
        ),
      ),
    );
  }
 Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 10, 40, 95), size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 10, 40, 95),
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        onTap: onTap,
        dense: true,
      ),
    );
  }

Widget _buildActionsCard(BuildContext context) {
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>edit(email: 'ahmadAli@employee.gov.jo', phone: '0791112233', name: 'أحمد خالد محمود علي')));
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.lock_outline,
                title: "تغيير كلمة المرور",
                onTap: () {
                  Navigator.pushNamed(context, 'changePassword');
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.notifications_none_outlined,
                title: "إعدادات الإشعارات",
                onTap: () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) =>NotificationSettings()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildHeader() {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 4,
        ),
      ],
    ),
    child: Column(
      children: const [
        CircleAvatar(
            radius: 55,
            backgroundColor: const Color.fromARGB(64, 182, 180, 180),
            child: Icon(
              Icons.person,
              size: 60,
              color: const Color.fromARGB(255, 10, 40, 95),
            ),
          ),
        SizedBox(height: 15),
        Text(
          'أحمد خالد محمود علي',
          style: TextStyle(
            color: Color(0xFF0A285F),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          '5101012345',
          style: TextStyle(
            color: Color(0xFF0A285F),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildActionTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 10, 40, 95), size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }

Widget _buildDivider() {
  return Divider(
    height: 0.5,
    indent: 16,
    endIndent: 16,
    color: Colors.grey.shade300,
  );
}

Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextButton.icon(
        icon: Icon(Icons.logout, color: Colors.red.shade700),
        label: Text(
          "تسجيل الخروج",
          style: TextStyle(
            fontSize: 16,
            color: Colors.red.shade700,
            fontWeight: FontWeight.w600,
          ),
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "تسجيل الخروج",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: const Color.fromARGB(255, 10, 40, 95)),
                ),
                content: Text(
                  "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                  textAlign: TextAlign.right,
                ),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "إلغاء",
                      style: TextStyle(color: const Color.fromARGB(255, 182, 180, 180)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      "تسجيل الخروج",
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, 'signin_emp', (route) => false);
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
    "إصدار التطبيق 1.0.0 (تجريبي)",
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0A285F)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A285F)), textDirection: TextDirection.rtl),
              Text(value, style: const TextStyle(fontSize: 14), textDirection: TextDirection.rtl),
            ],
          ),
        ),
      ],
    );
  }
}