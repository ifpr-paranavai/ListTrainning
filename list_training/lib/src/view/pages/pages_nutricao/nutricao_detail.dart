import 'package:flutter/material.dart';

import '../../components/drawer.dart';

class NutricaoPage extends StatelessWidget {
  const NutricaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nutrição', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple, // Cor do AppBar
      ),
      drawer: const DrawerExample(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mensagem centralizada
              Text(
                'Trabalhos Futuros',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Cor do texto
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Espaçamento abaixo da mensagem

              // Ícone grande de um livro (símbolo de TCC)
              Icon(
                Icons.book, // Ícone de livro
                size: 100, // Tamanho grande do ícone
                color: Colors.deepPurple, // Cor do ícone
              ),
              SizedBox(height: 20), // Espaçamento abaixo do ícone

              // CircularProgressIndicator (ícone de carregamento)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.deepPurple), // Cor do círculo
              ),
            ],
          ),
        ),
      ),
    );
  }
}
