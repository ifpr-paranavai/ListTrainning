import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/personal.dart';

class PersonalFirebase {
  final root = FirebaseFirestore.instance.collection('personal');

  Future addPersonal({required Personal cPersonal}) async {
    final docPersonal = root.doc();

    final personal = Personal(
            id: docPersonal.id,
            nome: cPersonal.nome,
            cpf: cPersonal.cpf,
            cref: cPersonal.cref,
            dataCadastro: DateTime.now(),
            dataNascimento: cPersonal.dataNascimento,
            email: cPersonal.email,
            endereco: cPersonal.endereco,
            senha: cPersonal.senha,
            status: cPersonal.status,
            telefone: cPersonal.telefone,
            validadeCref: cPersonal.validadeCref)
        .toJson();

    await docPersonal
        .set(personal)
        .then((value) => print('Usuário adicionado com sucesso!'))
        .catchError((error) => print('Erro ao adicionar o usuário: $error'));
  }
}
