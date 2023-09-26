import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_training/src/model/entidades/personal.dart';
import 'package:list_training/src/model/firebase/personal_firebase.dart';
import 'package:list_training/src/view/components/campo_input.dart';
import 'package:list_training/src/view/components/drawer.dart';

class PersonalDetail extends StatefulWidget {
  const PersonalDetail({super.key});

  @override
  State<PersonalDetail> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _statusController = TextEditingController();
  final _crefController = TextEditingController();
  final _validadeCrefController = TextEditingController();
  DateTime dataCadastro = DateTime.now();
  PersonalFirebase personalFirebase = PersonalFirebase();
  DateFormat format = DateFormat('dd/MM/yyyy');
  String retornoValidador = 'Campo obrigatório';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerExample(),
      body: Center(
        child: ListView(children: [
          FloatingActionButton(
            onPressed: () {
              _showModalBottomSheet(context);
            },
            child: Text('Cadastrar Personal'),
          )
        ]),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        // Conteúdo do modal
        return formPersonal();
      },
    );
  }

  Widget formPersonal() {
    return Scaffold(
      body: Center(
        child: Form(
          child: ListView(
            children: [
              const SizedBox(
                child: Center(
                  child: Text(
                    'Cadastro de Personal',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Nome',
                  tipo: TextInputType.name,
                  controller: _nomeController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'CPF',
                  tipo: TextInputType.number,
                  controller: _cpfController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Data Nascimento',
                  tipo: TextInputType.datetime,
                  controller: _dataNascimentoController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Cref',
                  tipo: TextInputType.number,
                  controller: _crefController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Email',
                  tipo: TextInputType.emailAddress,
                  controller: _emailController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Senha',
                  tipo: TextInputType.visiblePassword,
                  controller: _passwordController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Endereço',
                  tipo: TextInputType.text,
                  controller: _enderecoController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Status',
                  tipo: TextInputType.text,
                  controller: _statusController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Telefone',
                  tipo: TextInputType.number,
                  controller: _telefoneController,
                  retornoValidador: retornoValidador),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Validade Cref',
                  tipo: TextInputType.datetime,
                  controller: _validadeCrefController,
                  retornoValidador: retornoValidador),
              SizedBox(
                  width: 30,
                  child: TextButton(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_task_rounded),
                        Text('Salvar'),
                      ],
                    ),
                    onPressed: () {
                      personalFirebase.addPersonal(
                          cPersonal: Personal(
                        cpf: _cpfController.text,
                        cref: _crefController.text,
                        dataNascimento:
                            format.parse(_dataNascimentoController.text),
                        email: _emailController.text,
                        endereco: _enderecoController.text,
                        nome: _nomeController.text,
                        senha: _passwordController.text,
                        status: _statusController.text,
                        telefone: _telefoneController.text,
                        validadeCref:
                            format.parse(_validadeCrefController.text),
                      ));
                      Navigator.pop(context);
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
