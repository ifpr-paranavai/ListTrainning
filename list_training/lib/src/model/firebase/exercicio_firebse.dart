import 'package:cloud_firestore/cloud_firestore.dart';

import '../entidades/exercicio.dart';

class ExercicioFirebase {
  final root = FirebaseFirestore.instance.collection('exercicio');

  // Função para adicionar um exercício
  Future addExercicio({required Exercicio cExercicio}) async {
    final docExercicio = root.doc();

    final exercicio = Exercicio(
      id: docExercicio.id,
      nome: cExercicio.nome,
      descricao: cExercicio.descricao,
      urlExplicao: cExercicio.urlExplicao,
      idGrupoMuscular: cExercicio.idGrupoMuscular,
    ).toJson();

    await docExercicio
        .set(exercicio)
        .then((value) => print('Exercicio cadastrado com sucesso'))
        .catchError((error) => print('Erro ao adicionar exercicio: $error'));
  }

  // Função para ler todos os exercícios
  Stream<List<Exercicio>> readExercicios() {
    CollectionReference exercicios =
        FirebaseFirestore.instance.collection('exercicio');

    return exercicios.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Exercicio.fromJson(data);
        }).toList());
  }

  // Função para pesquisar um exercício por ID específico
  Future<Exercicio?> getExercicioById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await root.doc(id).get();
      if (docSnapshot.exists) {
        return Exercicio.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Exercicio com ID $id não encontrado.');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar exercicio: $e');
      return null;
    }
  }

  Exercicio? getExercicioByIdF(String id) {
    // Função que executa a consulta ao Firebase de forma síncrona para o fluxo
    // Mas ainda depende do comportamento assíncrono de `await` internamente.
    var result;

    // Realizando a consulta dentro de uma função assíncrona
    _getExercicio(id).then((exercicio) {
      result = exercicio; // Atribui o resultado após a consulta
    });

    return result; // Retorna o resultado após a consulta
  }

  Future<Exercicio?> _getExercicio(String id) async {
    try {
      DocumentSnapshot docSnapshot = await root.doc(id).get();
      if (docSnapshot.exists) {
        return Exercicio.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Exercicio com ID $id não encontrado.');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar exercicio: $e');
      return null;
    }
  }

  Stream<Exercicio> getExercicioByIdS(String id) {
    return root
        .doc(id)
        .snapshots()
        .where((docSnapshot) => docSnapshot.exists)
        .map((docSnapshot) {
      return Exercicio.fromJson(docSnapshot.data() as Map<String, dynamic>);
    });
  }

  // Função para alterar os dados de um exercício por ID específico
  Future<void> updateExercicio(
      {required String id, required Exercicio cExercicio}) async {
    try {
      await root.doc(id).update(cExercicio.toJson());
      print('Exercicio atualizado com sucesso.');
    } catch (e) {
      print('Erro ao atualizar exercicio: $e');
    }
  }

  // Função para excluir um exercício por ID específico
  Future<void> deleteExercicioById(String id) async {
    try {
      await root.doc(id).delete();
      print('Exercicio excluído com sucesso.');
    } catch (e) {
      print('Erro ao excluir exercicio: $e');
    }
  }
}
