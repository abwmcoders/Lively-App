// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lively/src/core/helper.dart';
import 'package:lively/src/feature/lively_auth/data/database_services.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //! login function
  Future logInUser(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        //! call our databse services to update user
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //! register function
  Future registerUser(String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        //! call our databse services to update user
        await DatabaseServices(userId: user.uid)
            .savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //! signout function
  Future signOut() async {
    try {
      await Helper.saveUserLoggedInStatus(false);
      await Helper.saveUserEmail('');
      await Helper.saveUserName('');
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
