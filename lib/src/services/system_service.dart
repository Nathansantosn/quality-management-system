import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SystemService {
  String user;
  //instaciando firebase

  //pq a ! currentUser so vai exister se o user estiver logado
  SystemService() : user = FirebaseAuth.instance.currentUser!.uid;

  //metodo assyncrono informa que vai demorar um pouco pra fazer o retorno
  //void retorna nada
  Future<void> registerSystem({
    required String name,
    required String id,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final userId = currentUser!.uid;
    //usandoa coleção user passadno o user id no docuemnto vou criar uma coeleção system
    // await FirebaseFirestore.instance.collection('systems').doc(id).set({
    //   'name': name,
    //   'id': id,
    //   'user': userId,
    // });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('systems')
        .doc(id)
        .set({'name': name, 'id': id});
  }
}
