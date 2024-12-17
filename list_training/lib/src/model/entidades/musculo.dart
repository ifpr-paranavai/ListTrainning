
class Musculo {
  dynamic id;
  dynamic idGrupoMuscular;
  late String nome;
  late String descricao;

  Musculo(
      {this.id,
      required this.descricao,
      required this.idGrupoMuscular,
      required this.nome});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'idGrupoMuscular': idGrupoMuscular,
      'nome': nome
    };
  }

  static Musculo fromJson(Map<String, dynamic> json) {
    return Musculo(
        id: json['id'],
        idGrupoMuscular: json['idGrupoMuscular'],
        descricao: json['descricao'],
        nome: json['nome']);
  }
}
