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
}
