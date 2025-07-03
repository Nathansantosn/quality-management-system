import 'package:assessment_software_senai/src/models/new_evaluation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EvaluationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerEvaluation(Evaluation evaluation) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('Evaluations')
        .doc(evaluation.id)
        .set(evaluation.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectStreamEvaluation() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Evaluations')
        .snapshots();
  }

  Future<void> deleteEvaluation(Evaluation evaluation) async {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Evaluations')
        .doc(evaluation.id)
        .delete();
  }
}
