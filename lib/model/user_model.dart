import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

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
  bool? underQuarantine;
  Map<String, bool>? preExistingDisease;
  List<String>? allergies;

  UserDetails(
      {required this.userId,
      required this.userType,
      required this.name,
      this.userName,
      this.college,
      this.course,
      this.studentNum,
      this.empNo,
      this.position,
      this.homeUnit,
      this.preExistingDisease,
      this.allergies,
      this.underQuarantine,
      this.underMonitoring});

  // Factory constructor to instantiate object from json format
  factory UserDetails.fromJson(Map<String, dynamic> json, int userType) {
    dynamic linkedMap = json['preExistingDisease'];
    dynamic allergiesList = json['allergies'];

    // Convert dynamic list to List<String>
    List<String> allergiesStringList =
        List<String>.from(allergiesList.map((item) => item.toString()));

    Map<String, bool> convertedMap = {};
    linkedMap.forEach((key, value) {
      if (value is bool) {
        convertedMap[key] = value;
      }
    });

    if (userType == 0) {
      return UserDetails(
          userId: json['userId'],
          userType: json['userType'],
          userName: json['userName'],
          name: json['name'],
          college: json['college'],
          course: json['course'],
          studentNum: json['studentNum'],
          preExistingDisease: convertedMap,
          allergies: allergiesStringList,
          underMonitoring: json['underMonitoring'],
          underQuarantine: json['underQuarantine']);
    } else {
      return UserDetails(
          userId: json['userId'],
          userType: json['userType'],
          name: json['name'],
          empNo: json['empNo'],
          position: json['position'],
          homeUnit: json['homeUnit'],
          preExistingDisease: convertedMap,
          allergies: allergiesStringList,
          underMonitoring: json['underMonitoring'],
          underQuarantine: json['underQuarantine']);
    }
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
        'underMonitoring': user.underMonitoring,
        'underQuarantine': user.underQuarantine
      };
    }
    return ({
      'userId': user.userId,
      'userType': user.userType,
      'name': user.name,
      'empNo': user.empNo,
      'position': user.position,
      'homeUnit': user.homeUnit,
      'preExistingDisease': user.preExistingDisease,
      'allergies': user.allergies,
      'underMonitoring': user.underMonitoring,
      'underQuarantine': user.underQuarantine
    });
  }
}
