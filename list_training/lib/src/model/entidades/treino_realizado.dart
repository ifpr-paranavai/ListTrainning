import 'package:list_training/src/model/entidades/exercicio_realizado.dart';

class TreinoRealizado {
  dynamic id;
  dynamic idTreino;
  late DateTime data;
  List<ExercicioRealizado>? exerciciosRealizados;

  TreinoRealizado({
    this.id,
    this.idTreino,
    this.exerciciosRealizados,
    required this.data,
  }) {
    exerciciosRealizados ??= [];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'idTreino': idTreino, 'data': data};
  }

  static TreinoRealizado fromJson(Map<String, dynamic> json) {
    return TreinoRealizado(
      id: json['id'],
      idTreino: json['idTreino'],
      data: json['data'],
    );
  }
}
