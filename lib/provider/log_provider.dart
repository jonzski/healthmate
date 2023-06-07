import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_log_api.dart';
import '../model/user_model.dart';
import '../model/log_model.dart';

class LogProvider with ChangeNotifier {
  late FirebaseLogAPI firebaseService;
  late Stream<QuerySnapshot> _logStream;
  late Stream<QuerySnapshot> _logStreamByDate;
  String _location = "UPLB";

  LogProvider() {
    firebaseService = FirebaseLogAPI();
    fetchAllLogs();
  }

  // getter
  Stream<QuerySnapshot> get allLogs => _logStream;
  Stream<QuerySnapshot> get allLogsByDate => _logStreamByDate;
  String get location => _location;

  void fetchAllLogs() async {
    _logStream = firebaseService.fetchAllLogs();
    notifyListeners();
  }

  void fetchAllLogsByDate(DateTime date, String userId) async {
    _logStream = firebaseService.fetchAllLogsByDate(date, userId);
    notifyListeners();
  }

  void addLogs(String status, UserDetails user, String location,
      String monitorId) async {
    String message =
        await firebaseService.addLogs(status, user, location, monitorId);
    notifyListeners();
  }

  void updateStatus(String logId, String studentId, String status) async {
    String message =
        await firebaseService.updateStatus(logId, studentId, status);
    notifyListeners();
  }

  void updateStudentNum(String uid, MonitorLog log) async {
    String message = await firebaseService.updateStudentNum(uid, log);
    notifyListeners();
  }

  void updateLocation(String logId, String location) async {
    String message = await firebaseService.updateLocation(logId, location);
    notifyListeners();
  }

  void updateMonitorLocation(String location) {
    _location = location;
    notifyListeners();
  }
}
