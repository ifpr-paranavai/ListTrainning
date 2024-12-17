import 'package:flutter/material.dart';
import 'package:list_training/src/model/entidades/treino.dart';
import 'package:list_training/src/model/entidades/itens_treino.dart';
import 'package:list_training/src/model/entidades/exercicio.dart';
import 'package:list_training/src/model/firebase/exercicio_firebse.dart';
import 'package:list_training/src/model/firebase/itens_treino_firebase.dart';
import 'package:list_training/src/model/firebase/treino_realizado_firebase.dart';

import 'package:list_training/src/view/components/campo_input.dart';

import '../../../model/entidades/treino_realizado.dart';

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
  List<ItensTreino> itensTreinoSwtich = [];

  TreinoRealizadoFirebase treinoRealizadoFirebase = TreinoRealizadoFirebase();

  Map<String, bool> _switchStates = {};

  Future<void> _finalizarTreino() async {
    if (_switchStates.isEmpty) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sem exercícios marcados'),
            content: const Text(
                'Por favor, marque pelo menos um exercício antes de finalizar o treino.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha a dialog manualmente
                },
              ),
            ],
          );
        },
      );
      return; // Adicionando return para evitar a execução do código abaixo caso o alerta seja mostrado
    }

    // Obtém os itens de treino
    final List<ItensTreino> itensTreino = await itensTreinoFirebase
        .getItensTreinoFuture(idTreino: widget.treino.id);

    // Cria uma lista para os itens de treino que foram marcados
    final List<ItensTreino> itensTreinoSwtich = [];

    // Filtra os itens de treino que foram marcados
    for (final item in itensTreino) {
      if (_switchStates[item.id] == true) {
        itensTreinoSwtich.add(item);
      }
    }

    // Cria o objeto TreinoRealizado com os dados do Treino
    final TreinoRealizado treinoRealizado = TreinoRealizado(
      idTreino: widget.treino.id, // ID do treino
      nome: widget.treino.nome, // Nome do treino
      data: DateTime.now(), // Data do treino realizado
    );

    // Chama a função para adicionar o treino realizado com os exercícios
    await treinoRealizadoFirebase.addTreinoRealizadoComExercicios(
      treinoRealizado: treinoRealizado,
      exerciciosRealizados: itensTreinoSwtich,
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false, // Impede que o usuário feche a dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Treino Finalizado'),
          content: const Text('Seu treino foi finalizado com sucesso!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a dialog manualmente
              },
            ),
          ],
        );
      },
    );

    // Define a duração para a exibição da Dialog (exemplo: 3 segundos)
    Future.delayed(const Duration(seconds: 3), () {
      // Fecha a Dialog automaticamente após 3 segundos
      Navigator.of(context).pop();
    });

    // Reseta o estado do switch após finalizar o treino
    setState(() {
      _switchStates = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.treino.nome} - ${widget.treino.descricao}',
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
                    return const Center(
                        child: Text("Nenhum Treino Encontrado"));
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
                                              _switchStates[item.id] ?? false,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _switchStates[item.id!] = value;
                                            });
                                          },
                                          activeColor: Colors.grey,
                                          inactiveTrackColor:
                                              Colors.grey.shade300,
                                          thumbColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                            return states.contains(
                                                    MaterialState.selected)
                                                ? Colors.green
                                                : Colors.grey;
                                          }),
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
                                        // Carga (Peso) - Editable
                                        GestureDetector(
                                          onTap: () {
                                            showEditPesoDialog(context, item,
                                                widget.treino.id!);
                                          },
                                          child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: () => _showAddItemModal(context),
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _finalizarTreino();
                    },
                    icon:
                        const Icon(Icons.add_task_rounded, color: Colors.white),
                    label: const Text(
                      'Finalizar Treino',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
              ],
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
            rotulo: 'Séries',
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
            onPressed: () {
              onSave();
              setState(() {});
            },
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

  void showEditPesoDialog(
      BuildContext context, ItensTreino item, String treinoId) {
    TextEditingController pesoController =
        TextEditingController(text: item.peso.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alterar Peso'),
          content: TextField(
            controller: pesoController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                // Obter o novo peso do campo de texto
                double novoPeso =
                    double.tryParse(pesoController.text) ?? item.peso;

                // Atualiza o peso localmente
                setState(() {
                  item.peso = novoPeso;
                });

                // Chama a função para atualizar o peso no banco de dados
                itensTreinoFirebase.atualizarPesoNoBanco(
                  item.id,
                  treinoId,
                  novoPeso,
                );

                // Fecha o diálogo
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
