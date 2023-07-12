class Pessoa {
  dynamic id;
  late String? nome;
  late String? cpf;
  late DateTime? dataNascimento;
  late String? telefone;
  late String? endereco;
  late String? status;
  late DateTime? dataCadastro;
  late String? email;
  late String? senha;

  Pessoa(
      {this.id,
      this.nome,
      this.cpf,
      this.telefone,
      this.dataNascimento,
      this.endereco,
      this.status,
      this.email,
      this.senha,
      this.dataCadastro});
}
