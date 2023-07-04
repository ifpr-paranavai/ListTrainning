import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/components/button.dart';
import 'package:list_training/src/view/components/campo_input.dart';
import 'package:list_training/src/view/pages/check_page.dart';

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

  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CheckPage()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Cadastro'),
        ),
        body: ListView(
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
                icone: Icon(Icons.one_k),
                rotulo: 'Cadastrar',
                cor: Colors.blue,
                borda: StadiumBorder(),
                acao: cadastrar)
          ],
        ));
  }
}
