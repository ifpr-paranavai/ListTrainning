import 'package:list_training/src/model/entidades/ficha_treino.dart';

class Treino {
  dynamic id;
  dynamic idFichaTreino;
  late String nome;
  late String dataCadastro;
  late String validade;

  Treino({
    this.id,
    required this.nome,
    required this.dataCadastro,
    required this.validade,
    required this.idFichaTreino,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'idFichaTreino': idFichaTreino,
      'dataCadastro': dataCadastro,
      'validade': validade
    };
  }

  static Treino fromJson(Map<String, dynamic> json) {
    return Treino(
        id: json['id'],
        nome: json['nome'],
        idFichaTreino: json['idFichaTreino'],
        dataCadastro: json['dataCadastro'],
        validade: json['validade']);
  }
}
