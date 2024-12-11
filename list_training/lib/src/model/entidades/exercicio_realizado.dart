class ExercicioRealizado {
  dynamic id;
  dynamic idTreinoRealizado;
  late String nome;
  late double peso;
  late int repeticao;
  late DateTime dataRealizacao;

  ExercicioRealizado(
      {this.id,
      required this.nome,
      required this.peso,
      required this.repeticao,
      required this.dataRealizacao});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTreinoRealizado': idTreinoRealizado,
      'nome': nome,
      'peso': peso,
      'repeticao': repeticao,
      'dataRealizacao': dataRealizacao
    };
  }

  static ExercicioRealizado fromJson(Map<String, dynamic> json) {
    return ExercicioRealizado(
        id: json['id'],
        nome: json['nome'],
        peso: json['peso'],
        repeticao: json['repeticao'],
        dataRealizacao: json['dataRealizacao']);
  }
}
