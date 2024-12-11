import 'package:flutter/material.dart';
import 'package:list_training/src/model/entidades/treino.dart';
import 'package:list_training/src/model/entidades/itens_treino.dart';
import 'package:list_training/src/model/entidades/exercicio.dart';
import 'package:list_training/src/model/firebase/exercicio_firebse.dart';
import 'package:list_training/src/model/firebase/itens_treino_firebase.dart';

import 'package:list_training/src/view/components/campo_input.dart';

class ItensTreinoDetail extends StatefulWidget {
  final Treino treino;

  const ItensTreinoDetail({super.key, required this.treino});

  @override
  State<ItensTreinoDetail> createState() => _ItensTreinoDetailState();
}

class _ItensTreinoDetailState extends State<ItensTreinoDetail> {
  final ItensTreinoFirebase itensTreinoFirebase = ItensTreinoFirebase();
  final ExercicioFirebase exercicioFirebase = ExercicioFirebase();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _repeticaoController = TextEditingController();
  final TextEditingController _sequenciaController = TextEditingController();
  final String retornoValidador = 'Campo obrigatório';
  String? _selectedExercicioId;
  bool _isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.treino.nome}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<ItensTreino>>(
                future: itensTreinoFirebase.getItensTreinoFuture(
                    idTreino: widget.treino.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Algo deu errado"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Treino Cadastrado"));
                  }

                  final itensTreino = snapshot.data!;

                  // Pré-carregar os exercícios associados
                  return FutureBuilder<List<Exercicio>>(
                    future: Future.wait(itensTreino.map((item) async {
                      final exercicio = await exercicioFirebase
                          .getExercicioById(item.idExercicio);
                      return Exercicio(
                        nome: exercicio?.nome ?? "Desconhecido",
                        idGrupoMuscular: exercicio?.idGrupoMuscular ?? "",
                      );
                    })),
                    builder: (context, exercicioSnapshot) {
                      if (exercicioSnapshot.hasError) {
                        return const Center(
                            child: Text("Erro ao carregar exercícios"));
                      }

                      if (exercicioSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!exercicioSnapshot.hasData ||
                          exercicioSnapshot.data!.isEmpty) {
                        return const Center(
                            child:
                                Text("Nenhum exercício associado encontrado"));
                      }

                      final exercicios = exercicioSnapshot.data!;

                      return ListView.builder(
                        itemCount: itensTreino.length,
                        itemBuilder: (context, index) {
                          final item = itensTreino[index];
                          final exercicio = exercicios[index];

                          return GestureDetector(
                            onLongPress: () => _showItemOptions(context, item),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Título do Exercício e Switch
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          exercicio.nome,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Switch(
                                          value:
                                              _isSwitchOn, // Agora vinculado ao estado
                                          onChanged: (bool value) {
                                            setState(() {
                                              _isSwitchOn =
                                                  value; // Atualiza o estado com o novo valor
                                            });
                                          },
                                          activeColor: Colors
                                              .green, // Cor do switch quando ativado
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Linha de Detalhes com Ícones
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Botão de vídeo
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.play_circle_fill,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                // Abrir vídeo
                                              },
                                            ),
                                            const Text(
                                              "Vídeo",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Séries
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.loop,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${item.sequncia} Séries',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Repetições
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.fitness_center,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${item.repeticao} Repetições',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Carga
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            '${item.peso} kg',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () => _showAddItemModal(context),
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

  void _showAddItemModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _formItensTreino(onSave: () async {
                await itensTreinoFirebase.addItemParaTreino(
                  cItensTreino: ItensTreino(
                    idExercicio: _selectedExercicioId ?? '',
                    peso: double.parse(_pesoController.text),
                    repeticao: int.parse(_repeticaoController.text),
                    sequncia: int.parse(_sequenciaController.text),
                  ),
                  idTreino: widget.treino.id!,
                );

                _clearControllers();
                Navigator.pop(context);
              }),
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context, ItensTreino item) {
    _selectedExercicioId = item.idExercicio;
    _pesoController.text = item.peso.toString();
    _repeticaoController.text = item.repeticao.toString();
    _sequenciaController.text = item.sequncia.toString();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _formItensTreino(onSave: () async {
                await itensTreinoFirebase.updateItemTreino(
                  idTreino: widget.treino.id!,
                  idItemTreino: item.id!,
                  peso: double.parse(_pesoController.text),
                  repeticao: int.parse(_repeticaoController.text),
                  sequncia: int.parse(_sequenciaController.text),
                );

                _clearControllers();
                Navigator.pop(context);
              }),
            ),
          ],
        );
      },
    );
  }

  void _showItemOptions(BuildContext context, ItensTreino item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                _showEditModal(context, item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, widget.treino.id!, item.id!);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _formItensTreino({required VoidCallback onSave}) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 50,
            child: Center(
              child: Text(
                'Exercicios',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          StreamBuilder<List<Exercicio>>(
            stream: exercicioFirebase.readExercicios(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final exercicios = snapshot.data!;
              return SizedBox(
                width: 300,
                height: 60,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedExercicioId,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedExercicioId = newValue;
                    });
                  },
                  items: exercicios.map((exercicio) {
                    return DropdownMenuItem<String>(
                      value: exercicio.id,
                      child: Text(
                        exercicio.nome,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Exercício',
                    prefixIcon: const Icon(Icons.fitness_center),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  hint: const Text('Selecione um exercício'),
                  validator: (value) =>
                      value == null ? 'Campo obrigatório' : null,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  dropdownColor: Colors.purple[50],
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Colors.deepPurple),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          CampoInput(
            visibilidade: false,
            rotulo: 'Peso',
            tipo: TextInputType.number,
            controller: _pesoController,
            retornoValidador: 'Campo obrigatório',
          ),
          const SizedBox(height: 16),
          CampoInput(
            visibilidade: false,
            rotulo: 'Repetições',
            tipo: TextInputType.number,
            controller: _repeticaoController,
            retornoValidador: 'Campo obrigatório',
          ),
          const SizedBox(height: 16),
          CampoInput(
            visibilidade: false,
            rotulo: 'Sequência',
            tipo: TextInputType.number,
            controller: _sequenciaController,
            retornoValidador: 'Campo obrigatório',
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_task_rounded, color: Colors.white),
            label: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: onSave,
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _selectedExercicioId = null;
    _pesoController.clear();
    _repeticaoController.clear();
    _sequenciaController.clear();
  }

  void _confirmDelete(BuildContext context, String treinoId, String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: const Text("Deseja excluir este item?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Excluir"),
              onPressed: () async {
                await itensTreinoFirebase.deleteItemTreino(
                    idTreino: treinoId, idItemTreino: itemId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
