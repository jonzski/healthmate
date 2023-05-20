import 'package:flutter/material.dart';
import '../api/firebase_entry_api.dart';
import '../model/entry_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryProvider with ChangeNotifier {
  // Create User Class
  late FirebaseEntryAPI firebaseService;
  late Stream<QuerySnapshot> _entryStream;

  TodoListProvider() {
    firebaseService = FirebaseEntryAPI();
    // fetchEntries();
  }

  // getter
  Stream<QuerySnapshot> get entry => _entryStream;

  void addEntry(DailyEntry entry) async {
    DateTime timeToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (entry.entryDate == timeToday) {
      print("You have already added an entry today!");
      return;
    } else {
      String message = await firebaseService.addEntry(entry.toJson(entry));
      print(message);
      if (entry.closeContact == true) {
        String message = await firebaseService.updateMonitoring(entry.uid);
        print(message);
      }
      notifyListeners();
    }
  }
}
