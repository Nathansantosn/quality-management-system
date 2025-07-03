import 'package:assessment_software_senai/src/models/new_criterion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class CriterionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerCriterion({
    required String id,
    required String name,
    required String description,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Criterions')
        .doc(id)
        .set({
          'id': id,
          'name': name,
          'description': description,
          'user': userId,
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectStreamCriterion() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Criterions')
        .snapshots();
  }

  Future<void> deleteCriterion({required String criterioId}) async {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Criterions')
        .doc(criterioId)
        .delete();
  }
}
