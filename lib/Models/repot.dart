class GeoPoint {
  final double latitude;
  final double longitude;
  GeoPoint(this.latitude, this.longitude);
  Map<String, double> toJson() => {'latitude': latitude, 'longitude': longitude};
}
class FieldValue {
  FieldValue._(); // private constructor
  static FieldValue serverTimestamp() => FieldValue._(); // placeholder
}
class Authority {
  final String id;
  final String name;

  Authority({required this.id, required this.name});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Authority&&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class IssueSub {
  final String id; // يمكن أن يكون اسم المشكلة نفسه إذا لم يكن هناك ID خاص
  final String name;
  // final String? specificAuthorityId; // إذا كانت المشكلة الفرعية لها جهة مسؤولة مختلفة عن الفئة

  IssueSub({required this.id, required this.name});
   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueSub &&
          runtimeType == other.runtimeType &&
          id == other.id && name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class Category {
  final String id; // يمكن أن يكون اسم الفئة نفسه
  final String name;
  final List<IssueSub> issues;
  final String defaultAuthorityId; // ID الجهة المسؤولة الافتراضية لهذه الفئة

  Category({
    required this.id,
    required this.name,
    required this.issues,
    required this.defaultAuthorityId,
  });

   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// --- نموذج الشكوى/ الذي سيتم إرساله إلى Firebase ---
class Report {
  String? id; // Firestore document ID
  final String title;
  final String type; // اسم الفئة (CategoryModel.name)
  final String? issue; // اسم المشكلة الفرعية (IssueSubModel.name)
  final Authority authority; // الجهة المسؤولة (يمكن استخدام AuthorityModel)
  final DateTime? problemDate; // تاريخ المشكلة الفعلي
  final String description;
  final String? photoUrl; // رابط الصورة من Firebase Storage
  final List<String>? attachmentUrls; // قائمة روابط المرفقات
  final GeoPoint? location; // استخدام GeoPoint إذا كانت Firestore هي الوجهة
  final FieldValue timestamp; // FieldValue.serverTimestamp()
  String status; // مثل: "جديدة", "قيد المعالجة", "تم الحل"
  int? rate; // تقييم الخدمة بعد الحل (اختياري)

  Report({
    this.id,
    required this.title,
    required this.type,
    this.issue,
    required this.authority,
    this.problemDate,
    required this.description,
    this.photoUrl,
    this.attachmentUrls,
    this.location,
    required this.timestamp,
    this.status = "جديدة", // قيمة افتراضية للحالة
    this.rate,
  });

  // --- دالة لتحويل النموذج إلى JSON لإرساله لـ Firebase (كـ تعليق) ---
  // Map<String, dynamic> toJson() {
  //   return {
  //     'title': title,
  //     'type': type,
  //     'issue': issue,
  //     'authorityId': authorityId,
  //     'authorityName': authorityName,
  //     'problemDate': problemDate?.toIso8601String(),
  //     'description': description,
  //     'photoUrl': photoUrl,
  //     'attachmentUrls': attachmentUrls,
  //     'location': location != null ? GeoPoint(location!.latitude, location!.longitude) : null,
  //     'timestamp': timestamp, // FieldValue.serverTimestamp()
  //     'status': status,
  //     'rate': rate,
  //   };
  // }
  // --- نهاية دالة toJson ---
}