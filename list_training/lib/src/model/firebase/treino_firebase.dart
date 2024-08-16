import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/treino.dart';

class TreinoFirebase {
  final root = FirebaseFirestore.instance.collection('treino');

  Future addTreino({required Treino cTreino}) async {
    final docTreino = root.doc();

    final treino = Treino(
            id: docTreino.id,
            dataCadastro: cTreino.dataCadastro,
            idFichaTreino: cTreino.idFichaTreino,
            validade: cTreino.validade)
        .toJson();

    await docTreino
        .set(treino)
        .then((value) => print('Treino cadastrado com sucesso'))
        .catchError((error) => print('Erro ao adicionar treino: $error'));
  }
}
