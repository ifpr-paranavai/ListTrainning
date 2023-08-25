class GrupoMuscular {
  dynamic id;
  late String nome;
  late String? descricao;

  GrupoMuscular({this.id, this.descricao, required this.nome});

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'nome': nome, 
      'descricao': descricao
      };
  }

  static GrupoMuscular fromJson(Map<String, dynamic> json) {
    return GrupoMuscular(
        id: json['id'],
        nome: json['nome'],
        descricao: json['descricao']);
  }
}
