import 'package:cloud_firestore/cloud_firestore.dart';

class ExercicioRealizado {
  dynamic id;
  dynamic idTreinoRealizado;
  dynamic idExercicio;
  late String nome;
  late double peso;
  late int repeticao;
  late int sequncia;
  late DateTime dataRealizacao;

  ExercicioRealizado(
      {this.id,
      this.idTreinoRealizado,
      this.idExercicio,
      required this.sequncia,
      required this.nome,
      required this.peso,
      required this.repeticao,
      required this.dataRealizacao});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTreinoRealizado': idTreinoRealizado,
      'idExercicio': idExercicio,
      'nome': nome,
      'peso': peso,
      'repeticao': repeticao,
      'sequncia': sequncia,
      'dataRealizacao': dataRealizacao
    };
  }

  static ExercicioRealizado fromJson(Map<String, dynamic> json) {
    return ExercicioRealizado(
      id: json['id'],
      idTreinoRealizado: json['idTreinoRealizado'],
      idExercicio: json['idExercicio'],
      nome: json['nome'],
      peso: json['peso'],
      repeticao: json['repeticao'],
      sequncia: json['sequncia'],
      dataRealizacao: json['dataRealizacao'] is Timestamp
          ? (json['dataRealizacao'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
