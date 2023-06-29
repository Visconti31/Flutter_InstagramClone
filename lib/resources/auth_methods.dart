import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
//import "package:flutter/material.dart";
import "package:instagram_clone/resources/storage_methods.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register
  Future<String> registerUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occur';
    // Form verification
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // Register the user on Firebase
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Take image from storage
        String imageUrl = await StorageMethods()
            .uploadImageToStorage('profileImages', file, false);

        // Add user to database
        await _firestore.collection('users').doc(userCred.user!.uid).set({
          'username': username,
          'uid': userCred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'imageUrl': imageUrl,
        });
        res = 'success';
      }
    } on FirebaseAuthException catch (fireError) {
      if (fireError.code == 'invalid-email') {
        res = 'Please provide a valid email';
      } else if (fireError.code == 'weak-password') {
        res = 'Password should be at least 6 digits';
      } //TODO: Add verification for when email already exist. Currently is showing line 20
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //Login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occur';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'success';
      } else {
        //TODO Add verification for each tipe of error
        res = 'Enter all the fields';
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }
}
