import 'dart:convert';

class User {
  final int userId;
  String? userType;
  String? name;
  String? userName;
  String? college;
  String? course;
  String? studentNum;
  String? empNo;
  String? position;
  String? homeUnit;
  bool? underMonitoring;

  Map<String, bool>? preExistingDisease = {
    "hypertension": false,
    "diabetes": false,
    "tuberculosis": false,
    "cancer": false,
    "kidneyDisease": false,
    "cardiacDisease": false,
    "autoimmuneDisease": false,
    "asthma": false
  };
  List<String>? allergies = [];

  User(
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
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    if (user.userType == "Student") {
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
