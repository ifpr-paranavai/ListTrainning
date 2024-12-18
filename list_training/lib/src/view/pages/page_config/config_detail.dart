import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/drawer.dart';

class ConfiguracaoPage extends StatelessWidget {
  final User? usuario = FirebaseAuth.instance.currentUser;

  ConfiguracaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text('Configurações', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple, // Cor do AppBar
      ),
      drawer: const DrawerExample(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Exibe o ícone do usuário
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nome do usuário
                    Text(
                      usuario?.displayName ?? 'Nome não disponível',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // E-mail do usuário
                    Text(
                      usuario?.email ?? 'E-mail não disponível',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Botão de logout
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // Redireciona para a página de login ou qualquer outra ação
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Cor do botão
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Sair',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            // Informações no rodapé
            const Column(
              children: [
                Divider(),
                SizedBox(height: 10),
                Text(
                  'Versão 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Desenvolvido por: Eduardo Dias & Francisco Gabriel',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
