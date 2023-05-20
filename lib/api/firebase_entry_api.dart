import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseEntryAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addEntry(Map<String, dynamic> entry) async {
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

      return "Successfully edited slambook!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // gawa ng update monitoring. gawin true yung under monitoring kapag naglagay si user na may entry na may close contact siya
}
