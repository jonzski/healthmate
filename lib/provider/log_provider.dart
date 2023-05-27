import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_log_api.dart';

class LogProvider with ChangeNotifier {
  late FirebaseLogAPI firebaseService;
  late Stream<QuerySnapshot> _logStream;
  late Stream<QuerySnapshot> _logStreamByDate;

  LogProvider() {
    firebaseService = FirebaseLogAPI();
  }

  // getter
  Stream<QuerySnapshot> get allLogs => _logStream;
  Stream<QuerySnapshot> get allLogsByDate => _logStreamByDate;

  void fetchAllLogs(String userId) async {
    _logStream = firebaseService.fetchAllLogs(userId);
    notifyListeners();
  }

  void fetchAllLogsByDate(DateTime date, String userId) async {
    _logStream = firebaseService.fetchAllLogsByDate(date, userId);
    notifyListeners();
  }
}
