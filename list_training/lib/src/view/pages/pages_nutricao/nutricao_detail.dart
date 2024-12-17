import 'package:flutter/material.dart';

import '../../components/drawer.dart';

class NutricaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nutrição', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors
            .deepPurple, // Cor do AppBar, pode ajustar conforme necessário
      ),
      drawer: DrawerExample(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  color:
                      Colors.black, // Cor do texto, ajuste conforme seu estilo
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Espaçamento abaixo da mensagem
              // Se quiser adicionar mais conteúdo, pode adicionar outros widgets aqui
            ],
          ),
        ),
      ),
    );
  }
}
