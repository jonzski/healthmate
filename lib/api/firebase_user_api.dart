import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/entry_model.dart';
import '../model/user_model.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Add User to Quarantine
  Future<String> addUserToQuarantine(
      String uid, DateTime quarantineStart) async {
    try {
      await db.collection("quarantine").doc(uid).set({
        'uid': uid,
        'underQuarantine': true,
        'userQuarantineStart': quarantineStart,
        'userQuarantineEnd': null,
      });

      // update underQuarantine to true
      await db.collection("user").doc(uid).update({
        'underQuarantine': true,
      });

      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

// End Student Monioring
  Future<String> endUserMonitoring(String uid) async {
    try {
      await db.collection("user").doc(uid).update({
        'underMonitoring': false,
        'underQuarantine': false,
      });

      return "Successfully ended monitoring!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

// Finish Student Quarantine (Update underQuarantine to false, and quarantine end) {
  Future<String> finishStudentQuarantine(
      String uid, DateTime quarantineEnd) async {
    try {
      await db.collection("quarantine").doc(uid).update({
        'underQuarantine': false,
        'userQuarantineEnd': quarantineEnd,
      });

      // Update underQuarantine and UnderMonitoring to false
      await db.collection("user").doc(uid).update({
        'underQuarantine': false,
        'underMonitoring': false,
      });

      return "Successfully updated user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // View all users under monitoring
  Stream<QuerySnapshot> getUsersUnderMonitoring() {
    try {
      return db
          .collection("user")
          .where('underMonitoring', isEqualTo: true)
          .where('underQuarantine', isEqualTo: false)
          .snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> getUserCleared() {
    try {
      return db
          .collection("user")
          .where('underMonitoring', isEqualTo: false)
          .where('underQuarantine', isEqualTo: false)
          .where('userType', isEqualTo: 0)
          .snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  // View all users under quarantine
  Stream<QuerySnapshot> getUsersUnderQuarantine() {
    try {
      return db
          .collection("user")
          .where('underMonitoring', isEqualTo: true)
          .where('underQuarantine', isEqualTo: true)
          .snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  // Get User Quarantine Details
  Stream<DocumentSnapshot> getUserQuarantineDetails(String uid) {
    try {
      return db.collection("quarantine").doc(uid).snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  // Elevate User to Admin or Monitor
  Future<String> elevateUser(String uid, int role) async {
    try {
      await db.collection("user").doc(uid).update({
        'userType': role,
      });

      return "Successfully elevated user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // Get All Students
  Stream<QuerySnapshot> getAllStudents() {
    try {
      return db.collection("user").where('userType', isEqualTo: 0).snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  // View Specific Student
  Future<Map<String, dynamic>?> getSpecificStudent(String uid) async {
    try {
      final docRef = db.collection("user").doc(uid);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }
}
