import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importando o pacote intl
import 'package:list_training/src/model/firebase/treino_realizado_firebase.dart';
import 'package:list_training/src/model/entidades/treino_realizado.dart';
import 'package:list_training/src/model/entidades/exercicio_realizado.dart';

class TreinosRealizadosDetail extends StatelessWidget {
  final TreinoRealizadoFirebase treinoRealizadoFirebase =
      TreinoRealizadoFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinos Realizados',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<List<TreinoRealizado>>(
        stream: treinoRealizadoFirebase.readTreinosRealizadosDoUsuarioLogado(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os treinos.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhum treino realizado encontrado.'));
          }

          final treinosRealizados = snapshot.data!;

          // Ordenar os treinos por data (do mais recente para o mais antigo)
          treinosRealizados.sort((a, b) => b.data.compareTo(a.data));

          return ListView.builder(
            itemCount: treinosRealizados.length,
            itemBuilder: (context, index) {
              final treino = treinosRealizados[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treino.nome,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Data: ${DateFormat('dd/MM/yyyy').format(treino.data)}', // Formata a data no estilo brasileiro
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      // Seção expandível para os exercícios realizados
                      ExpansionTile(
                        title: const Text(
                          'Exercícios Realizados',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          _buildExerciciosRealizados(
                              treino.exerciciosRealizados!),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Função para construir a lista de exercícios realizados dentro de um treino
  Widget _buildExerciciosRealizados(
      List<ExercicioRealizado> exerciciosRealizados) {
    return ListView.builder(
      shrinkWrap: true, // Impede que a lista ocupe todo o espaço disponível
      physics:
          const NeverScrollableScrollPhysics(), // Impede a rolagem da lista interna
      itemCount: exerciciosRealizados.length,
      itemBuilder: (context, index) {
        final exercicio = exerciciosRealizados[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercicio.nome,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${exercicio.sequncia} séries - ${exercicio.repeticao} repetições - Pesos: ${exercicio.peso}kg',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
