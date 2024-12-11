import 'package:flutter/material.dart';
import 'package:list_training/src/view/components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: const DrawerExample(),
        body: SafeArea(
          child: Column(
            children: [
              // Título de "Treinos"
              Container(
                color: Colors.amber,
                height: 100,
                child: const Center(
                  child: Text(
                    'Treinos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Grid de Cards
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 colunas
                    crossAxisSpacing: 8.0, // Espaçamento entre as colunas
                    mainAxisSpacing: 8.0, // Espaçamento entre as linhas
                    childAspectRatio:
                        1.0, // Proporção de cada card (ajusta o tamanho)
                  ),
                  itemCount: 4, // Número total de cards
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4.0,
                      color: Colors.blueGrey[100],
                      child: Center(
                        child: Text(
                          'Card ${index + 1}', // Texto para identificação do card
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
