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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Itens do Treino: ${widget.treino.nome}'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ItensTreino>>(
                stream: itensTreinoFirebase.getItensTreino(
                    idTreino: widget.treino.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Algo deu errado"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Nenhum Item encontrado"));
                  }

                  final itensTreino = snapshot.data!;

                  return ListView.builder(
                    itemCount: itensTreino.length,
                    itemBuilder: (context, index) {
                      final item = itensTreino[index];
                      Exercicio? exercicio =
                          exercicioFirebase.getExercicioByIdF(item.idExercicio);
                      return GestureDetector(
                        onLongPress: () => _showItemOptions(context, item),
                        child: ListTile(
                          title: Text(item.idExercicio),
                          subtitle: Text(
                            'Peso: ${item.peso}, Repetições: ${item.repeticao}, Sequência: ${item.sequncia}',
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
              onPressed: () => _showAddItemModal(context),
              child: const Icon(Icons.add),
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
          StreamBuilder<List<Exercicio>>(
            stream: exercicioFirebase.readExercicios(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final exercicios = snapshot.data!;
              return DropdownButtonFormField<String>(
                value: _selectedExercicioId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedExercicioId = newValue;
                  });
                },
                items: exercicios.map((exercicio) {
                  return DropdownMenuItem<String>(
                    value: exercicio.id,
                    child: Text(exercicio.nome),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Exercício',
                  border: OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                validator: (value) => value == null ? retornoValidador : null,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              );
            },
          ),
          const SizedBox(height: 16),
          CampoInput(
            visibilidade: false,
            rotulo: 'Peso',
            tipo: TextInputType.number,
            controller: _pesoController,
            retornoValidador: retornoValidador,
          ),
          const SizedBox(height: 16),
          CampoInput(
            visibilidade: false,
            rotulo: 'Repetições',
            tipo: TextInputType.number,
            controller: _repeticaoController,
            retornoValidador: retornoValidador,
          ),
          const SizedBox(height: 16),
          CampoInput(
            visibilidade: false,
            rotulo: 'Sequência',
            tipo: TextInputType.number,
            controller: _sequenciaController,
            retornoValidador: retornoValidador,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              child: const Text('Salvar'),
            ),
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
