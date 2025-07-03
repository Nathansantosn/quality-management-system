import 'package:assessment_software_senai/src/models/new_subcriterion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubCriterionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerSubCriterion({
    required String criterionId,
    required String id,
    required String name,
    required String description,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('Criterions')
        .doc(criterionId)
        .collection('Subcriterions')
        .doc(id)
        .set({
          'criterion': criterionId,
          'id': id,
          'name': name,
          'description': description,
          'user': userId,
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectStreamSubcriterion({
    required String criterionId,
  }) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Criterions')
        .doc(criterionId)
        .collection('Subcriterions')
        .snapshots();
  }

  Future<void> deleteSubCriterio({required String criterionId}) async {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Criterions')
        .doc(criterionId)
        .delete();
  }
}
