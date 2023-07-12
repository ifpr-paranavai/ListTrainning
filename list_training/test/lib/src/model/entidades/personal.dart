import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:list_training/src/model/entidades/pessoa.dart';

class Personal extends Pessoa {
  late String cref;
  late DateTime validadeCref;

  Personal(
      {id,
      required nome,
      required cpf,
      required dataNascimento,
      required telefone,
      required endereco,
      required status,
      required email,
      required senha,
      required dataCadastro,
      required this.cref,
      required this.validadeCref})
      : super(
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

  Future<String> salvarPersonal(Personal personal) async {
    try {
      CollectionReference personalRef =
          FirebaseFirestore.instance.collection('personal');
      await personalRef.add({
        'id': personal.id,
        'nome': personal.nome,
        'cpf': personal.cpf,
        'telefone': personal.telefone,
        'dataNascimento': personal.dataNascimento,
        'endereco': personal.endereco,
        'status': personal.status,
        'senha': personal.senha,
        'dataCadastro': DateTime.now(),
        'email': personal.email,
        'cref': personal.cref,
        'validadeCref': personal.validadeCref
      });
      return 'Treino adicionado com sucesso!';
    } catch (e) {
      return ('Erro ao adicionar treino: $e');
    }
  }
}
