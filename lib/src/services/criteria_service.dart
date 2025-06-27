import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CriterionService {
  String user;

  CriterionService() : user = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerCriterion({
    required String id,
    required String name,
    required String description,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final userId = currentUser!.uid;

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
}
