import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import necessário para obter o usuário logado
import 'package:list_training/src/model/entidades/treino.dart';

class TreinoFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para adicionar um treino à subcoleção 'treinos' do usuário logado
  Future addTreinoParaUsuarioLogado({required Treino cTreino}) async {
    try {
      // Obtendo o usuário logado
      User? usuario = _auth.currentUser;

      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para a subcoleção 'treinos' dentro do documento do usuário
        DocumentReference userDocRef =
            _firestore.collection('users').doc(userId);
        CollectionReference treinosCollectionRef =
            userDocRef.collection('treinos');

        // Cria um novo documento de treino na subcoleção 'treinos'
        DocumentReference docTreino = treinosCollectionRef.doc();

        final treino = Treino(
          id: docTreino.id,
          nome: cTreino.nome,
          dataCadastro: cTreino.dataCadastro,
          idFichaTreino: cTreino.idFichaTreino,
          validade: cTreino.validade,
        ).toJson();

        // Adiciona o treino à subcoleção
        await docTreino
            .set(treino)
            .then((value) => print('Treino cadastrado com sucesso'))
            .catchError((error) => print('Erro ao adicionar treino: $error'));
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao adicionar treino: $e');
    }
  }

  // Função para listar todos os treinos da subcoleção do usuário logado
  Stream<List<Treino>> readTreinosDoUsuarioLogado() {
    User? usuario = _auth.currentUser;

    if (usuario != null) {
      String userId = usuario.uid;

      // Referência para a subcoleção 'treinos' dentro do documento do usuário
      CollectionReference treinosCollectionRef =
          _firestore.collection('users').doc(userId).collection('treinos');

      // Stream para ouvir as mudanças em tempo real
      return treinosCollectionRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Treino.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } else {
      print('Nenhum usuário está logado.');
      return Stream.value(
          []); // Retorna uma stream vazia se não houver usuário logado
    }
  }
}
