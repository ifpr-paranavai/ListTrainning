class Exercicio {
  dynamic id;
  late String nome;
  late String? descricao;
  late String? urlExplicao;

  Exercicio({this.id, required this.nome, this.descricao, this.urlExplicao});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'urlExplicao': urlExplicao,
    };
  }

  static Exercicio fromJson(Map<String, dynamic> json) {
    return Exercicio(
        id: json['id'],
        nome: json['nome'],
        descricao: json['descricao'],
        urlExplicao: json['urlExplicao']);
  }
}
