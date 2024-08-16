import 'package:list_training/src/model/entidades/ficha_treino.dart';

class Treino {
  dynamic id;
  dynamic idFichaTreino;
  late DateTime dataCadastro;
  late int validade;

  Treino({
    this.id,
    required this.dataCadastro,
    required this.validade,
    required this.idFichaTreino,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idFichaTreino': idFichaTreino,
      'dataCadastro': dataCadastro,
      'validade': validade
    };
  }

  static Treino fromJson(Map<String, dynamic> json) {
    return Treino(
        id: json['id'],
        idFichaTreino: json['idFichaTreino'],
        dataCadastro: json['dataCadastro'],
        validade: json['validade']);
  }
}
