
class EmployeeModel {
  final String id;
  final String nationalId;
  final String employeeId;
  final String fullName;
  final String phoneNumber;
  final String department; // القسم
  final String responsibility; // المسؤولية أو التخصص
  bool isActive;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  EmployeeModel({
    required this.id,
    required this.nationalId,
    required this.employeeId,
    required this.fullName,
    required this.phoneNumber,
    required this.department,
    required this.responsibility,
    this.isActive = true,
  });
}
class AdminAddedNote {
  final String text;
  final DateTime timestamp;
  final String adminName;
  AdminAddedNote({required this.text, required this.timestamp, required this.adminName});
}
