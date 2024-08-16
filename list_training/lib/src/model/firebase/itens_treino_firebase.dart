import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/itens_treino.dart';

class ItensTreinoFirebase {
  final root = FirebaseFirestore.instance.collection('itens_treino');

  Future addTreino({required ItensTreino cItensTreino}) async {
    final docItensTreino = root.doc();

    final itensTreino = ItensTreino(
            id: docItensTreino.id,
            idExercicio: cItensTreino.idExercicio,
            idTreino: cItensTreino.idTreino,
            peso: cItensTreino.peso,
            repeticao: cItensTreino.repeticao,
            sequncia: cItensTreino.sequncia)
        .toJson();

    await docItensTreino
        .set(itensTreino)
        .then((value) => print('Item de treino Treino cadastrado com sucesso'))
        .catchError(
            (error) => print('Erro ao adicionar Item de Treino: $error'));
  }
}
