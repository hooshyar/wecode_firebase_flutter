import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//https://firebase.google.com/docs/auth/flutter/start

class Auth {
  Future<UserCredential> registerWithEmailAndPassword(
      String emailFromTheBody, String passwordFromTheBody) async {
    UserCredential? _userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailFromTheBody, password: passwordFromTheBody);
    if (_userCredential == null) {
      debugPrint('null');
    }

    debugPrint(_userCredential.user!.email.toString());
    return _userCredential;

// try {
//   final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//     email: emailAddress,
//     password: password,
//   );
// } on FirebaseAuthException catch (e) {
//   if (e.code == 'weak-password') {
//     print('The password provided is too weak.');
//   } else if (e.code == 'email-already-in-use') {
//     print('The account already exists for that email.');
//   }
// } catch (e) {
//   print(e);
// }
  }

  Future<UserCredential> loginWithUserAndPassword(
      {required String email, required String password}) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
