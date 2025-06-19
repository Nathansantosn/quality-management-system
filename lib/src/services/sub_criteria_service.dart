import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubCriterionService {
  String user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SubCriterionService() : user = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerSubCriterion({
    required String criterionId,
    required String id,
    required String name,
    required String description,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final userId = currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('Criterions')
        .doc(criterionId)
        .collection('SubCriterion')
        .doc(id)
        .set({
          'criterion': criterionId,
          'id': id,
          'name': name,
          'description': description,
        });
  }
}
