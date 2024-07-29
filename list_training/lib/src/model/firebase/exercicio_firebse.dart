import 'package:cloud_firestore/cloud_firestore.dart';

import '../entidades/exercicio.dart';

class ExercicioFirebase {
  final root = FirebaseFirestore.instance.collection('exercicio');

  Future addTreino({required Exercicio cExercicio}) async {
    final docExercicio = root.doc();

    final exercicio = Exercicio(
      id: docExercicio.id,
      nome: cExercicio.nome,
      descricao: cExercicio.descricao,
      urlExplicao: cExercicio.urlExplicao,
    ).toJson();

    await docExercicio
        .set(exercicio)
        .then((value) => print('Exerxixio cadastrado com sucesso'))
        .catchError((error) => print('Erro ao adicionar exerxixio: $error'));
  }

  Stream<List<Exercicio>> readExercicios() {
    CollectionReference exercicios =
        FirebaseFirestore.instance.collection('exercicio');

    return exercicios.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Exercicio.fromJson(data);
        }).toList());
  }
}
