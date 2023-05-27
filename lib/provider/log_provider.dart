import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_log_api.dart';

class LogProvider with ChangeNotifier {
  late FirebaseLogAPI firebaseService;
  late Stream<QuerySnapshot> _logStream;

  LogProvider() {
    firebaseService = FirebaseLogAPI();
    fetchAllLogs();
  }

  Stream<QuerySnapshot> get allLogs => _logStream;

  void fetchAllLogs() async {
    _logStream = firebaseService.fetchAllLogs();
    notifyListeners();
  }
}
