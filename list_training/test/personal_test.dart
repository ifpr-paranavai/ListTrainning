/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_training/firebase_options.dart';
import 'package:list_training/src/model/entidades/personal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late Personal personal;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  personal = Personal(
      nome: 'nome',
      cpf: 'cpf',
      dataNascimento: DateTime.now(),
      telefone: 'telefone',
      endereco: 'endereco',
      status: 'status',
      email: 'email',
      senha: 'senha',
      dataCadastro: DateTime.now(),
      cref: 'cref',
      validadeCref: DateTime.now());
  test('Salvar personal', () {
    Future<String> resposta = personal.salvarPersonal(personal);
    expect(resposta, 'Treino adicionado com sucesso!');
  });
}*/
