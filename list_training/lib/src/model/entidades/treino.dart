import 'package:list_training/src/model/entidades/ficha_treino.dart';
import 'package:list_training/src/model/entidades/itens_treino.dart';

class Treino {
  dynamic id;
  late DateTime dataCadastro;
  late int validade;
  late FichaTreino fichaTreino;
  late ItensTreino itensTreino;

  Treino({
    this.id,
    required this.dataCadastro,
    required this.validade,
    required this.fichaTreino,
    required this.itensTreino
  });
}
