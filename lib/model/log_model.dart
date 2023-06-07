import 'dart:convert';

class MonitorLog {
  String? status;
  String? studentNum;
  final String uid;
  final DateTime date;
  String? location;
  final String logId;
  String studentId;
  String studentName;

  MonitorLog({
    this.status,
    this.studentNum,
    required this.uid,
    required this.date,
    this.location,
    required this.logId,
    required this.studentId,
    required this.studentName,
  });

  factory MonitorLog.fromJson(Map<String, dynamic> json) {
    return MonitorLog(
      status: json['status'],
      studentNum: json['studentNum'],
      uid: json['uid'],
      date: json['date'].toDate(),
      location: json['location'],
      logId: json['logId'],
      studentId: json['studentId'],
      studentName: json['studentName'],
    );
  }

  static List<MonitorLog> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<MonitorLog>((dynamic d) => MonitorLog.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(MonitorLog log) {
    return {
      'status': log.status,
      "studentNum": log.studentNum,
      "uid": log.uid,
      "date": log.date,
      "location": log.location,
      "studentId": log.studentId,
      "studentName": log.studentName,
    };
  }
}
