import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:list_training/src/model/entidades/itens_treino.dart';

class ItensTreinoFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Função para adicionar um item de treino a uma subcoleção 'itens_treino' de um treino específico do usuário logado
  Future<void> addItemParaTreino({
    required ItensTreino cItensTreino,
    required String idTreino,
  }) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para a subcoleção 'itens_treino' dentro do documento do treino do usuário
        DocumentReference treinoDocRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('treinos')
            .doc(idTreino);

        CollectionReference itensTreinoCollectionRef =
            treinoDocRef.collection('itens_treino');

        DocumentReference docItensTreino = itensTreinoCollectionRef.doc();

        final itensTreino = ItensTreino(
          id: docItensTreino.id,
          idExercicio: cItensTreino.idExercicio,
          peso: cItensTreino.peso,
          repeticao: cItensTreino.repeticao,
          sequncia: cItensTreino.sequncia,
        ).toJson();

        await docItensTreino
            .set(itensTreino)
            .then((value) => print('Item de treino cadastrado com sucesso'))
            .catchError(
                (error) => print('Erro ao adicionar item de treino: $error'));
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao adicionar item de treino: $e');
    }
  }

  /// Função para editar um item de treino na subcoleção 'itens_treino' de um treino específico
  Future<void> updateItemTreino({
    required String idTreino,
    required String idItemTreino,
    required double peso,
    required int repeticao,
    required int sequncia,
  }) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para o item específico a ser atualizado na subcoleção 'itens_treino'
        DocumentReference itemTreinoDocRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('treinos')
            .doc(idTreino)
            .collection('itens_treino')
            .doc(idItemTreino);

        await itemTreinoDocRef
            .update({
              'peso': peso,
              'repeticao': repeticao,
              'sequncia': sequncia,
            })
            .then((value) => print('Item de treino atualizado com sucesso'))
            .catchError(
                (error) => print('Erro ao editar item de treino: $error'));
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao editar item de treino: $e');
    }
  }

  /// Função para excluir um item de treino da subcoleção 'itens_treino' de um treino específico
  Future<void> deleteItemTreino({
    required String idTreino,
    required String idItemTreino,
  }) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario != null) {
        String userId = usuario.uid;

        // Referência para o item específico a ser deletado
        DocumentReference itemTreinoDocRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('treinos')
            .doc(idTreino)
            .collection('itens_treino')
            .doc(idItemTreino);

        await itemTreinoDocRef.delete().then((value) {
          print('Item de treino deletado com sucesso');
        }).catchError((error) {
          print('Erro ao deletar item de treino: $error');
        });
      } else {
        print('Nenhum usuário está logado.');
      }
    } catch (e) {
      print('Erro ao deletar item de treino: $e');
    }
  }

  /// Função para listar itens de treino dentro de um treino específico do usuário logado
  Stream<List<ItensTreino>> getItensTreino({required String idTreino}) {
    User? usuario = _auth.currentUser;

    if (usuario != null) {
      String userId = usuario.uid;

      // Referência para a subcoleção 'itens_treino' dentro do treino específico do usuário
      CollectionReference itensTreinoCollectionRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('treinos')
          .doc(idTreino)
          .collection('itens_treino');

      // Retorna um stream dos itens de treino, convertendo-os para objetos ItensTreino
      return itensTreinoCollectionRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return ItensTreino.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } else {
      return Stream.value(
          []); // Retorna um stream vazio se o usuário não estiver logado
    }
  }
}
