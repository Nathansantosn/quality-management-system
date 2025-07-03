import 'package:assessment_software_senai/src/models/new_questio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// question não passei com parametros nomeados
class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerQuestion(Question question) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('Questions')
        .doc(question.id)
        .set(question.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectStreamQuestion() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Questions')
        .snapshots();
  }

  Future<void> deleteQuestion(Question question) async {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Questions')
        .doc(question.id)
        .delete();
  }
}
