import 'package:flutter/material.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final String _adminName = "اسم الأدمن المسؤول"; //  مثلاً: ندى (مدير النظام)
  final String _adminRole = "مدير النظام";
  final String _adminEmail = "admin.ayat@sawweb.gov.jo";
  final String _adminPhoneNumber = "0790000000";
  final String _adminNumber = "1234";
  final String _authorityName = "أمانة عمان";

  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _appBackgroundColor = const Color.fromARGB(255, 242, 242, 245);
  final Color _cardBackgroundColor = Colors.white;
  final Color _secondaryTextColor = Colors.grey.shade700;

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
             
              Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
              SizedBox(height: 3,),
               Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15, color: _secondaryTextColor),
                ),
                SizedBox(height: 10,)
            ],
          ),

          const SizedBox(width: 13),
          Icon(icon, color: _primaryColor, size: 22),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
        color: Colors.grey.shade400,
      ), // سهم على اليسار
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        icon,
        color: _primaryColor,
        size: 26,
      ), // الأيقونة على اليمين
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBackgroundColor,
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
              leading:
                  Navigator.canPop(context)
                      ? BackButton(color: _primaryColor)
                      : null,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
            decoration: BoxDecoration(color: _primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // لليمين
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        _adminName,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _adminRole,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 45,
                    color: _primaryColor.withOpacity(0.9),
                  ) /*: null*/,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 1.5,
              shadowColor: Colors.black.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: _cardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "المعلومات الأساسية",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const Divider(height: 24, thickness: 0.5),
                    _buildInfoRow(
                      Icons.card_membership,
                      "يعمل لجهة",
                      _authorityName,
                    ),
                    _buildInfoRow(Icons.numbers, "الرقم الوظيفي", _adminNumber),
                    _buildInfoRow(
                      Icons.email_outlined,
                      "البريد الإلكتروني",
                      _adminEmail,
                    ),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      "رقم الهاتف",
                      _adminPhoneNumber,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- قسم الإجراءات ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 1.5,
              shadowColor: Colors.black.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: _cardBackgroundColor,
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.edit_note_outlined,
                    title: "تعديل الملف الشخصي",
                    onTap: () {},
                  ),
                  Divider(
                    height: 0.5,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey.shade200,
                  ),
                  _buildActionTile(
                    icon: Icons.lock_outline_rounded,
                    title: "تغيير كلمة المرور",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: TextButton.icon(
              icon: Icon(Icons.logout_rounded, color: Colors.red.shade700),
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
                      content: const Text(
                        "هل أنت متأكد أنك تريد تسجيل الخروج من حساب الأدمن؟",
                        textAlign: TextAlign.right,
                      ),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            "إلغاء",
                            style: TextStyle(color: _secondaryTextColor),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text(
                            "تسجيل الخروج",
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // إغلاق الحوار
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم تسجيل الخروج (محاكاة)'),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
