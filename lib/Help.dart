import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _iconColor = const Color.fromARGB(255, 10, 40, 95).withOpacity(0.8);

  // --- بيانات الاتصال (مثال) ---
  final String _supportPhoneNumber = "0782474274"; // رقم هاتف الدعم
  final String _supportEmail = "support@example.gov.jo"; // بريد الدعم

   Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('تعذر فتح الرابط: $urlString')),
         );
      }
     }
  }

   Future<void> _makePhoneCall(String phoneNumber) async {
     final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
     await _launchUrl(launchUri.toString());
   }

  Future<void> _sendEmail(String email) async {
  final Uri launchUri = Uri(scheme: 'mailto', path: email);
   await _launchUrl(launchUri.toString());
   }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20, bottom: 10),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
        ),
      ),
    );
  }

  Widget _buildHelpTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: _iconColor, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)) : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 0.5, indent: 20, endIndent: 20, color: Colors.grey.shade300);
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
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: AppBar(
              title: Text(
                "المساعدة والدعم",
                style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: BackButton(color: _primaryColor, onPressed: () => Navigator.of(context).pop()),
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildSectionTitle("تواصل معنا"),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 1.5,
            shadowColor: Colors.black.withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildHelpTile(
                  icon: Icons.support_agent_outlined,
                  title: "الاتصال بمركز الدعم",
                  subtitle: "الرقم المباشر: $_supportPhoneNumber",
                  onTap: () {
                     _makePhoneCall(_supportPhoneNumber);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري الاتصال برقم الدعم: $_supportPhoneNumber ...')));
                  },
                ),
                _buildDivider(),
                _buildHelpTile(
                  icon: Icons.email_outlined,
                  title: "إرسال بريد إلكتروني للدعم",
                  subtitle: "البريد الإلكتروني: $_supportEmail",
                  onTap: () {
                     _sendEmail(_supportEmail);
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فتح تطبيق الإيميل لإرسال رسالة إلى: $_supportEmail ...')));
                  },
                ),
    
              ],
            ),
          ),
          
          _buildSectionTitle("معلومات قانونية"),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 1.5,
            shadowColor: Colors.black.withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildHelpTile(
                  icon: Icons.privacy_tip_outlined,
                  title: "سياسة الخصوصية",
                  onTap: () {
                    // فتح رابط سياسة الخصوصية
                    //  مثال: _launchUrl("رابط_سياسة_الخصوصية_هنا");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عرض سياسة الخصوصية...')));
                  },
                ),
                _buildDivider(),
                _buildHelpTile(
                  icon: Icons.gavel_outlined,
                  title: "شروط وأحكام الاستخدام",
                  onTap: () {
                    // فتح رابط شروط الاستخدام
                    //  مثال: _launchUrl("رابط_شروط_الاستخدام_هنا");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عرض شروط وأحكام الاستخدام...')));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}