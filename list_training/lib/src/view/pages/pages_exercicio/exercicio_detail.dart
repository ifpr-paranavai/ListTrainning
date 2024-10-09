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
                          title: Text(exercicio.nome,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text(exercicio.descricao.toString()),
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
    // Preencher os campos com os dados do exercício para edição
    _nomeController.text = exercicio.nome;
    _descricaoController.text = exercicio.descricao ?? '';
    _urlExplicacaoController.text = exercicio.urlExplicao ?? '';

    // Encontrar o grupo muscular associado ao exercício
    _grupoMuscularSelecionado = _gruposMusculares?.firstWhere(
            (grupo) => grupo.id == exercicio.idGrupoMuscular,
            orElse: () => GrupoMuscular(id: '', nome: '')) ??
        null;

    // Exibir o modal de edição
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: formExercicio(isEdit: true), // Passando modo de edição
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
          if (!isEdit)
            dropdownGrupoMuscular(), // Só mostra o dropdown se não for edição
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
                  if (isEdit && exercicioId != null) {
                    // Atualizar o exercício existente
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
                    // Adicionar um novo exercício
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
                setState(
                  () {
                    _grupoMuscularSelecionado = null;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função para construir o DropdownButton
  Widget dropdownGrupoMuscular() {
    if (_isLoading) {
      return const CircularProgressIndicator(); // Indicador de carregamento
    }

    return SizedBox(
      width: 300,
      height: 100,
      child: DropdownButtonFormField<GrupoMuscular>(
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
        value: _grupoMuscularSelecionado, // Define o valor selecionado
        onChanged: (GrupoMuscular? novoGrupo) {
          setState(() {
            _grupoMuscularSelecionado =
                novoGrupo; // Atualiza o valor selecionado
          });
        },
        validator: (GrupoMuscular? value) {
          if (value == null) {
            return 'Campo obrigatório'; // Validação do campo
          }
          return null;
        },
      ),
    );
  }
}
