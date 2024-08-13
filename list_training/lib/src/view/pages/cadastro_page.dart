import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/components/button.dart';
import 'package:list_training/src/view/components/campo_input.dart';
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

  Future<void> cadastrar({
    required String senha,
    required String email,
    required String nome,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);

      // Atualiza o nome do usuário (displayName)
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(nome);

        // Força o recarregamento do perfil do usuário para garantir que o displayName esteja atualizado
        await userCredential.user!.reload();
      }

      // Redireciona para a página de login após o cadastro
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String mensagemErro;
      if (e.code == 'weak-password') {
        mensagemErro = 'Crie uma senha mais forte';
      } else if (e.code == 'email-already-in-use') {
        mensagemErro = 'E-mail já cadastrado';
      } else {
        mensagemErro = 'Erro desconhecido';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagemErro),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  bool senhaValida({required String senha}) {
    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha precisa ser maior'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(senha)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha precisa ter ao menos uma letra'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (!RegExp(r'[0-9]').hasMatch(senha)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha precisa ter ao menos um número'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (!RegExp(r'[A-Z]').hasMatch(senha)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha precisa ter uma letra maiúscula'),
          backgroundColor: Colors.redAccent,
        ),
      );
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
          padding: const EdgeInsets.all(16.0),
          children: [
            CampoInput(
              visibilidade: false,
              rotulo: 'Nome',
              tipo: TextInputType.name,
              controller: _nomeController,
              retornoValidador: 'Preencha o campo',
            ),
            CampoInput(
              visibilidade: false,
              rotulo: 'Email',
              tipo: TextInputType.emailAddress,
              controller: _emailController,
              retornoValidador: 'Preencha o campo',
            ),
            CampoInput(
              visibilidade: false,
              rotulo: 'Senha',
              tipo: TextInputType.visiblePassword,
              controller: _passwordController,
              retornoValidador: 'Preencha o campo',
            ),
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
                      senha: _passwordController.text,
                      nome: _nomeController.text,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
