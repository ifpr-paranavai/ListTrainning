import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_training/src/model/firebase/treino_firebase.dart';
import 'package:list_training/src/model/entidades/treino.dart';
import 'package:list_training/src/view/components/campo_input.dart';
import '../../components/drawer.dart';
import '../pages_itens_treino/itens_treino_detail.dart';

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
        title: const Text(
          'Meus Treinos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: DrawerExample(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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

                  return ListView.builder(
                    itemCount: treinosOrdenados.length,
                    itemBuilder: (context, index) {
                      final treino = treinosOrdenados[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItensTreinoDetail(treino: treino),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Nome do Treino
                                    Text(
                                      treino.nome,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Data de Cadastro e Validade com Ícones
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Cadastro: ${treino.dataCadastro}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.event,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Validade: ${treino.validade} meses',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Botão de navegação para detalhes
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text("Ver detalhes"),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItensTreinoDetail(
                                                    treino: treino),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepPurple,
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
              padding: const EdgeInsets.all(16.0),
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
          const SizedBox(height: 20), // Espaço acima do título
          const Center(
            child: Text(
              'Treino',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Combina com o tema
              ),
              textAlign: TextAlign.center, // Garante alinhamento central
            ),
          ),
          const SizedBox(height: 20), // Espaço abaixo do título
          CampoInput(
            visibilidade: false,
            rotulo: 'Nome',
            tipo: TextInputType.name,
            controller: _nomeController,
            retornoValidador: retornoValidador,
          ),
          CampoInput(
            visibilidade: false,
            rotulo: 'Mês de validade',
            tipo: TextInputType.number,
            controller: _validadeController,
            retornoValidador: retornoValidador,
          ),
          const SizedBox(height: 20), // Espaço entre os campos e o botão
          ElevatedButton.icon(
            icon: const Icon(Icons.add_task_rounded, color: Colors.white),
            label: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple, // Cor do botão de salvar
              shape: const StadiumBorder(), // Estilo arredondado
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              treinoFirebase.addTreinoParaUsuarioLogado(
                cTreino: Treino(
                  nome: _nomeController.text,
                  dataCadastro: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  validade: _validadeController.text,
                  idFichaTreino: 1,
                ),
              );

              _nomeController.clear();
              _validadeController.clear();
              Navigator.pop(context); // Fecha o modal após salvar
            },
          ),
          const SizedBox(height: 10), // Espaço final para equilíbrio visual
        ],
      ),
    );
  }
}
