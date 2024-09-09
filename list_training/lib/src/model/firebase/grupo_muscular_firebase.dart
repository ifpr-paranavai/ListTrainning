import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/grupo_muscular.dart';
import 'package:list_training/src/model/entidades/exercicio.dart'; // Import da entidade Exercicio

class GrupoMuscularFirebase {
  final root = FirebaseFirestore.instance.collection('grupo_muscular');
  final exerciciosRoot = FirebaseFirestore.instance
      .collection('exercicios'); // Coleção de exercícios

  Future addGrupoMuscular({required GrupoMuscular cGrupoMuscular}) async {
    final docGrupoMuscular = root.doc();

    final grupoMuscular = GrupoMuscular(
      id: docGrupoMuscular.id,
      nome: cGrupoMuscular.nome,
      descricao: cGrupoMuscular.descricao,
    ).toJson();

    await docGrupoMuscular
        .set(grupoMuscular)
        .then((value) => print('Grupo Muscular cadastrado com sucesso'))
        .catchError(
            (error) => print('Erro ao adicionar grupo muscular: $error'));
  }

  Stream<List<GrupoMuscular>> readGruposMusculares() {
    return root.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return GrupoMuscular.fromJson(data);
        }).toList());
  }

  Future<List<GrupoMuscular>> readGruposMuscularesFuture() async {
    final snapshot = await root.get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return GrupoMuscular.fromJson(data);
    }).toList();
  }

  // Função para verificar se um grupo muscular está vinculado a algum exercício
  Future<bool> isGrupoMuscularLinked(String grupoMuscularId) async {
    final exercicios = await getExerciciosByGrupoMuscularId(grupoMuscularId);
    return exercicios
        .isNotEmpty; // Retorna true se existir algum exercício vinculado
  }

  // Função para obter a lista de exercícios vinculados a um grupo muscular
  Future<List<Exercicio>> getExerciciosByGrupoMuscularId(
      String grupoMuscularId) async {
    try {
      final querySnapshot = await exerciciosRoot
          .where('idGrupoMuscular', isEqualTo: grupoMuscularId)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Exercicio.fromJson(data);
      }).toList();
    } catch (e) {
      print('Erro ao buscar exercícios: $e');
      return [];
    }
  }

  Future<void> deleteGrupoMuscular({required String id}) async {
    await root.doc(id).delete();
  }

  Future<void> updateGrupoMuscular(
      {required String id,
      required String nome,
      required String descricao}) async {
    final docGrupoMuscular = root.doc(id);
    await docGrupoMuscular.update({
      'nome': nome,
      'descricao': descricao,
    });
  }
}
