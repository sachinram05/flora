import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flora/models/FloraModel.dart';

class FloraProviders {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream get allFloras => _firestore
      .collection('flora')
      .orderBy('createdAt', descending: true)
      .snapshots();

  Stream get allFavoriteFloras => _firestore
      .collection('flora')
      .where('favorite', isEqualTo: true)
      .snapshots();

  allgetFlora() async {
    var floraData;
    await _firestore
        .collection('flora')
        .orderBy('createdAt', descending: true)
        .get()
        .then((snap) => {
              if (snap.docs.isNotEmpty)
                {
                  print('snap.data() ${snap.docs.length} ${snap.docs}'),
                  floraData = snap.docs
                }
            })
        .catchError((onError) =>
            {SnackBar(content: Text('flora not found: $onError'))});

    return floraData;
  }

  getFlora(id) async {
    var floraData;
    try {
      await _firestore
          .collection('flora')
          .doc(id)
          .get()
          .then((snap) => {
                if (snap.exists) {floraData = snap.data()}
              })
          .catchError(
              (error) => SnackBar(content: Text('flora not found: $error')));
      return floraData;
    } catch (error) {
      return Future.error("Error getting document.");
    }
  }

  Future<bool> addNewFlora(Flora flora) async {
    final newFlora = _firestore.collection('flora');

    final user = FirebaseAuth.instance.currentUser!;
    try {
      await newFlora.add({
        'id': flora.id,
        'floraName': flora.title,
        'amount': flora.amount,
        'place': flora.place,
        'description': flora.desc,
        'image_url': flora.image,
        'userId': user.uid,
        'favorite': false,
        'createdAt': Timestamp.now(),
      }).catchError(
          (error) => SnackBar(content: Text('flora not added: $error')));
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> editFlora(bool favoriteStatus, String floraDocId) async {
    final updatedFlora = _firestore.collection('flora');
    var floraStatus;

    try {
      await updatedFlora
          .doc(floraDocId)
          .update({'favorite': favoriteStatus})
          .then((onValue) => floraStatus = true)
          .then((error) => floraStatus = false);
      return floraStatus; //only changing 'isFavorite status'
    } catch (e) {
      return Future.error(e);
    }
  }
}

final floraProvider = Provider((ref) => FloraProviders());
