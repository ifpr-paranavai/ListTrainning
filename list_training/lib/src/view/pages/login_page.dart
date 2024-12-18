import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/pages/cadastro_page.dart';
import 'package:list_training/src/view/pages/home_page.dart';
import 'package:list_training/src/view/pages/pages_treino/treino_detail.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensagemErro;
      if (e.code == 'user-not-found') {
        mensagemErro = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        mensagemErro = 'Senha incorreta';
      } else {
        mensagemErro = 'Erro ao realizar login';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagemErro),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
            Icon(Icons.login, color: Colors.white),
            SizedBox(width: 8),
            Text('Login', style: TextStyle(color: Colors.white)),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nome do App (antes do Card branco)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "List Training",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Card com os inputs
                Card(
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
                          const Text(
                            "Bem-vindo de volta!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                  .hasMatch(value)) {
                                return 'Email inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              if (value.length < 6) {
                                return 'Senha muito curta';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                            onPressed: () {
                              if (formKey.currentState?.validate() == true) {
                                login();
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CadastroPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person_add,
                                color: Colors.deepPurple),
                            label: const Text(
                              'Criar conta',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
