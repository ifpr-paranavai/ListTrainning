class Exercicio {
  dynamic id;
  late String nome;
  late String? descricao;
  late String? urlExplicao;
  dynamic idGrupoMuscular;

  Exercicio({
    this.id,
    required this.nome,
    this.descricao,
    this.urlExplicao,
    required this.idGrupoMuscular,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'urlExplicao': urlExplicao,
      'idGrupoMuscular': idGrupoMuscular,
    };
  }

  static Exercicio fromJson(Map<String, dynamic> json) {
    return Exercicio(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      urlExplicao: json['urlExplicao'],
      idGrupoMuscular: json['idGrupoMuscular'],
    );
  }
}
