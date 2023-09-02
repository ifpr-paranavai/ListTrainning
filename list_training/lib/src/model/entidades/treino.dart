import 'package:list_training/src/model/entidades/ficha_treino.dart';
import 'package:list_training/src/model/entidades/itens_treino.dart';

class Treino {
  dynamic id;
  dynamic idItensTreino;
  dynamic idFichaTreino;
  late DateTime dataCadastro;
  late int validade;
  


  Treino({
    this.id,
    required this.dataCadastro,
    required this.validade,
    required this.idFichaTreino,
    required this.idItensTreino
  });


   Map<String, dynamic> toJson() {
    return {'id': id, 'idItensTreino': idItensTreino, 'idFichaTreino': idFichaTreino, 'dataCadastro': dataCadastro,
    'validade': validade
    };
  }

  static Treino fromJson(Map<String, dynamic> json) {
    return Treino(
        id: json['id'],
        idItensTreino: json['idItensTreino'],
        idFichaTreino: json['idFichaTreino'],
        dataCadastro: json['dataCadastro'],
        validade: json['validade']);
  }
}
