import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:list_training/src/view/components/campo_text_login.dart';
import 'package:list_training/src/view/pages/cadastro_page.dart';

import '../components/bottom_navigation.dart';
import '../components/button_entrar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final formeKey = GlobalKey<FormState>();

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationBarExample(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não encontrado'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha incorreta'),
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
        title: const Text('Login'),
      ),
      body: Container(
        child: Form(
          key: formeKey,
          child: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xfff45d27),
                      Color(0xFFf5851f),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    //bottomRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  ),
                ),
                child: const SizedBox(
                    //child: Image.asset('assets/listLogo.png'),
                    ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 62),
                child: Column(
                  children: [
                    CampoTextoLogin(
                        icone: const Icon(Icons.email),
                        visibilidade: false,
                        rotulo: 'Email',
                        tipo: TextInputType.emailAddress,
                        controller: _emailController,
                        retornoValidador: 'Campo obrigatório'),
                    const SizedBox(
                      height: 32,
                    ),
                    CampoTextoLogin(
                        icone: const Icon(Icons.vpn_key),
                        visibilidade: true,
                        rotulo: 'Senha',
                        tipo: TextInputType.visiblePassword,
                        controller: _passwordController,
                        retornoValidador: 'Campo obrigatório'),
                    const Spacer(),
                    ButtonEntrar(
                      rotulo: 'Login',
                      icone: const Icon(Icons.arrow_forward_ios_outlined),
                      cor: Colors.amber,
                      borda: StadiumBorder(),
                      acao: () {
                        var validar = formeKey.currentState?.validate();
                        if (validar == true) {
                          login();
                        }
                      },
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CadastroPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Criar conta'),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
