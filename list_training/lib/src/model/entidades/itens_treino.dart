class ItensTreino {
  dynamic id;
  dynamic idExercicio;
  late int sequncia;
  late double peso;
  late int repeticao;

  ItensTreino(
      {this.id,
      required this.peso,
      required this.idExercicio,
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
        peso: json['peso'],
        idExercicio: json['idExercicio'],
        repeticao: json['repeticao'],
        sequncia: json['sequncia']);
  }
}
