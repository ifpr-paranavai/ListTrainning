import 'package:list_training/src/model/entidades/musculo.dart';

class MusculoTrabalhado {
  dynamic id;
  dynamic idMusculo;
  late int prioridade;

  MusculoTrabalhado(
      {this.id, required this.idMusculo, required this.prioridade});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'musculo': idMusculo,
      'prioridade': prioridade,
    };
  }

  static MusculoTrabalhado fromJson(Map<String, dynamic> json) {
    return MusculoTrabalhado(
        id: json['id'],
        idMusculo: json['idMusculo'],
        prioridade: json['prioridade']);
  }
}
