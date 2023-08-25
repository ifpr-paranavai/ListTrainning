class ExercicioRealizado {
  dynamic id;
  dynamic idExercicio;
  late double peso;
  late int repeticao;
  late String tempoDescanco;

  ExercicioRealizado(
      {this.id,
      this.idExercicio,
      required this.peso,
      required this.repeticao,
      required this.tempoDescanco});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idExercicio': idExercicio,
      'peso': peso,
      'repeticao': repeticao,
      'tempoDescanco': tempoDescanco
    };
  }

  static ExercicioRealizado fromJson(Map<String, dynamic> json) {
    return ExercicioRealizado(
        id: json['id'],
        idExercicio: json['idExercicio'],
        peso: json['peso'],
        repeticao: json['repeticao'],
        tempoDescanco: json['tempoDescanco']);
  }
}
