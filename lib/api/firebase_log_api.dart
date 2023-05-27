import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/entry_model.dart';
import '../model/user_model.dart';

class FirebaseLogAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> fetchAllLogs(String userId) {
    try {
      return db
          .collection("log")
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot<Object?>> fetchAllLogsByDate(
      DateTime date, String userId) {
    try {
      return db
          .collection("log")
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: date)
          .orderBy('date', descending: true)
          .snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }
}
