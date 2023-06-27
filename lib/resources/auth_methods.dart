import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register
  Future<String> registerUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    //required Uint8List file,
  }) async {
    String res = 'Some error occur';
    // Form verification
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        //||
        //file != null) {
        // Register the user on Firebase
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Add user to database
        print(userCred.user!.uid);
        await _firestore.collection('users').doc(userCred.user!.uid).set({
          'username': username,
          'uid': userCred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
        });
        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}
