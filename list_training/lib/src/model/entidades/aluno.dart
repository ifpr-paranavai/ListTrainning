import 'package:list_training/src/model/entidades/pessoa.dart';

class Aluno extends Pessoa {
  Aluno({
    super.id,
    super.nome,
    super.cpf,
    super.dataNascimento,
    super.telefone,
    super.endereco,
    super.status,
    super.email,
    super.senha,
    super.dataCadastro,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataCadastro,
      'telefone': telefone,
      'endereco': endereco,
      'status': status,
      'email': email,
      'senha': senha,
      'dataCadastro': dataCadastro
    };
  }

  static Aluno fromJson(Map<String, dynamic> json) {
    return Aluno(
        id: json['id'],
        nome: json['nome'],
        cpf: json['cpf'],
        dataCadastro: json['dataCadastro'],
        dataNascimento: json['dataNascimento'],
        email: json['email'],
        endereco: json['endereco'],
        senha: json['senha'],
        status: json['status'],
        telefone: json['telefone']);
  }
}
