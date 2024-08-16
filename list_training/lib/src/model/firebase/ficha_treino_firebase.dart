import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/ficha_treino.dart';

class FichaTreinoFirebase {
  final root = FirebaseFirestore.instance.collection('ficha_treino');

  Future addFichaTreino({required FichaTreino cFichaTreino}) async {
    final docFichaTreino = root.doc();

    final fichaTreino = FichaTreino(
            id: docFichaTreino.id,
            dataCadastro: cFichaTreino.dataCadastro,
            validadeMeses: cFichaTreino.validadeMeses,
            idPersonal: cFichaTreino.idPersonal)
        .toJson();

    await docFichaTreino
        .set(fichaTreino)
        .then((value) => print('Treino cadastrado com sucesso'))
        .catchError((error) => print('Erro ao adicionar treino: $error'));
  }
}
