import 'package:list_training/src/model/entidades/pessoa.dart';

class Personal extends Pessoa {
  late String? cref;
  late DateTime? validadeCref;

  Personal(
      {super.id,
      super.nome,
      super.cpf,
      super.dataNascimento,
      super.telefone,
      super.endereco,
      super.status,
      super.email,
      super.senha,
      super.dataCadastro,
      this.cref,
      this.validadeCref});

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
      'dataCadastro': dataCadastro,
      'cref': cref,
      'validadeCref': validadeCref
    };
  }

  static Personal fromJson(Map<String, dynamic> json) {
    return Personal(
        id: json['id'],
        nome: json['nome'],
        cpf: json['cpf'],
        cref: json['cref'],
        dataCadastro: json['dataCadastro'],
        dataNascimento: json['dataNascimento'],
        email: json['email'],
        endereco: json['endereco'],
        senha: json['senha'],
        status: json['status'],
        telefone: json['telefone'],
        validadeCref: json['validadeCref']);
  }
}
