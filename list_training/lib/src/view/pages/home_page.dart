import 'package:flutter/material.dart';
import 'package:list_training/src/view/components/drawer.dart';
import 'package:list_training/src/view/pages/page_config/config_detail.dart';
import 'package:list_training/src/view/pages/pages_nutricao/nutricao_detail.dart';
import 'package:list_training/src/view/pages/pages_treino/treino_detail.dart';
import 'package:list_training/src/view/pages/pages_treino_realizado/treino_realizado_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _gridItems = [
    {
      'title': 'Treinos',
      'icon': Icons.fitness_center,
      'page': const TreinoDetail(),
    },
    {
      'title': 'Nutrição',
      'icon': Icons.restaurant,
      'page': NutricaoPage(),
    },
    {
      'title': 'Treinos Realizados',
      'icon': Icons.bar_chart,
      'page': TreinosRealizadosDetail(),
    },
    {
      'title': 'Configurações',
      'icon': Icons.settings,
      'page': ConfiguracaoPage(),
    },
  ];

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
                color: Colors.deepPurple,
                height: 100,
                child: const Center(
                  child: Text(
                    'Cuide do seu corpo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                  itemCount: _gridItems.length,
                  itemBuilder: (context, index) {
                    final item = _gridItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => item['page']),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'],
                              size: 40.0,
                              color: Colors.blueGrey[700],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
