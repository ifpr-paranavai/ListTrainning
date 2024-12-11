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

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(nome);
        await userCredential.user!.reload();
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person_add, color: Colors.white),
            SizedBox(width: 8),
            Text('Cadastro', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CampoInput(
                      visibilidade: false,
                      rotulo: 'Nome',
                      tipo: TextInputType.name,
                      controller: _nomeController,
                      retornoValidador: 'Preencha o campo',
                      icone: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    CampoInput(
                      visibilidade: false,
                      rotulo: 'Email',
                      tipo: TextInputType.emailAddress,
                      controller: _emailController,
                      retornoValidador: 'Preencha o campo',
                      icone: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    CampoInput(
                      visibilidade: true,
                      rotulo: 'Senha',
                      tipo: TextInputType.visiblePassword,
                      controller: _passwordController,
                      retornoValidador: 'Preencha o campo',
                      icone: Icons.lock,
                    ),
                    const SizedBox(height: 24),
                    Button(
                      icone: const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.white,
                      ),
                      rotulo: 'Cadastrar',
                      cor: Colors.deepPurple,
                      borda: const StadiumBorder(),
                      acao: () {
                        if (formKey.currentState?.validate() == true &&
                            senhaValida(senha: _passwordController.text)) {
                          cadastrar(
                            email: _emailController.text,
                            senha: _passwordController.text,
                            nome: _nomeController.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
