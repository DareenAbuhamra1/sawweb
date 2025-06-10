import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _masterNotificationsEnabled = true; // مفتاح رئيسي لكل الإشعارات
  bool _complaintStatusUpdatesEnabled = true;
  bool _suggestionStatusUpdatesEnabled = true;

  final Color _primaryColor = const Color.fromARGB(255, 10, 40, 95);
  final Color _secondaryTextColor = Colors.grey.shade600;

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isMasterSwitch = false,
    bool isImportant = false, // لتمييز الإشعارات الهامة مثل الأمنية
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Opacity(
        opacity: (isMasterSwitch || _masterNotificationsEnabled) ? 1.0 : 0.5, // تعطيل بصري إذا كان المفتاح الرئيسي مغلق
        child: SwitchListTile(
          activeColor: _primaryColor,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: (isMasterSwitch || _masterNotificationsEnabled) ? Colors.black87 : Colors.grey.shade600,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: (isMasterSwitch || _masterNotificationsEnabled) ? _secondaryTextColor : Colors.grey.shade500,
                  ),
                )
              : null,
          value: value,
          onChanged: (isMasterSwitch || _masterNotificationsEnabled) ? onChanged : null, // تعطيل التغيير إذا كان المفتاح الرئيسي مغلق
          secondary: isImportant
              ? Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 26)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 245),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Material(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: AppBar(
              automaticallyImplyLeading: false, // لمنع الزر التلقائي
              backgroundColor: Colors.white,
              elevation: 0,
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'إعدادات الاشعارات',
                      style: TextStyle(
                        color: Color.fromARGB(255, 10, 40, 95),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 10, 40, 95)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10), // مسافة قبل أول عنصر
          _buildSwitchTile(
            title: "تفعيل جميع الإشعارات",
            subtitle: "التحكم في استقبال جميع أنواع الإشعارات من التطبيق.",
            value: _masterNotificationsEnabled,
            onChanged: (bool newValue) {
              setState(() {
                _masterNotificationsEnabled = newValue;
                if (!newValue) {
                  _complaintStatusUpdatesEnabled = false;
                  _suggestionStatusUpdatesEnabled = false;
                } else {
                   _complaintStatusUpdatesEnabled = true;
                   _suggestionStatusUpdatesEnabled = true;
                }
              });
            },
            isMasterSwitch: true,
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),

          Padding(
            padding: const EdgeInsets.only(top:16.0, right: 20, left: 20, bottom: 8),
            child: Text(
              "الإشعارات التفصيلية",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _primaryColor.withOpacity(0.8)),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.05),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildSwitchTile(
                  title: "تحديثات الشكاوى",
                  subtitle: "تلقي إشعارات حول الشكاوي الموكلة إليك.",
                  value: _complaintStatusUpdatesEnabled,
                  onChanged: (bool newValue) {
                    setState(() {
                      _complaintStatusUpdatesEnabled = newValue;
                    });
                  },
                ),
                const Divider(height: 0.5, indent: 20, endIndent: 20),
                _buildSwitchTile(
                  title: "تحديثات الاقتراحات",
                  subtitle: "تلقي إشعارات حول الاقتراحات الموكلة إليك.",
                  value: _suggestionStatusUpdatesEnabled,
                  onChanged: (bool newValue) {
                    setState(() {
                      _suggestionStatusUpdatesEnabled = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20.0),
             child: Text(
                "ملاحظة: يتم حفظ التغييرات تلقائياً عند تبديل المفاتيح.",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
           ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}