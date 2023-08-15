import 'package:list_training/src/model/aluno.dart';
import 'package:list_training/src/model/personal.dart';

enum DiaSemana {
  
  SEGUNDA('Segunda-feira'),
  TERCA('Terça-feira'),
  QUARTA('Quarta-feira'),
  QUINTA('Quinta-feira'),
  SEXTA('Sexta-feira'),
  SABADO('Sábado'),
  DOMINGO('Domingo');

  final String value;

  const DiaSemana(this.value);
}

class Agenda {
  dynamic id;
  late DiaSemana diaSemana;
  late DateTime horaInicial;
  late DateTime tempoTreino;
  late Aluno aluno;
  late Personal personal;
}
