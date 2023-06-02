import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_user_api.dart';

class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;
  late Stream<QuerySnapshot> _quarantineStream;
  late Stream<QuerySnapshot> _monitorStream;
  late Stream<QuerySnapshot> _clearedStream;

  UserProvider() {
    firebaseService = FirebaseUserAPI();
    getAllStudents();
    viewAllStudentsUnderQuarantine();
    viewAllStudentsUnderMonitoring();
    viewAllStudentCleared();
  }

  Stream<QuerySnapshot> get allStudents => _userStream;
  Stream<QuerySnapshot> get allQuarantinedStudents => _quarantineStream;
  Stream<QuerySnapshot> get allMonitoredStudents => _monitorStream;
  Stream<QuerySnapshot> get allClearedStudent => _clearedStream;

  // Add User to Quarantine
  Future<String> addUserToQuarantine(
      String uid, DateTime quarantineStart, DateTime quarantineEnd) async {
    String message = await firebaseService.addUserToQuarantine(
        uid, quarantineStart, quarantineEnd);
    print(message);

    return message;
  }

  // End Student Monioring
  Future<String> endUserMonitoring(String uid) async {
    String message = await firebaseService.endUserMonitoring(uid);
    print(message);

    return message;
  }

  // Finish Student Quarantine (Update underQuarantine to false, and quarantine end)
  Future<String> finishStudentQuarantine(
      String uid, DateTime quarantineEnd) async {
    String message =
        await firebaseService.finishStudentQuarantine(uid, quarantineEnd);
    print(message);

    return message;
  }

  // View All Students Under Monitoring
  void viewAllStudentsUnderMonitoring() async {
    _monitorStream = firebaseService.getUsersUnderMonitoring();
    notifyListeners();
  }

  // View all students under Quarantine
  void viewAllStudentsUnderQuarantine() async {
    _quarantineStream = firebaseService.getUsersUnderQuarantine();
    notifyListeners();
  }

  void viewAllStudentCleared() async {
    _clearedStream = firebaseService.getUserCleared();
    notifyListeners();
  }

  // Get user quarantine details
  Future<Stream<DocumentSnapshot>> getUserQuarantineDetails(String uid) async {
    Stream<DocumentSnapshot> documentSnapshot =
        firebaseService.getUserQuarantineDetails(uid);
    return documentSnapshot;
  }

  // Elevate User to Admin or Monitor
  Future<String> elevateUserToAdminOrMonitor(String uid, int role) async {
    String message = await firebaseService.elevateUser(uid, role);
    print(message);

    return message;
  }

  // Get all Students
  void getAllStudents() async {
    _userStream = firebaseService.getAllStudents();
    notifyListeners();
  }

  // View Specific Student
  Future<Map<String, dynamic>?> viewSpecificStudent(String uid) async {
    Map<String, dynamic>? student =
        await firebaseService.getSpecificStudent(uid);
    return student;
  }
}
