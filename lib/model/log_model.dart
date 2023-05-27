import 'dart:convert';

class MonitorLog {
  String? status;
  String? studentNum;
  final String userId;
  final DateTime date;
  String? location;
  final String logId;
  String? studentId;

  MonitorLog({
    this.status,
    this.studentNum,
    required this.userId,
    required this.date,
    this.location,
    required this.logId,
    this.studentId,
  });

  factory MonitorLog.fromJson(Map<String, dynamic> json) {
    return MonitorLog(
      status: json['status'],
      studentNum: json['studentNum'],
      userId: json['userId'],
      date: json['date'].toDate(),
      location: json['location'],
      logId: json['logId'],
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
      "userId": log.userId,
      "date": log.date,
      "location": log.location
    };
  }
}
