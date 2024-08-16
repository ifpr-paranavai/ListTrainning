import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/grupo_muscular.dart';

class GrupoMuscularFirebase {
  final root = FirebaseFirestore.instance.collection('grupo_muscular');

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
}
