import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/entry_model.dart';
import '../model/user_model.dart';

class FirebaseLogAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> fetchAllLogs() {
    try {
      return db.collection("log").orderBy('date', descending: true).snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }
}
