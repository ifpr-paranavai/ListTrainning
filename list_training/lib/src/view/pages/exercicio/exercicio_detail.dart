import 'package:flutter/material.dart';
import 'package:list_training/src/model/entidades/exercicio.dart';
import 'package:list_training/src/model/firebase/exercicio_firebse.dart';
import 'package:list_training/src/view/components/campo_input.dart';
import 'package:list_training/src/view/components/drawer.dart';

class ExercicioDetail extends StatefulWidget {
  const ExercicioDetail({super.key});

  @override
  State<ExercicioDetail> createState() => _ExercicioDetailState();
}

class _ExercicioDetailState extends State<ExercicioDetail> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _urlExplicacaoController = TextEditingController();
  ExercicioFirebase exercicioFirebase = ExercicioFirebase();
  String retornoValidador = 'Campo obrigatório';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Start Trainining'),
      ),
      drawer: DrawerExample(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Exercicio>>(
                stream: exercicioFirebase.readExercicios(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Exercicio>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Algo deu errado"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Nenhum exercício encontrado"));
                  }

                  return ListView(
                    children: snapshot.data!.map((Exercicio exercicio) {
                      return ListTile(
                        title: Text(exercicio.nome),
                        subtitle: Text(exercicio.descricao.toString()),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 16), // Espaçamento antes do botão
            FloatingActionButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              child: Icon(Icons.add),
            ),
            SizedBox(height: 32), // Espaçamento adicional antes do fim da tela
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
              child: formExercicio(),
            ),
          ],
        );
      },
    );
  }

  Widget formExercicio() {
    return Form(
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ajusta a altura da coluna ao mínimo necessário
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
              rotulo: 'Descrição',
              tipo: TextInputType.text,
              controller: _descricaoController,
              retornoValidador: retornoValidador),
          CampoInput(
              visibilidade: false,
              rotulo: 'Url',
              tipo: TextInputType.url,
              controller: _urlExplicacaoController,
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
                exercicioFirebase.addTreino(
                  cExercicio: Exercicio(
                    nome: _nomeController.text,
                    descricao: _descricaoController.text,
                    urlExplicao: _urlExplicacaoController.text,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
