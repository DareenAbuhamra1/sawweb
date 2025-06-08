  class ReportModel {
  final String id;
  final String title;
  final String type; 
  final String? issue; 
  final String authorityName; 
  final DateTime? problemDate; 
  final String description;
  final DateTime submissionTimestamp; 
  String status; 
  final String? submittedByName;
  final String? photoUrl;
  final List<String>? attachmentFileNames;

  ReportModel({
    required this.id,
    required this.title,
    required this.type,
    this.issue,
    required this.authorityName,
    this.problemDate,
    required this.description,
    required this.submissionTimestamp,
    required this.status,
    this.submittedByName,
    this.photoUrl,
    this.attachmentFileNames,
  });
}
