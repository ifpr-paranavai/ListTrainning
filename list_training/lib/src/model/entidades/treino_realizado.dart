import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/exercicio_realizado.dart';

class TreinoRealizado {
  dynamic id;
  dynamic idTreino;
  late DateTime data;
  late String nome;
  List<ExercicioRealizado>? exerciciosRealizados;

  TreinoRealizado({
    this.id,
    this.idTreino,
    this.exerciciosRealizados,
    required this.nome,
    required this.data,
  }) {
    exerciciosRealizados ??= [];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'idTreino': idTreino, 'data': data, 'nome': nome};
  }

  static TreinoRealizado fromJson(Map<String, dynamic> json) {
    return TreinoRealizado(
      id: json['id'],
      idTreino: json['idTreino'],
      nome: json['nome'],
      data: json['data'] is Timestamp ? (json['data'] as Timestamp).toDate() : DateTime.now(),
    );
  }
}
