import 'package:flutter/material.dart';
import 'package:list_training/src/model/entidades/exercicio.dart';
import 'package:list_training/src/model/entidades/grupo_muscular.dart';
import 'package:list_training/src/model/firebase/exercicio_firebse.dart';
import 'package:list_training/src/model/firebase/grupo_muscular_firebase.dart';
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
  GrupoMuscularFirebase grupoMuscularFirebase = GrupoMuscularFirebase();
  String retornoValidador = 'Campo obrigatório';

  // Variável para armazenar o grupo muscular selecionado
  GrupoMuscular? _grupoMuscularSelecionado;

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
              child: StreamBuilder<List<Exercicio>>(
                stream: exercicioFirebase.readExercicios(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Exercicio>> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Algo deu errado"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("Nenhum exercício encontrado"));
                  }

                  // Ordenando os exercícios por nome em ordem alfabética
                  final exerciciosOrdenados = snapshot.data!
                    ..sort((a, b) => a.nome.compareTo(b.nome));

                  return ListView(
                    children: exerciciosOrdenados.map((Exercicio exercicio) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(exercicio.nome),
                          subtitle: Text(exercicio.descricao.toString()),
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
          buildGrupoMuscularDropdown(), // Adicionando o Dropdown ao formulário
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
                if (_grupoMuscularSelecionado != null) {
                  exercicioFirebase.addExercicio(
                    cExercicio: Exercicio(
                      nome: _nomeController.text,
                      descricao: _descricaoController.text,
                      urlExplicao: _urlExplicacaoController.text,
                      idGrupoMuscular: _grupoMuscularSelecionado!.id,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecione um grupo muscular'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função separada para construir o DropdownButton
  Widget buildGrupoMuscularDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300, // Garantindo a mesma largura do CampoInput
        child: StreamBuilder<List<GrupoMuscular>>(
          stream: grupoMuscularFirebase.readGruposMusculares(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return DropdownButtonFormField<GrupoMuscular>(
              value: _grupoMuscularSelecionado,
              hint: const Text('Selecione um grupo muscular'),
              decoration: InputDecoration(
                label: const Text('Grupo Muscular'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: snapshot.data!.map((grupo) {
                return DropdownMenuItem<GrupoMuscular>(
                  value: grupo,
                  child: Text(grupo.nome),
                );
              }).toList(),
              onChanged: (GrupoMuscular? novoGrupo) {
                setState(() {
                  _grupoMuscularSelecionado = novoGrupo;
                });
              },
              validator: (GrupoMuscular? value) {
                if (value == null) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            );
          },
        ),
      ),
    );
  }
}
