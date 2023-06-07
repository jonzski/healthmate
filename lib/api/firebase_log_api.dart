import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/entry_model.dart';
import '../model/user_model.dart';
import '../model/log_model.dart';

class FirebaseLogAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> fetchAllLogs() {
    try {
      return db.collection("log").orderBy('date', descending: true).snapshots();
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
          .where('date', isGreaterThanOrEqualTo: date)
          .where('date', isLessThanOrEqualTo: date.add(const Duration(days: 1)))
          .orderBy('date', descending: true)
          .snapshots();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<String> addLogs(String status, UserDetails user, String location,
      String monitorId) async {
    DateTime timeToday = DateTime.now();
    timeToday = DateTime(timeToday.year, timeToday.month, timeToday.day)
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0)
        .toUtc();

    try {
      final docRef = await db.collection("log").add({
        'status': status,
        'studentNum': user.studentNum,
        'date': timeToday,
        'uid': monitorId,
        'studentId': user.userId,
        'location': location,
      });
      await db.collection("log").doc(docRef.id).update({'logId': docRef.id});

      return "Successfully added logs!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> updateStatus(
      String logId, String studentId, String status) async {
    try {
      await db.collection("log").doc(logId).update({
        'status': status,
      });

      if (status == "Cleared") {
        await db.collection("user").doc(studentId).update({
          'underMonitoring': false,
          'underQuarantine': false,
        });
      } else if (status == "Under Monitoring") {
        await db.collection("user").doc(studentId).update({
          'underMonitoring': true,
          'underQuarantine': false,
        });
      } else {
        await db.collection("user").doc(studentId).update({
          'underMonitoring': true,
          'underQuarantine': true,
        });
      }

      return "Successfully updated Status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> updateStudentNum(String uid, MonitorLog log) async {
    try {
      await db.collection("log").doc(log.logId).update({
        'studentNum': log.studentNum,
      });

      await db.collection("user").doc(log.studentId).update({
        'studentNum': log.studentNum,
      });

      return "Successfully updated Student Number!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> updateLocation(String logId, String location) async {
    try {
      await db.collection("log").doc(logId).update({
        'location': location,
      });

      return "Successfully updated Location!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
