import 'package:assessment_software_senai/src/models/new_questio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// question não passei com parametros nomeados
class QuestionService {
  String user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  QuestionService() : user = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerQuestion(Question question) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final userId = currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('questions')
        .doc(question.id)
        .set(question.toMap());
  }
}
