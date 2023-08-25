import 'package:list_training/src/model/entidades/enum/enum_dia_semana.dart';
import 'package:list_training/src/model/entidades/personal.dart';

class Agenda {
  dynamic id;
  dynamic idAluno;
  dynamic idPersonal;
  late DiaSemana diaSemana;
  late DateTime horaInicial;
  late DateTime tempoTreino;

  Agenda(
      {this.id,
      required this.diaSemana,
      required this.idAluno,
      required this.horaInicial,
      required this.idPersonal,
      required this.tempoTreino});

  Map<String, dynamic> toJson() {
    return {
      'diaSemana': diaSemana,
      'idAluno': idAluno,
      'horaInicial': horaInicial,
      'idPersonal': idPersonal,
      'tempoTreino': tempoTreino
    };
  }

  static Agenda fromJson(Map<String, dynamic> json) {
    return Agenda(
        diaSemana: json['diaSemana'],
        idAluno: json['idAluno'],
        horaInicial: json['horaInicial'],
        idPersonal: json['idPersonal'],
        tempoTreino: json['tempoTreino']);
  }
}
