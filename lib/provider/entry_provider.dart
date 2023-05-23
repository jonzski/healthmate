import 'package:flutter/material.dart';
import '../api/firebase_entry_api.dart';
import '../model/entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EntryProvider with ChangeNotifier {
  // Create User Class
  late FirebaseEntryAPI firebaseService;
  late Stream<QuerySnapshot> _entryToday;

  EntryProvider() {
    firebaseService = FirebaseEntryAPI();
  }

  // getter
  Stream<QuerySnapshot> get entry => _entryToday;

  void addEntry(DailyEntry entry, User user) async {
    String message = await firebaseService.addEntry(entry.toJson(entry), user);
    print(message);
    if (message != "You have already added an entry for today" &&
        entry.closeContact == true) {
      String message = await firebaseService.updateMonitoring(entry.uid);
      print(message);
    }
    _entryToday = firebaseService.getTodayEntry(user);
    notifyListeners();
  }

  void editEntry(DailyEntry entry) async {
    String message = await firebaseService.editEntry(entry);
    print(message);
    notifyListeners();
  }

  // Validate a QR Code by checking the uid and entryId
  Future<bool> validateQRCode(String uid, String entryId) async {
    bool isValid = await firebaseService.validateQRCode(uid, entryId);
    return isValid;
  }
}
