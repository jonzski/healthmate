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

  Stream<QuerySnapshot> getAllEntries() {
    return db.collection("entry").snapshots();
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
}
