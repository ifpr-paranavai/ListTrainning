class Pessoa {
  dynamic id;
  late String nome;
  late String cpf;
  late DateTime dataNascimento;
  late String telefone;
  late String endereco;
  late String status;
  late DateTime dataCadastro;
  late String email;
  late String senha;

  Pessoa(
      {required this.id,
      required this.nome,
      required this.cpf,
      required this.telefone,
      required this.dataNascimento,
      required this.endereco,
      required this.status,
      required this.email,
      required this.senha,
      required this.dataCadastro});
}
