class ItensTreino {
  dynamic id;
  dynamic idExercicio;
  dynamic idTreino;
  late int sequncia;
  late double peso;
  late int repeticao;

  ItensTreino(
      {this.id,
      required this.idExercicio,
      required this.idTreino,
      required this.peso,
      required this.repeticao,
      required this.sequncia});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peso': peso,
      'idExercicio': idExercicio,
      'repeticao': repeticao,
      'sequncia': sequncia
    };
  }

  static ItensTreino fromJson(Map<String, dynamic> json) {
    return ItensTreino(
        id: json['id'],
        idExercicio: json['idExercicio'],
        idTreino: json['idExercicio'],
        peso: json['peso'],
        repeticao: json['repeticao'],
        sequncia: json['sequncia']);
  }
}
