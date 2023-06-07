import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> get getUser => auth.authStateChanges();
  User get currentUser => auth.currentUser!;

  Future<UserCredential?> signIn(
      String email, String password, int userType) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final snapshot = await db
          .collection("user")
          .where('userId', isEqualTo: credential.user?.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = snapshot.docs[0];
        Map<String, dynamic> userAcc = document.data() as Map<String, dynamic>;
        if (userAcc['userType'] != userType) {
          return null;
        } else {
          return credential;
        }
      }
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      print("${e.code}: ${e.message}");
      // get the portion inside parenthesis in e.message
      // and return it
      // From: https://stackoverflow.com/questions/57949887/how-do-i-use-regexp-in-flutter
      // String? message =
      //     RegExp('\\(([^)]+)\\)').firstMatch(e.message!)?.group(1);
      throw e;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, int userType, String name,
      Map<String, dynamic> userInfo) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserDetails newUser = UserDetails(
          userId: credential.user?.uid, userType: userType, name: name);
      if (userType == 0) {
        newUser.userName = userInfo["username"];
        newUser.college = userInfo["college"];
        newUser.course = userInfo["course"];
        newUser.studentNum = userInfo["studentNum"];
        newUser.underMonitoring = userInfo["underMonitoring"];
        newUser.underQuarantine = userInfo["underQuarantine"];
        newUser.preExistingDisease = userInfo["diseases"];
        newUser.allergies = userInfo["allergies"];
      } else {
        newUser.empNo = userInfo["empNo"];
        newUser.position = userInfo["position"];
        newUser.homeUnit = userInfo["homeUnit"];
        newUser.underMonitoring = userInfo["underMonitoring"];
        newUser.underQuarantine = userInfo["underQuarantine"];
        newUser.preExistingDisease = userInfo["diseases"];
        newUser.allergies = userInfo["allergies"];
      }

      db
          .collection("user")
          .doc(credential.user?.uid)
          .set(newUser.toJson(newUser));

      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.\
      print(credential);
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      String? message =
          RegExp('\\(([^)]+)\\)').firstMatch(e.message!)?.group(1);
      throw message!;
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
