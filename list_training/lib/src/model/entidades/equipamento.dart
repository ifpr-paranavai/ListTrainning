class Equipamento {
  dynamic id;
  late String nome;
  late String? desricao;
  late String? urlExplicacao;

  Equipamento({this.id, required this.nome, this.desricao, this.urlExplicacao});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': desricao,
      'urlExplicacao': urlExplicacao
    };
  }

  static Equipamento fromJson(Map<String, dynamic> json) {
    return Equipamento(
        id: json['id'],
        nome: json['nome'],
        desricao: json['desricao'],
        urlExplicacao: json['urlExplicacao']);
  }
}
