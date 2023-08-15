import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_training/src/model/entidades/personal.dart';

class PersonalFirebase {
  final root = FirebaseFirestore.instance.collection('personal');

  Future addPersonal({required Personal cPersonal}) async {
    final docPersonal = root.doc();
<<<<<<< HEAD
    final doc = docPersonal.collection('personal').doc();
    final personal = Personal(
            id: doc.id,
=======

    final personal = Personal(
            id: docPersonal.id,
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
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

<<<<<<< HEAD
    await doc
=======
    await docPersonal
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
        .set(personal)
        .then((value) => print('Usuário adicionado com sucesso!'))
        .catchError((error) => print('Erro ao adicionar o usuário: $error'));
  }
}
