import 'package:list_training/src/model/entidades/aluno.dart';
import 'package:list_training/src/model/entidades/personal.dart';

class FichaTreino {
  dynamic id;
  dynamic idPersonal;
  late DateTime dataCadastro;
  late int validadeMeses;

  FichaTreino(
      {this.id,
      required this.idPersonal,
      required this.dataCadastro,
      required this.validadeMeses});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idPersonal': idPersonal,
      'dataCadastro': dataCadastro,
      'validadeMeses': validadeMeses,
    };
  }

  static FichaTreino fromJson(Map<String, dynamic> json) {
    return FichaTreino(
        id: json['id'],
        idPersonal: json['idPersonal'],
        dataCadastro: json['dataCadastro'],
        validadeMeses: json['validadeMeses']);
  }
}
