import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/itens_treino.dart';

class ItensTreinoFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para adicionar um item de treino a uma subcoleção de treino específica
  Future addItemParaTreino(
      {required ItensTreino cItensTreino, required String idTreino}) async {
    try {
      // Referência para o documento do treino específico
      DocumentReference treinoDocRef =
          _firestore.collection('treino').doc(idTreino);

      // Referência para a subcoleção 'itens_treino' dentro do documento do treino
      CollectionReference itensTreinoCollectionRef =
          treinoDocRef.collection('itens_treino');

      // Cria um novo documento para o item de treino na subcoleção
      DocumentReference docItensTreino = itensTreinoCollectionRef.doc();

      final itensTreino = ItensTreino(
        id: docItensTreino.id,
        idExercicio: cItensTreino.idExercicio,
        peso: cItensTreino.peso,
        repeticao: cItensTreino.repeticao,
        sequncia: cItensTreino.sequncia,
      ).toJson();

      // Adiciona o item de treino à subcoleção
      await docItensTreino
          .set(itensTreino)
          .then((value) => print('Item de treino cadastrado com sucesso'))
          .catchError(
              (error) => print('Erro ao adicionar item de treino: $error'));
    } catch (e) {
      print('Erro ao adicionar item de treino: $e');
    }
  }
}
