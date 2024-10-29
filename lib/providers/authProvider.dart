import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier {
  AuthNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

//userDetails
  getUserDetails() async {
    Map<String, dynamic>? validData;
    await _firestore
        .collection('users')
        .doc(user.uid) //user.uid
        .get()
        .then((snap) => {
              if (snap.exists)
                {validData = snap.data()}
              else
                {const SnackBar(content: Text('user details not found'))}
            })
        .catchError((error) {
      print('error $error');
      SnackBar(content: Text('user not found: $error'));
    });
    return validData;
  }

// update
  updateUserDetails(username, image, addreess, usermobile) async {
    var imageUrl;
    if (image == null || image is String) {
      imageUrl = image;
    } else {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user.uid}.jpg');

      await storageRef.putFile(image!);
      imageUrl = await storageRef.getDownloadURL();
    }

    // final updatedStatus =
    await _firestore.collection('users').doc(user.uid).update({
      'username': username,
      // 'email': enteredEmail, //email is unique can't update
      'image_url': imageUrl,
      'address': addreess,
      'mobile': usermobile,
    }).then((value) {
      return true;
    }).catchError((error) {
      SnackBar(content: Text('user not updated: $error'));
    });
  }
}

final authDataProvider = StateNotifierProvider((ref) {
  return AuthNotifier();
});
