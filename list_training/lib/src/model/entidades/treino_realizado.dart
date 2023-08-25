import 'package:list_training/src/model/entidades/agenda.dart';

class TreinoRealizado {
  dynamic id;
  dynamic idAgenda;
  late DateTime data;
  late bool presente;


  TreinoRealizado({
    this.id,
    required this.data,
    required this.idAgenda,
    required this.presente
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idAgenda': idAgenda,
      'data': data,
      'presente': presente
    };
  }

  static TreinoRealizado fromJson(Map<String, dynamic> json) {
    return TreinoRealizado(
        id: json['id'],
        idAgenda: json['idAgenda'],
        data: json['data'],
        presente: json['presente']);
  }
}
