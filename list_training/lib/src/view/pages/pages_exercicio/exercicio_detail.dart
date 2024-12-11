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

  // Variável para armazenar os grupos musculares carregados
  List<GrupoMuscular>? _gruposMusculares;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Carrega os dados do Stream uma vez no initState
    grupoMuscularFirebase.readGruposMusculares().listen((grupos) {
      setState(() {
        _gruposMusculares = grupos;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Exercicios',
            style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.deepPurple, // Cor do app bar
      ),
      drawer: DrawerExample(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 5, // Sombra suave no card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            exercicio.nome,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                          subtitle: Text(
                            exercicio.descricao.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditModal(context, exercicio);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmDelete(context, exercicio.id);
                                },
                              ),
                            ],
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

  // Mostra modal para adicionar novo exercício
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

  // Mostra modal para editar exercício existente
  void _showEditModal(BuildContext context, Exercicio exercicio) {
    _nomeController.text = exercicio.nome;
    _descricaoController.text = exercicio.descricao ?? '';
    _urlExplicacaoController.text = exercicio.urlExplicao ?? '';

    _grupoMuscularSelecionado = _gruposMusculares?.firstWhere(
            (grupo) => grupo.id == exercicio.idGrupoMuscular,
            orElse: () => GrupoMuscular(id: '', nome: '')) ??
        null;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: formExercicio(isEdit: true),
            ),
          ],
        );
      },
    );
  }

  // Confirmação para excluir um exercício
  void _confirmDelete(BuildContext context, String exercicioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text("Tem certeza que deseja excluir este exercício?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Excluir"),
              onPressed: () {
                exercicioFirebase.deleteExercicioById(exercicioId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget formExercicio({bool isEdit = false, String? exercicioId}) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título do formulário
          const SizedBox(
            height: 50,
            child: Center(
              child: Text(
                'Exercício',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dropdown para selecionar o grupo muscular
          if (!isEdit) dropdownGrupoMuscular(),

          // Campo para nome
          CampoInput(
            visibilidade: false,
            rotulo: 'Nome',
            tipo: TextInputType.name,
            controller: _nomeController,
            retornoValidador: retornoValidador,
          ),

          // Campo para descrição
          CampoInput(
            visibilidade: false,
            rotulo: 'Descrição',
            tipo: TextInputType.text,
            controller: _descricaoController,
            retornoValidador: retornoValidador,
          ),

          // Campo para URL
          CampoInput(
            visibilidade: false,
            rotulo: 'URL',
            tipo: TextInputType.url,
            controller: _urlExplicacaoController,
            retornoValidador: retornoValidador,
          ),

          const SizedBox(height: 24),

          // Botão de salvar com tamanho ajustado
          ElevatedButton.icon(
            icon: const Icon(Icons.add_task_rounded, color: Colors.white),
            label: const Text('Salvar', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple, // Cor do botão de salvar
              shape:
                  StadiumBorder(), // Estilo arredondado igual ao do botão de login
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 12), // Ajuste de tamanho do botão
            ),
            onPressed: () {
              if (_grupoMuscularSelecionado != null) {
                if (isEdit && exercicioId != null) {
                  exercicioFirebase.updateExercicio(
                    id: exercicioId,
                    cExercicio: Exercicio(
                      id: exercicioId,
                      nome: _nomeController.text,
                      descricao: _descricaoController.text,
                      urlExplicao: _urlExplicacaoController.text,
                      idGrupoMuscular: _grupoMuscularSelecionado!.id,
                    ),
                  );
                } else {
                  exercicioFirebase.addExercicio(
                    cExercicio: Exercicio(
                      nome: _nomeController.text,
                      descricao: _descricaoController.text,
                      urlExplicao: _urlExplicacaoController.text,
                      idGrupoMuscular: _grupoMuscularSelecionado!.id,
                    ),
                  );
                }
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Selecione um grupo muscular'),
                  ),
                );
              }

              // Limpar os campos do formulário
              _nomeController.clear();
              _descricaoController.clear();
              _urlExplicacaoController.clear();
              setState(() {
                _grupoMuscularSelecionado = null;
              });
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget dropdownGrupoMuscular() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    return SizedBox(
      width: 300,
      height: 60,
      child: DropdownButtonFormField<GrupoMuscular>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Grupo Muscular',
          prefixIcon: const Icon(Icons.fitness_center),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        hint: Text(
            _grupoMuscularSelecionado?.nome ?? 'Selecione um grupo muscular'),
        items: _gruposMusculares!
            .map<DropdownMenuItem<GrupoMuscular>>((GrupoMuscular grupo) {
          return DropdownMenuItem<GrupoMuscular>(
            value: grupo,
            child: Text(grupo.nome),
          );
        }).toList(),
        value: _grupoMuscularSelecionado,
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
      ),
    );
  }
}
