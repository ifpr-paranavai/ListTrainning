import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_training/src/model/firebase/treino_firebase.dart';
import 'package:list_training/src/model/entidades/treino.dart';
import 'package:list_training/src/view/components/campo_input.dart';
import 'package:list_training/src/view/pages/home_page.dart';

class TreinoDetail extends StatefulWidget {
  const TreinoDetail({super.key});

  @override
  State<TreinoDetail> createState() => _TreinoDetailState();
}

class _TreinoDetailState extends State<TreinoDetail> {
  TreinoFirebase treinoFirebase = TreinoFirebase();
  final _nomeController = TextEditingController();
  final _validadeController = TextEditingController();
  String retornoValidador = 'Campo obrigatório';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detalhes do Treino'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Treino>>(
                stream: treinoFirebase.readTreinosDoUsuarioLogado(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Treino>> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Algo deu errado"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("Nenhum Treino encontrado"));
                  }

                  // Ordenando os treinos por data de cadastro
                  final treinosOrdenados = snapshot.data!
                    ..sort((a, b) => a.dataCadastro.compareTo(b.dataCadastro));

                  return ListView(
                    children: treinosOrdenados.map((Treino treino) {
                      return InkWell(
                        onTap: () {
                          // Navegar para a tela de exercícios, passando o treino como parâmetro
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()
                                //ExerciciosPage(treino: treino),
                                ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treino.nome,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                    'Data de Cadastro: ${treino.dataCadastro}'),
                                Text('Validade: ${treino.validade}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, Treino treino) {}

  void _confirmDelete(BuildContext context, String treinoId) {}

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: formTreino(),
            ),
          ],
        );
      },
    );
  }

  Widget formTreino() {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 50, // Definindo altura para o cabeçalho
            child: Center(
              child: Text(
                'Cadastro de Exercicio',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          CampoInput(
              visibilidade: false,
              rotulo: 'Nome',
              tipo: TextInputType.name,
              controller: _nomeController,
              retornoValidador: retornoValidador),
          CampoInput(
              visibilidade: false,
              rotulo: 'Mese validade',
              tipo: TextInputType.number,
              controller: _validadeController,
              retornoValidador: retornoValidador),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_task_rounded),
                  SizedBox(width: 8), // Espaçamento entre ícone e texto
                  Text('Salvar'),
                ],
              ),
              onPressed: () {
                treinoFirebase.addTreinoParaUsuarioLogado(
                  cTreino: Treino(
                      nome: _nomeController.text,
                      dataCadastro:
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                      validade: _validadeController.text,
                      idFichaTreino: 1),
                );

                _nomeController.clear();
                _validadeController.clear();
              },
            ),
          )
        ],
      ),
    );
  }
}
