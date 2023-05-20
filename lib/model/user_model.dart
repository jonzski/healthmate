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

  User({
    required this.userId,
    required this.userType,
    required this.name,
    this.college,
    this.course,
    this.studentNum,
    this.empNo,
    this.position,
    this.homeUnit,
  });

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
        homeUnit: json['homeUnit']);
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
      };
    }
    return ({
      'userId': user.userId,
      'userType': user.userType,
      'empNo': user.empNo,
      'position': user.position,
      'homeUnit': user.homeUnit,
    });
  }
}
