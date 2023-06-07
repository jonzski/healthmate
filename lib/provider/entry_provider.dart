import 'package:flutter/material.dart';
import '../api/firebase_entry_api.dart';
import '../model/entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EntryProvider with ChangeNotifier {
  // Create User Class
  late FirebaseEntryAPI firebaseService;
  late DailyEntry? _entryToday;
  late Stream<QuerySnapshot> _entryStream;
  late Stream<QuerySnapshot> _entryEditRequestStream;
  late Stream<QuerySnapshot> _entryDeleteRequestStream;

  EntryProvider() {
    firebaseService = FirebaseEntryAPI();
    fetchAllEntries();
    fetchAllEntryDeleteRequests();
    fetchAllRequestedEntries();
    _entryToday = initializeEntry();
  }

  // getter
  DailyEntry? get entryToday => _entryToday;
  Stream<QuerySnapshot> get allEntries => _entryStream;
  Stream<QuerySnapshot> get allRequestedEditEntries => _entryEditRequestStream;
  Stream<QuerySnapshot> get allRequestedDeleteEntries =>
      _entryDeleteRequestStream;

  void addEntry(DailyEntry entry, User user) async {
    String message = await firebaseService.addEntry(entry.toJson(entry), user);
    print(message);
    if (message != "You have already added an entry for today" &&
        entry.closeContact == true) {
      String message = await firebaseService.updateMonitoring(entry.uid);
      print(message);
    }
    if (message != "You have already added an entry for today") {
      _entryToday = await firebaseService.getTodayEntry(user);
    }
    notifyListeners();
  }

  Future<bool> checkIfAddedEntry(
      String uid, User user, DateTime timeToday) async {
    DailyEntry entry = DailyEntry(
        uid: uid, symptoms: {}, closeContact: false, entryDate: timeToday);

    bool isAdded =
        await firebaseService.checkIfAddedEntry(entry.toJson(entry), user);

    return isAdded;
  }

  void editEntryRequest(String entryId, DailyEntry entry) async {
    String message = await firebaseService.editEntryRequest(entryId, entry);
    print(message);
    notifyListeners();
  }

  // Validate a QR Code by checking the uid and entryId
  Future<bool> validateQRCode(
      String entryId, String monId, String location) async {
    bool isValid =
        await firebaseService.validateQRCode(entryId, monId, location);
    return isValid;
  }

  void fetchAllEntries() {
    _entryStream = firebaseService.fetchAllEntries();
    notifyListeners();
  }

  void fetchAllRequestedEntries() {
    _entryEditRequestStream = firebaseService.fetchAllRequestedEntries();
    notifyListeners();
  }

  void fetchAllEntryDeleteRequests() {
    _entryDeleteRequestStream = firebaseService.fetchAllEntryDeleteRequests();
    notifyListeners();
  }

  Future<void> editRequest(
      DailyEntry entryRequest, String entryRequestId, String status) async {
    String message =
        await firebaseService.editRequest(entryRequest, entryRequestId, status);
    print(message);

    notifyListeners();
  }

  void entryDeleteRequest(String entryId, DailyEntry entry) async {
    String message = await firebaseService.entryDeleteRequest(entryId, entry);
    print(message);

    notifyListeners();
  }

  void deleteRequest(
      DailyEntry entryRequest, String entryRequestId, String status) async {
    String message = await firebaseService.deleteRequest(
        entryRequest, entryRequestId, status);
    print(message);

    notifyListeners();
  }

  Future<void> getTodayEntry(User user) async {
    _entryToday = await firebaseService.getTodayEntry(user);
    notifyListeners();
  }

  DailyEntry initializeEntry() {
    DateTime timeToday = DateTime.now();

    DailyEntry entry = DailyEntry(
        uid: "", symptoms: {}, closeContact: false, entryDate: timeToday);
    return entry;
  }

  Future<void> updateStatus(String entryRequestId, String status) async {
    String message = await firebaseService.updateStatus(entryRequestId, status);
    print(message);
    notifyListeners();
  }
}
