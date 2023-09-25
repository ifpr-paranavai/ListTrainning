import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/components/button.dart';
import 'package:list_training/src/view/components/campo_input.dart';
import 'package:list_training/src/view/pages/check_page.dart';
import 'package:list_training/src/view/pages/login_page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  cadastrar({required String senha, required String email}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);
      if (userCredential != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Crie uma senha nais forte'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail ja cadastrado'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  SnackBar senhaPequena() {
    return const SnackBar(
      content: Text('Senha precisa ser maior'),
      backgroundColor: Colors.redAccent,
    );
  }

  SnackBar senhaSemNumero() {
    return const SnackBar(
      content: Text('Senha precisa ter ao menos um numero'),
      backgroundColor: Colors.redAccent,
    );
  }

  SnackBar senhaSemLetra() {
    return const SnackBar(
      content: Text('Senha precisa ter ao menos uma letra'),
      backgroundColor: Colors.redAccent,
    );
  }

  SnackBar senhaSemMaiuscula() {
    return const SnackBar(
      content: Text('Senha precisa ter uma letra maiuscula'),
      backgroundColor: Colors.redAccent,
    );
  }

  bool senhaValida({required String senha}) {
    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(senhaPequena());
      return false;
    }

    bool temLetra = false;
    for (int i = 0; i < senha.length; i++) {
      if (senha[i].contains(RegExp(r'[a-zA-Z]'))) {
        temLetra = true;
        break;
      }
    }
    if (!temLetra) {
      ScaffoldMessenger.of(context).showSnackBar(senhaSemLetra());
      return false;
    }

    bool temNumero = false;
    for (int i = 0; i < senha.length; i++) {
      if (senha[i].contains(RegExp(r'[0-9]'))) {
        temNumero = true;
        break;
      }
    }
    if (!temNumero) {
      ScaffoldMessenger.of(context).showSnackBar(senhaSemNumero());
      return false;
    }

    bool temMaiuscula = false;
    for (int i = 0; i < senha.length; i++) {
      if (senha[i].contains(RegExp(r'[A-Z]'))) {
        temMaiuscula = true;
        break;
      }
    }
    if (!temMaiuscula) {
      ScaffoldMessenger.of(context).showSnackBar(senhaSemMaiuscula());
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Cadastro'),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Nome',
                  tipo: TextInputType.name,
                  controller: _nomeController,
                  retornoValidador: 'retornoValidador'),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Email',
                  tipo: TextInputType.emailAddress,
                  controller: _emailController,
                  retornoValidador: 'retornoValidador'),
              CampoInput(
                  visibilidade: false,
                  rotulo: 'Senha',
                  tipo: TextInputType.visiblePassword,
                  controller: _passwordController,
                  retornoValidador: 'retornoValidador'),
              Button(
                icone: const Icon(Icons.one_k),
                rotulo: 'Cadastrar',
                cor: Colors.blue,
                borda: const StadiumBorder(),
                acao: () {
                  var validar = formKey.currentState?.validate();
                  if (validar == true) {
                    if (senhaValida(senha: _passwordController.text)) {
                      cadastrar(
                          email: _emailController.text,
                          senha: _passwordController.text);
                    }
                  }
                },
              )
            ],
          ),
        ));
  }
}
