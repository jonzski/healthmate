import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEntryAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addEntry(Map<String, dynamic> entry, User user) async {
    DateTime timeToday = DateTime.now();
    timeToday = DateTime(timeToday.year, timeToday.month, timeToday.day);

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('entry')
        .where('entryDate', isEqualTo: timeToday)
        .where('uid', isEqualTo: user.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return "You have already added an entry for today";
    }

    try {
      final docRef = await db.collection("entry").add(entry);
      await db.collection("entry").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> updateMonitoring(String uid) async {
    try {
      await db.collection("user").doc(uid).update({'userMonitoring': true});

      return "Successfully updated Monitoring!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getTodayEntry(User user) {
    DateTime timeToday = DateTime.now();
    timeToday = DateTime(timeToday.year, timeToday.month, timeToday.day);

    try {
      return db
          .collection("entry")
          .where('uid', isEqualTo: user.uid)
          .where('entryDate', isEqualTo: timeToday)
          .snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<String> editEntry(DailyEntry entry) async {
    try {
      await db.collection("user").doc(entry.uid).update({
        'symptoms': entry.symptoms,
        'closeContact': entry.closeContact,
        'remarks': entry.remarks,
        'status': 'Pending'
      });

      return "Successfully edited entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // gawa ng update monitoring. gawin true yung under monitoring kapag naglagay si user na may entry na may close contact siya

  // Method to validateQRCode by checking if the entryId is valid and if the uid is the same as the uid of the entry
  Future<bool> validateQRCode(String uid, String entryId) {
    try {
      return db
          .collection("entry")
          .where('id', isEqualTo: entryId)
          .where('uid', isEqualTo: uid)
          .get()
          .then((value) => value.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
