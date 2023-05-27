import 'dart:convert';

class MonitorLog {
  final String? status;
  final String studentNum;
  final String userId;
  final DateTime date;
  final String location;

  MonitorLog({
    this.status,
    required this.studentNum,
    required this.userId,
    required this.date,
    required this.location,
  });

  factory MonitorLog.fromJson(Map<String, dynamic> json) {
    return MonitorLog(
        status: json['status'],
        studentNum: json['studentNum'],
        userId: json['userId'],
        date: json['date'].toDate(),
        location: json['location']);
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
