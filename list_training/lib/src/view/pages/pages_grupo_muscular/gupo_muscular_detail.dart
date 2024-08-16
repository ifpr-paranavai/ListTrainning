import 'package:flutter/material.dart';
import 'package:list_training/src/model/entidades/grupo_muscular.dart';
import 'package:list_training/src/model/firebase/grupo_muscular_firebase.dart';

import '../../components/campo_input.dart';
import '../../components/drawer.dart';

class GrupoMuscularDetail extends StatefulWidget {
  const GrupoMuscularDetail({super.key});

  @override
  State<GrupoMuscularDetail> createState() => _GrupoMuscularDetailState();
}

class _GrupoMuscularDetailState extends State<GrupoMuscularDetail> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  GrupoMuscularFirebase grupoMuscularFirebase = GrupoMuscularFirebase();
  String retornoValidador = 'Campo obrigatório';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ListTraining'),
      ),
      drawer: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: DrawerExample(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<GrupoMuscular>>(
                stream: grupoMuscularFirebase.readGruposMusculares(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<GrupoMuscular>> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Algo deu errado"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("Nenhum Grupo Muscular encontrado"));
                  }

                  // Ordenando os exercícios por nome em ordem alfabética
                  final exerciciosOrdenados = snapshot.data!
                    ..sort((a, b) => a.nome.compareTo(b.nome));

                  return ListView(
                    children:
                        exerciciosOrdenados.map((GrupoMuscular grupoMuscular) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(grupoMuscular.nome),
                          subtitle: Text(grupoMuscular.id.toString()),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16), // Espaçamento antes do botão
            FloatingActionButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(
                height: 32), // Espaçamento adicional antes do fim da tela
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: formGrupoMuscular(),
            ),
          ],
        );
      },
    );
  }

  Widget formGrupoMuscular() {
    return Form(
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ajusta a altura da coluna ao mínimo necessário
        children: [
          const SizedBox(
            height: 50, // Definindo altura para o cabeçalho
            child: Center(
              child: Text(
                'Cadastro de Grupo Muscular',
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
              rotulo: 'Descrição',
              tipo: TextInputType.text,
              controller: _descricaoController,
              retornoValidador: retornoValidador),
          SizedBox(
            height: 50, // Definindo altura para o botão
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
                grupoMuscularFirebase.addGrupoMuscular(
                  cGrupoMuscular: GrupoMuscular(
                      nome: _nomeController.text,
                      descricao: _descricaoController.text),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
