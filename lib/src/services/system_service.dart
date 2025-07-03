import 'package:assessment_software_senai/src/models/new_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SystemService {
  //metodo assyncrono informa que vai demorar um pouco pra fazer o retorno
  //void retorna nada
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> registerSystem({
    required String name,
    required String id,
  }) async {
    //instaciando firebase
    //final currentUser = FirebaseAuth.instance.currentUser;
    //pq a ! currentUser so vai exister se o user estiver logado
    //final userId = currentUser!.uid;
    // usandoa coleção user passadno o user id no docuemnto vou criar uma coeleção system
    await FirebaseFirestore.instance.collection('systems').doc(id).set({
      'name': name,
      'id': id,
      'user': userId,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectStreamSystem() {
    return _firestore.collection('systems').snapshots();
  }

  Future<void> deleteSystem({required String systemId}) async {
    return _firestore.collection('systems').doc(systemId).delete();
  }
}
