import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class AuthenticationService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String position,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name': name,
            'Email': email,
            'position': position,
            'password': password,
          });
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Usuário já cadastrado';
      }
      return 'Erro desconhecido';
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; //sucesso
    } on FirebaseAuthException catch (e) {
      print('Código do erro: ${e.code}');
      print('Mensagem: ${e.message}');

      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o e-mail.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'user-disabled':
          return 'Essa conta foi desativada.';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde.';
        default:
          return 'Erro ao fazer login. Código: ${e.code}';
      }
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<void> unlog() async {
    return _firebaseAuth.signOut();
  }
}
