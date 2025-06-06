import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sawweb/Citizen_UI/Help.dart';
import 'package:sawweb/Citizen_UI/changePassword.dart';
import 'package:sawweb/Citizen_UI/notificationSetting.dart';
import 'package:sawweb/Citizen_UI/updateprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // بيانات المستخدم سيتم جلبها من قاعدة البيانات
  String _userName = '';
  String _userNationalId = '';
  String _email = '';
  String _phoneNumber = '';
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _secondaryTextColor = Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();
      if (userDoc.docs.isNotEmpty) {
        final data = userDoc.docs.first.data();
        setState(() {
          _userName =
              '${data['first_name']} ${data['second_name']} ${data['middle_name']} ${data['last_name']}';
          _userNationalId = data['national_id'] ?? "";
          _email = data['email'] ?? "";
          _phoneNumber = data['phone_number'] ?? "";
        });
        print("Profile loaded for: $_userName");
      } else {
        print("User document not found for email: ${user.email}");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  Future<void> signOutAndRedirect() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('signin', (route) => false);
    }
  }

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
            child: Icon(
              Icons.person,
              size: 60,
              color: _primaryColor.withOpacity(0.8),
            ),
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
                onTap: () {},
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: Icons.phone_outlined,
                title: "رقم الهاتف",
                subtitle: _phoneNumber,
                onTap: () {},
              ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        email: _email,
                        phone: _phoneNumber,
                        name:_userName,
                      ),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.lock_outline,
                title: "تغيير كلمة المرور",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                  ); // الانتقال إلى صفحة تغيير كلمة المرور
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.notifications_none_outlined,
                title: "إعدادات الإشعارات",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationSettingsScreen(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.star_rate_outlined,
                title: "قيّم صوِّب",
                onTap: () {
                  String url;
                  if (Platform.isIOS) {
                    url = 'https://apps.apple.com/app/id6479522329';
                  } else {
                    url = 'https://play.google.com/store/apps/details?id=com.sawweb.sawweb';
                  }
                  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.help_outline_outlined,
                title: "المساعدة والدعم",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HelpAndSupportScreen()),
                  );
                },
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
        leading: Icon(icon, color: _primaryColor, size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: _primaryColor,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: _secondaryTextColor),
        ),
        onTap: onTap,
        dense: true,
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
        leading: Icon(icon, color: _primaryColor, size: 26),
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
                  style: TextStyle(color: _primaryColor),
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
                      style: TextStyle(color: _secondaryTextColor),
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
                      Navigator.of(context).pop(); // Close dialog
                      await signOutAndRedirect();
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
      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
    );
  }
}
