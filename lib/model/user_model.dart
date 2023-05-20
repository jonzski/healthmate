import 'dart:convert';

// UserType 0-User, 1-monitor, 2-admin
class UserDetails {
  final String? userId;
  int userType;
  String name;
  String? userName;
  String? college;
  String? course;
  String? studentNum;
  String? empNo;
  String? position;
  String? homeUnit;
  bool? underMonitoring;
  Map<String, bool>? preExistingDisease;
  List<String>? allergies;

  UserDetails(
      {required this.userId,
      required this.userType,
      required this.name,
      this.college,
      this.course,
      this.studentNum,
      this.empNo,
      this.position,
      this.homeUnit,
      this.preExistingDisease,
      this.allergies,
      this.underMonitoring});

  // Factory constructor to instantiate object from json format
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        userId: json['userId'],
        userType: json['userType'],
        name: json['name'],
        college: json['college'],
        course: json['course'],
        studentNum: json['studentNum'],
        empNo: json['empNo'],
        position: json['position'],
        homeUnit: json['homeUnit'],
        preExistingDisease: json['preExistingDisease'],
        allergies: json['allergies'],
        underMonitoring: json['underMonitoring']);
  }

  static List<UserDetails> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<UserDetails>((dynamic d) => UserDetails.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson(UserDetails user) {
    if (user.userType == 0) {
      return {
        'userId': user.userId,
        'userType': user.userType,
        'userName': user.userName,
        'name': user.name,
        'college': user.college,
        'course': user.course,
        'studentNum': user.studentNum,
        'preExistingDisease': user.preExistingDisease,
        'allergies': user.allergies,
        'underMonitoring': user.underMonitoring
      };
    }
    return ({
      'userId': user.userId,
      'userType': user.userType,
      'empNo': user.empNo,
      'position': user.position,
      'homeUnit': user.homeUnit,
      'preExistingDisease': user.preExistingDisease,
      'allergies': user.allergies,
      'underMonitoring': user.underMonitoring
    });
  }
}
