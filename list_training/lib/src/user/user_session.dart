import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userId;
  String? email;
  String? name;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  // Função para inicializar as informações do usuário logado
  Future<void> initialize() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      email = currentUser.email;

      // Busca o nome do Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        name = userDoc['name'];
      }
    } else {
      print("Nenhum usuário logado.");
    }
  }

  bool get isLoggedIn => userId != null;
}
