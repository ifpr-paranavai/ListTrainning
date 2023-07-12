import 'package:list_training/src/model/entidades/pessoa.dart';

class Aluno extends Pessoa {
  Aluno({
    id,
    required nome,
    required cpf,
    required dataNascimento,
    required telefone,
    required endereco,
    required status,
    required email,
    required senha,
    required dataCadastro,
  }) : super(
          id: id,
          nome: nome,
          cpf: cpf,
          telefone: telefone,
          dataNascimento: dataNascimento,
          endereco: endereco,
          status: status,
          senha: senha,
          dataCadastro: dataCadastro,
          email: email,
        );
}
